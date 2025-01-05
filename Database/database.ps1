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
<#
.SYNOPSIS
    Clears the database by dropping the SENSOR table if it exists and creating a new one.
#>
function Clear-Database {
    try {
        Invoke-SqliteQuery -Query "DROP TABLE IF EXISTS SENSOR" -SQLiteConnection $conn
        Invoke-SqliteQuery -Query $creatQuerry -SQLiteConnection $conn
    }
    catch {
        Write-Error "Failed to clear database: $_"
    }
}

<#
.SYNOPSIS
    Adds sensor data to the database.
.PARAMETER pi
    The Pi identifier.
.PARAMETER pin
    The pin identifier.
.PARAMETER timestamp
    The timestamp of the data.
.PARAMETER value_data
    The value of the data.
#>
function Add-SensorData {
    param (
        [ValidateNotNullOrEmpty()]
        [int]$pi,
        
        [ValidateNotNullOrEmpty()]
        [int]$pin,
        
        [ValidateNotNullOrEmpty()]
        [string]$timestamp,
        
        [ValidateNotNullOrEmpty()]
        [string]$value_data
    )
    try {
        $insertQuery = "INSERT INTO SENSOR (pi, pin, timestamp, value_data) VALUES ($pi, $pin, '$timestamp', '$value_data')"
        Invoke-SqliteQuery -Query $insertQuery -SQLiteConnection $conn
    }
    catch {
        Write-Error "Failed to add sensor data: $_"
    }
}

<#
.SYNOPSIS
    Retrieves all data from the SENSOR table.
#>
function Get-AllSqliteData {
    try {
        $query = "SELECT * FROM SENSOR"
        $response = Invoke-SqliteQuery -Query $query -SQLiteConnection $conn
        return $response
    }
    catch {
        Write-Error "Failed to get all SQLite data: $_"
    }
}

<#
.SYNOPSIS
    Retrieves data from the SENSOR table for a specific Pi.
.PARAMETER pi
    The Pi identifier.
#>
function Get-PiSqliteData {
    param (
        [ValidateNotNullOrEmpty()]
        [int]$pi
    )
    try {
        $query = "SELECT * FROM SENSOR WHERE pi = $pi"
        $response = Invoke-SqliteQuery -Query $query -SQLiteConnection $conn
        return $response    
    }
    catch {
        Write-Error "Failed to get Pi SQLite data: $_"
    }
}

<#
.SYNOPSIS
    Retrieves data from the SENSOR table for a specific Pi and pin.
.PARAMETER pi
    The Pi identifier.
.PARAMETER pin
    The pin identifier.
#>
function Get-PiPinSqliteData {
    param (
        [ValidateNotNullOrEmpty()]
        [int]$pi,
        
        [ValidateNotNullOrEmpty()]
        [int]$pin
    )
    try {
        $query = "SELECT * FROM SENSOR WHERE pi = $pi AND pin = $pin"
        $response = Invoke-SqliteQuery -Query $query -SQLiteConnection $conn
        return $response    
    }
    catch {
        Write-Error "Failed to get Pi Pin SQLite data: $_"
    }
}

<#
.SYNOPSIS
    Retrieves the last data entries for all pins of a specific Pi.
.PARAMETER pi
    The Pi identifier.
#>
function Get-PiPinSqliteDataLastOfAllPins {
    param (
        [ValidateNotNullOrEmpty()]
        [int]$pi
    )
    try {
        $query = "SELECT * FROM SENSOR WHERE pi = $pi ORDER BY id DESC LIMIT 26"
        $response = Invoke-SqliteQuery -Query $query -SQLiteConnection $conn
        if ($response.Count -eq 0) {
            return ""
        }
        return $response
    }
    catch {
        Write-Error "Failed to get last Pi Pin SQLite data of all pins: $_"
    }
}
# test function
# Add-SensorData -pi 1 -pin 1 -timestamp "2021-01-01 00:00:00" -value_data "10"