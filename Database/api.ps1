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