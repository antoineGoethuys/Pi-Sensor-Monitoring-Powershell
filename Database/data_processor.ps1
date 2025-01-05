. "$PSScriptRoot/database.ps1"

<#
.SYNOPSIS
    Synchronizes sensor data from a specified Pi.
.PARAMETER Pi
    The Pi identifier.
.PARAMETER IP
    The IP address of the Pi.
.PARAMETER port
    The port to connect to for retrieving sensor data.
#>
function Sync-Data {
    param(
        [ValidateNotNullOrEmpty()]
        [int32]$Pi,
        
        [ValidateNotNullOrEmpty()]
        [string]$IP,
        
        [ValidateNotNullOrEmpty()]
        [string]$port
    )
    try {
        $data = Get-SensorData -IP $IP -port $port
        if (-not $data) {
            throw "Failed to retrieve sensor data."
        }

        foreach ($row in $data.data) {
            foreach ($property in $row.psobject.Properties) {
                Add-SensorData -pi $Pi -pin $property.Name -timestamp $data.timestamp -value_data $property.Value
            }
        }
    }
    catch {
        Write-Error "Failed to sync data: $_"
    }
}

<#
.SYNOPSIS
    Starts continuous synchronization of sensor data from a specified Pi.
.PARAMETER Pi
    The Pi identifier.
.PARAMETER IP
    The IP address of the Pi.
.PARAMETER port
    The port to connect to for retrieving sensor data.
#>
function Start-Sync-Data {
    param(
        [ValidateNotNullOrEmpty()]
        [int32]$Pi,
        
        [ValidateNotNullOrEmpty()]
        [string]$IP,
        
        [ValidateNotNullOrEmpty()]
        [string]$port
    )
    try {
        Clear-Database
        while ($true) {
            Sync-Data -Pi $Pi -IP $IP -port $port
            Start-Sleep -Seconds 5
        }
    }
    catch {
        Write-Error "Failed to start data sync: $_"
    }
}

# test function
# Get-SensorDataOfPinLog -IP "10.0.0.254" -port "8000" -pin "20"
# Get-SensorDataOfPinStatus -IP "10.0.0.254" -port "8000" -pin "20"
# Get-SensorData -IP "10.0.0.254" -port "8000"

# Clear-Database
Sync-Data -Pi 1 -IP "10.0.0.254" -port "8000"
Sync-Data -Pi 2 -IP "10.0.0.254" -port "8000"
Start-Sleep -Seconds 5
Sync-Data -Pi 1 -IP "10.0.0.254" -port "8000"
Sync-Data -Pi 2 -IP "10.0.0.254" -port "8000"
Start-Sleep -Seconds 5
Sync-Data -Pi 1 -IP "10.0.0.254" -port "8000"
Sync-Data -Pi 2 -IP "10.0.0.254" -port "8000"
Start-Sleep -Seconds 5

# test function get data from database
# # get all data
# $sensorData1 = Get-AllSqliteData
# $sensorData1 | Out-GridView

# # get data from pi 1
# $sensorData2 = Get-PiSqliteData -pi 1
# $sensorData2 | Out-GridView

# # get last data from all pi
# $sensorData3 = Get-PiPinSqliteDataLastOfAllPins -pi 1
# $sensorData3 | Out-GridView