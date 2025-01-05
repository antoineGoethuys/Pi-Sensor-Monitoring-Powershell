# Pi-Sensor-Monitoring-Powershell
A system that helps manage and monitor sensors that are connected to Pi's via powershell

---

# Project Composition 
## client/server

## Sensors/api

add schema
===
# Setup
## for setup the client part
### Prerequisites
#### PowerShell: 
  Ensure you have PowerShell installed. You can download it from Microsoft's official site.
### Installation
1. Clone the repository:
```
git clone https://github.com/antoineGoethuys/Pi-Sensor-Monitoring-Powershell.git
cd Pi-Sensor-Monitoring-Powershell
```
2. Navigate to the project directory:
```
cd Pi-Sensor-Monitoring-Powershell
```
### Running the PowerShell Scripts
1. Run the main PowerShell script:
```
pwsh main.ps1
```
## for setup the pi parts
### Prerequisites
#### Python: 
  Ensure you have Python installed. You can download it from python.org.
#### Pip: 
  Ensure you have pip installed. It usually comes with Python.

### Installation
Connect you to your pi
1. Clone the repository:
```
git clone https://github.com/antoineGoethuys/Pi-Sensor-Monitoring-Powershell.git
```

2. Navigate to the **Sensor** directory:
```
cd Pi-Sensor-Monitoring-Powershell/Sensor
```

3. Install the required Python packages:
```
pip install -r requirements.txt
```
### Running
```
python api.py
```
This will start the FastAPI server on http://0.0.0.0:8000. You can access the endpoints defined in the script.

---

## Functions

### PowerShell

#### `api.ps1`

##### `Get-SensorDataOfPinLog`
- **Purpose**: Retrieves the log data of a specific GPIO pin from the API.
- **Details**: 
  - Takes the IP address, port, and pin number as parameters.
  - Constructs the URL and sends a GET request to the API.
  - Returns the response.

##### `Get-SensorDataOfPinStatus`
- **Purpose**: Retrieves the current status of a specific GPIO pin from the API.
- **Details**: 
  - Takes the IP address, port, and pin number as parameters.
  - Constructs the URL and sends a GET request to the API.
  - Returns the response.

##### `Get-SensorData`
- **Purpose**: Retrieves the status of all GPIO pins from the API.
- **Details**: 
  - Takes the IP address and port as parameters.
  - Constructs the URL and sends a GET request to the API.
  - Returns the response.

#### `database.ps1`

##### `Clear-Database`
- **Purpose**: Clears the existing database and creates a new table for sensor data.
- **Details**: 
  - Drops the existing `SENSOR` table if it exists.
  - Creates a new `SENSOR` table with columns for id, pi, pin, timestamp, and value_data.

##### `Add-SensorData`
- **Purpose**: Adds a new sensor data entry to the database.
- **Details**: 
  - Takes the pi number, pin number, timestamp, and value data as parameters.
  - Constructs an INSERT query and executes it to add the data to the `SENSOR` table.

##### `Get-AllSqliteData`
- **Purpose**: Retrieves all sensor data from the database.
- **Details**: 
  - Executes a SELECT query to retrieve all rows from the `SENSOR` table.
  - Returns the response.

##### `Get-PiSqliteData`
- **Purpose**: Retrieves all sensor data for a specific Pi from the database.
- **Details**: 
  - Takes the pi number as a parameter.
  - Executes a SELECT query to retrieve all rows for the specified Pi from the `SENSOR` table.
  - Returns the response.

##### `Get-PiPinSqliteData`
- **Purpose**: Retrieves all sensor data for a specific Pi and pin from the database.
- **Details**: 
  - Takes the pi number and pin number as parameters.
  - Executes a SELECT query to retrieve all rows for the specified Pi and pin from the `SENSOR` table.
  - Returns the response.

##### `Get-PiPinSqliteDataLastOfAllPins`
- **Purpose**: Retrieves the latest sensor data for all pins of a specific Pi from the database.
- **Details**: 
  - Takes the pi number as a parameter.
  - Executes a SELECT query to retrieve the latest rows for all pins of the specified Pi from the `SENSOR` table.
  - Returns the response.

#### `data_processor.ps1`

##### `Sync-Data`
- **Purpose**: Synchronizes sensor data from the API to the local database.
- **Details**: 
  - Takes the Pi number, IP address, and port as parameters.
  - Retrieves sensor data from the API.
  - Iterates over the data and adds each entry to the local database.

##### `Start-Sync-Data`
- **Purpose**: Continuously synchronizes sensor data from the API to the local database.
- **Details**: 
  - Takes the Pi number, IP address, and port as parameters.
  - Clears the existing database.
  - Continuously calls `Sync-Data` in a loop with a sleep interval of 5 seconds.

