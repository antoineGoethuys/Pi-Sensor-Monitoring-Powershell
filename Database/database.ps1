#region Imports
Import-Module PSSQLite
#endregion

#region variables
$ports = ":8000"
$IP = "10.0.0.254"
$baseUrl = $IP + $ports

$database = "./Database/Sensor.db"
$conn = New-SQLiteConnection -DataSource $database
# $conn

$creatQuerry =  
"CREATE TABLE SENSOR 
(
    id INTEGER PRIMARY KEY,
    pi INTEGER,
    pin INTEGER,
    timestamp TEXT,
    value_data TEXT 
)
"
#endregion

#region Database
Invoke-SqliteQuery -Query "DROP TABLE IF EXISTS SENSOR" -SQLiteConnection $conn
Invoke-SqliteQuery -Query $creatQuerry -SQLiteConnection $conn

function Add-SensorData {
    param (
        [int]$pi,
        [int]$pin,
        [string]$timestamp,
        [string]$value_data
    )
    $insertQuery = "INSERT INTO SENSOR (pi, pin, timestamp, value_data) VALUES ($pi, $pin, '$timestamp', '$value_data')"
    Invoke-SqliteQuery -Query $insertQuery -SQLiteConnection $conn
}

function Get-AllSqliteData {
    $query = "SELECT * FROM SENSOR"
    $response = Invoke-SqliteQuery -Query $query -SQLiteConnection $conn
    return $response
    
}

function Get-PiSqliteData {
    param (
        [int]$pi
    )
    $query = "SELECT * FROM SENSOR WHERE pi = $pi"
    $response = Invoke-SqliteQuery -Query $query -SQLiteConnection $conn
    return $response    
}

function Get-PiPinSqliteData {
    param (
        [int]$pi,
        [int]$pin
    )
    $query = "SELECT * FROM SENSOR WHERE pi = $pi AND pin = $pin"
    $response = Invoke-SqliteQuery -Query $query -SQLiteConnection $conn
    return $response    
    
}
#endregion

#region Gpio

# Function to get the status of all GPIO pins
function Get-AllGpioStatus {
    $url = "$baseUrl/gpio"
    $response = Invoke-RestMethod -Uri $url -Method 'Get'
    return $response
}
# Function to get the status of a specific GPIO pin
function Get-GpioPinStatus {
    param (
        [int]$pin
    )
    $url = "$baseUrl/gpio/$pin"
    $response = Invoke-RestMethod -Uri $url -Method Get
    return $response
}
# Function to get the log of a specific GPIO pin
function Get-GpioPinLog {
    param (
        [int]$pin
    )
    $url = "$baseUrl/gpio/$pin/log"
    $response = Invoke-RestMethod -Uri $url -Method Get
    return $response
}
function Get-LastPiPinSqliteData {
    param (
        [int]$pi,
        [int]$pin
    )
    $query = "SELECT * FROM SENSOR WHERE pi = $pi AND pin = $pin ORDER BY timestamp DESC LIMIT 1"
    $response = Invoke-SqliteQuery -Query $query -SQLiteConnection $conn
    return $response    
}
#endregion

#region functionsFillDatabase
function FillDatabase {
    $allPinsStatus = Get-AllGpioStatus
    foreach ($pin in $allPinsStatus) {
        $pinStatus = Get-GpioPinStatus -pin $pin.pin
        Add-SensorData -pi 1 -pin $pin.pin -timestamp $pinStatus.timestamp -value_data $pinStatus.value
        $pinLog = Get-GpioPinLog -pin $pin.pin
        foreach ($log in $pinLog) {
            Add-SensorData -pi 1 -pin $pin.pin -timestamp $log.timestamp -value_data $log.value
        }
    }
}
#endregion

#region test all functions
# FillDatabase
# Get-AllSqliteData
# Get-PiSqliteData -pi 1
# Get-PiPinSqliteData -pi 1 -pin 1
# Get-AllGpioStatus | Out-GridView
# Get-GpioPinStatus -pin 1 | Out-GridView
# Get-GpioPinLog -pin 1 | Out-GridView 
# Get-LastPiPinSqliteData -pi 1 -pin 1 | Out-GridView
#endregion
