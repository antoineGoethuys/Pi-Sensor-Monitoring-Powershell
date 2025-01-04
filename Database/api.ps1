function Get-SensorDataOfPinLog {
    param(
        [string]$IP,
        [string]$port,
        [ string]$pin
    )
    $url = "${IP}:${port}/gpio/${pin}/log"
    $response = Invoke-RestMethod -Uri $url -Method 'Get'
    return $response
}

function Get-SensorDataOfPinStatus {
    param(
        [string]$IP,
        [string]$port,
        [ string]$pin
    )
    $url = "${IP}:${port}/gpio/${pin}"
    $response = Invoke-RestMethod -Uri $url -Method 'Get'
    return $response
}

function Get-SensorData {
    param(
        [string]$IP,
        [string]$port
    )
    $url = "${IP}:${port}/gpio"
    $response = Invoke-RestMethod -Uri $url -Method 'Get'
    return $response
}