#### `screen.ps1`

##### `Set-Form`
- **Purpose**: Creates and configures a new Windows Form.
- **Details**: 
  - Takes the form text, width, and height as parameters.
  - Configures the form properties and returns the form object.

##### `Add-tabPage`
- **Purpose**: Adds a new tab page to a tab control.
- **Details**: 
  - Takes the tab control and tab text as parameters.
  - Creates a new tab page, configures its properties, and adds it to the tab control.
  - Returns the tab page object.

##### `Add-TabControl`
- **Purpose**: Adds a new tab control to a parent control.
- **Details**: 
  - Takes the parent control, width, height, and location as parameters.
  - Creates a new tab control, configures its properties, and adds it to the parent control.
  - Returns the tab control object.

##### `Add-Button`
- **Purpose**: Adds a new button to a parent control.
- **Details**: 
  - Takes the parent control, button text, location, width, and height as parameters.
  - Creates a new button, configures its properties, and adds it to the parent control.
  - Returns the button object.

##### `Add-Table`
- **Purpose**: Adds a new data grid view (table) to a parent control.
- **Details**: 
  - Takes the parent control, width, height, and location as parameters.
  - Creates a new data grid view, configures its properties, and adds it to the parent control.
  - Returns the table object.

##### `Set-Table`
- **Purpose**: Populates a data grid view (table) with data.
- **Details**: 
  - Takes the table and data array as parameters.
  - Clears existing rows, sets the column count, and populates the table with the provided data.

##### `Test-ValuesAndNotify`
- **Purpose**: Checks sensor values and displays a notification if an incorrect value is detected.
- **Details**: 
  - Takes the Pi number, pin number, start time, and end time as parameters.
  - Retrieves the latest sensor data for the specified Pi and pin from the database.
  - Checks if the value is incorrect and displays a notification if necessary.

##### `Add-Chart`
- **Purpose**: Adds a new chart to a parent control.
- **Details**: 
  - Takes the parent control, width, height, and location as parameters.
  - Creates a new chart, configures its properties, and adds it to the parent control.
  - Returns the chart object.

##### `Set-Chart`
- **Purpose**: Populates a chart with data.
- **Details**: 
  - Takes the chart and data array as parameters.
  - Clears existing series, creates a new series, and populates the chart with the provided data.
---

## Endpoints api of sensor

Get GPIO status:
```
GET /gpio
```
Get specific GPIO pin status:
```
GET /gpio/{pin}
```
Get GPIO pin log:
```
GET /gpio/{pin}/log
```

---

# Project To-Do List

## Core Tasks
- [x] Store sensor data in SQLite database
- [x] Develop a real-time monitoring dashboard
- [x] Set up notifications for abnormal sensor values
- [ ] Create configuration pages:
  - [ ] Raspberry Pi settings (network config, naming)
    - [x] Ip adress
  - [ ] Sensor settings (data type, value deviations)

## Sensor Integration
- [x] Integrate and test Light-Sensor functionality

## Extended Features
- [ ] Add support for new sensors:
  - [ ] Tilting sensor
  - [ ] 3-axis digital accelerometer
  - [ ] Line finder
  - [ ] DHT11
- [ ] Enable file-based configuration for sensors/Pi
- [ ] Implement historical data analysis and reporting
- [ ] Set up cloud storage integration for data backup
- [ ] Group Raspberry Pi and sensors into clusters
- [ ] Connect to IoT platforms:
  - [ ] Home Assistant
  - [ ] AWS IoT
  - [ ] Azure IoT
  - [ ] Google Cloud IoT
- [ ] Develop a map feature for Pi locations
- [ ] Add external module interaction (e.g., motors, actuators)
- [ ] Monitor Raspberry Pi hardware metrics (CPU, battery, RAM)
- [ ] Implement data pattern recognition
- [ ] Create an integrated tutorial

## Support Tasks
- [ ] Set up Docker environment
- [x] Configure Git for version control
- [x] Configure SQLite database
- [ ] Acquire and test sensor modules

## Documentation
- [x] Write installation and configuration guide
- [ ] Create sensor-specific documentation
- [ ] Develop interface tutorial (optional)

## Testing and Structure
- [ ] Implement Pester unit tests with mockups
- [x] Apply microservices architecture for code structure

## Risk Management
- [ ] Plan for hardware/software compatibility issues
- [ ] Address security risks for networked sensors


---

# sources: 
- co-pilot
- official documentation of Microsoft Powershell
- official documentation of python (sqlite / threading / signal / sys / time)
- documentation of RPi.GPIO / uvicorn / fastapi
- [tutorial SQLite Powershell](https://www.youtube.com/watch?v=oIodLO-L24Q)