<#
.SYNOPSIS
    Retrieves the log data of a specific pin from the sensor.
.PARAMETER IP
    The IP address of the Pi.
.PARAMETER port
    The port to connect to for retrieving sensor data.
.PARAMETER pin
    The pin identifier.
#>
function Get-SensorDataOfPinLog {
    param(
        [ValidateNotNullOrEmpty()]
        [string]$IP,
        
        [ValidateNotNullOrEmpty()]
        [string]$port,
        
        [ValidateNotNullOrEmpty()]
        [string]$pin
    )
    try {
        $url = "${IP}:${port}/gpio/${pin}/log"
        $response = Invoke-RestMethod -Uri $url -Method 'Get'
        return $response
    }
    catch {
        Write-Error "Failed to get sensor data of pin log: $_"
    }
}

<#
.SYNOPSIS
    Retrieves the status data of a specific pin from the sensor.
.PARAMETER IP
    The IP address of the Pi.
.PARAMETER port
    The port to connect to for retrieving sensor data.
.PARAMETER pin
    The pin identifier.
#>
function Get-SensorDataOfPinStatus {
    param(
        [ValidateNotNullOrEmpty()]
        [string]$IP,
        
        [ValidateNotNullOrEmpty()]
        [string]$port,
        
        [ValidateNotNullOrEmpty()]
        [string]$pin
    )
    try {
        $url = "${IP}:${port}/gpio/${pin}"
        $response = Invoke-RestMethod -Uri $url -Method 'Get'
        return $response
    }
    catch {
        Write-Error "Failed to get sensor data of pin status: $_"
    }
}

<#
.SYNOPSIS
    Retrieves all sensor data from the Pi.
.PARAMETER IP
    The IP address of the Pi.
.PARAMETER port
    The port to connect to for retrieving sensor data.
#>
function Get-SensorData {
    param(
        [ValidateNotNullOrEmpty()]
        [string]$IP,
        
        [ValidateNotNullOrEmpty()]
        [string]$port
    )
    try {
        $url = "${IP}:${port}/gpio"
        $response = Invoke-RestMethod -Uri $url -Method 'Get'
        return $response
    }
    catch {
        Write-Error "Failed to get sensor data: $_"
    }
}