# Pi-Sensor-Monitoring-Powershell
A system that helps manage and monitor sensors that are connected to Pi's via powershell

---

# Project To-Do List

## Core Tasks
- [ ] Store sensor data in SQLite database
- [ ] Develop a real-time monitoring dashboard
- [ ] Set up notifications for abnormal sensor values
- [ ] Create configuration pages:
  - [ ] Raspberry Pi settings (network config, naming)
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
- [ ] Write installation and configuration guide
- [ ] Create sensor-specific documentation
- [ ] Develop interface tutorial (optional)

## Testing and Structure
- [ ] Implement Pester unit tests with mockups
- [ ] Apply microservices architecture for code structure

## Risk Management
- [ ] Plan for hardware/software compatibility issues
- [ ] Address security risks for networked sensors


---

# sources: 
- copilot
- official documentation of Microsoft Powershell
- official documentation of python (sqlite / threading / signal / sys / time)
- documentation of RPi.GPIO / uvicorn / fastapi