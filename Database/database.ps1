#region Imports
Import-Module PSSQLite
#endregion

#region variables
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
function Clear-Database {
    Invoke-SqliteQuery -Query "DROP TABLE IF EXISTS SENSOR" -SQLiteConnection $conn
    Invoke-SqliteQuery -Query $creatQuerry -SQLiteConnection $conn
}

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

# test function
# Add-SensorData -pi 1 -pin 1 -timestamp "2021-01-01 00:00:00" -value_data "10"