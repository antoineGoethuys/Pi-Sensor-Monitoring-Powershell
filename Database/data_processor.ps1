. "$PSScriptRoot/database.ps1"

function Sync-Data {
    param(
        [int32]$Pi,
        [string]$IP,
        [string]$port
    )
    $data = Get-SensorData -IP $IP -port $port
    # $data.timestamp | Out-GridView
    # $data.data | Out-GridView

    foreach ($row in $data.data) {
        foreach ($property in $row.psobject.Properties) {
            # Write-Output "$($pro perty.Name) = $($property.Value)"
            Add-SensorData -pi $Pi -pin $property.Name -timestamp $data.timestamp -value_data $property.Value
            # Add-SensorData -pi $Pi -pin $property.Name -timestamp $data.timestamp -value_data $property.Value
        }
    }
}

function Start-Sync-Data {
    param(
        [int32]$Pi,
        [string]$IP,
        [string]$port
    )
    Clear-Database
    while ($true) {
        Sync-Data -Pi $Pi -IP $IP -port $port
        Start-Sleep -Seconds 5
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