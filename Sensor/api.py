import time
import sqlite3
import threading
import signal
import sys
from fastapi import FastAPI
import RPi.GPIO as GPIO
import uvicorn
from datetime import datetime  # Add this import

app = FastAPI()
stop_event = threading.Event()

def read_gpio_pins():
    """
    Reads the status of GPIO pins.

    Returns:
        dict: A dictionary with pin numbers as keys and their status (HIGH/LOW) as values.
    """
    GPIO.setmode(GPIO.BCM)
    pin_values = {}
    
    for pin in range(2, 28):
        GPIO.setup(pin, GPIO.IN)
        pin_values[pin] = GPIO.input(pin)
    
    return pin_values

def log_to_db(pin, value) -> None:
    """
    Logs the status of a GPIO pin to the database.

    Args:
        pin (int): The GPIO pin number.
        value (int): The status of the pin (HIGH/LOW).
    """
    conn = sqlite3.connect('gpio_data.db')
    cursor = conn.cursor()
    cursor.execute(
        '''
        CREATE TABLE IF NOT EXISTS gpio_log
        (timestamp TEXT, pin INTEGER, value TEXT)
        '''
    )
    cursor.execute(
        '''
        INSERT INTO gpio_log (timestamp, pin, value)
        VALUES (datetime('now'), ?, ?)
        ''',
        (pin, 'HIGH' if value else 'LOW')
    )
    conn.commit()
    conn.close()

def monitor_gpio_pins():
    """
    Monitors the GPIO pins for changes and logs them to the database.
    """
    previous_values = read_gpio_pins()
    try:
        while not stop_event.is_set():
            current_values = read_gpio_pins()
            for pin, value in current_values.items():
                if value != previous_values[pin]:
                    print(f"Pin {pin}: {'HIGH' if value else 'LOW'}")
                    log_to_db(pin, value)
                    previous_values[pin] = value
            time.sleep(1)  # Adjust the sleep time as needed
    except KeyboardInterrupt:
        GPIO.cleanup()

@app.get("/gpio")
def get_gpio_status():
    """
    Retrieves the status of all GPIO pins.

    Returns:
        dict: A dictionary with the current timestamp and the status of all GPIO pins.
    """
    return {
        "timestamp": datetime.now().isoformat(),  # Add timestamp
        "data": read_gpio_pins()
    }

@app.get("/gpio/{pin}")
def get_gpio_pin_status(pin: int):
    """
    Retrieves the status of a specific GPIO pin.

    Args:
        pin (int): The GPIO pin number.

    Returns:
        dict: A dictionary with the current timestamp and the status of the specified GPIO pin.
    """
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(pin, GPIO.IN)
    return {
        "timestamp": datetime.now().isoformat(),  # Add timestamp
        "data": {pin: GPIO.input(pin)}
    }

@app.get("/gpio/{pin}/log")
def get_gpio_pin_log(pin: int):
    """
    Retrieves the log data of a specific GPIO pin.

    Args:
        pin (int): The GPIO pin number.

    Returns:
        dict: A dictionary with the current timestamp and the log data of the specified GPIO pin.
    """
    conn = sqlite3.connect('gpio_data.db')
    cursor = conn.cursor()
    cursor.execute(
        '''
        SELECT timestamp, value FROM gpio_log WHERE pin = ? ORDER BY timestamp
        ''',
        (pin,)
    )
    log = cursor.fetchall()
    conn.close()
    return {
        "timestamp": datetime.now().isoformat(),  # Add timestamp
        "data": {pin: log}
    }

def start_api():
    """
    Starts the FastAPI server.
    """
    uvicorn.run(app, host="0.0.0.0", port=8000)

def signal_handler(sig, frame):
    """
    Handles the SIGINT signal to gracefully shut down the application.

    Args:
        sig (int): The signal number.
        frame (frame object): The current stack frame.
    """
    print("KeyboardInterrupt detected, shutting down...")
    stop_event.set()
    GPIO.cleanup()
    sys.exit(0)

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)
    monitor_thread = threading.Thread(target=monitor_gpio_pins)
    monitor_thread.start()

    start_api()