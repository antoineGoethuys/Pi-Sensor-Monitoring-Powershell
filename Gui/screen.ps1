#region Add Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms.DataVisualization
#endregion

function Set-Form {
    param (
        [ValidateNotNullOrEmpty()]
        [string]$formText,
        
        [ValidateRange(100, 2000)]
        [int]$formWidth,
        
        [ValidateRange(100, 2000)]
        [int]$formHeight
    )
    try {
        $form = New-Object System.Windows.Forms.Form
        $form.Text = $formText
        $form.Size = New-Object System.Drawing.Size($formWidth, $formHeight)
        $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
        $form.MaximizeBox = $false
        $form.MinimizeBox = $false
        $form.StartPosition = "CenterScreen"
        $form.AutoScroll = $true
        return $form
    }
    catch {
        Write-Error "Failed to create form: $_"
    }
}

function Add-tabPage {
    param (
        [System.Windows.Forms.TabControl]$tabControl,
        [string]$tabText
    )
    $tabPage = New-Object System.Windows.Forms.TabPage
    $tabPage.Text = $tabText
    $tabPage.AutoScroll = $true
    $tabControl.TabPages.Add($tabPage)
    return $tabPage
}

function Add-TabControl {
    param (
        [System.Windows.Forms.Control]$parentControl,
        [int]$tabControlWidth,
        [int]$tabControlHeight,
        [int]$tabControlLocationX,
        [int]$tabControlLocationY
    )
    $tabControl = New-Object System.Windows.Forms.TabControl
    $tabControl.Size = New-Object System.Drawing.Size($tabControlWidth, $tabControlHeight)
    $tabControl.Location = New-Object System.Drawing.Point($tabControlLocationX, $tabControlLocationY)
    $parentControl.Controls.Add($tabControl)
    return $tabControl
}

function Add-Button {
    param (
        [System.Windows.Forms.Control]$parentControl,
        
        [ValidateNotNullOrEmpty()]
        [string]$buttonText,
        
        [int]$buttonLocationX,
        [int]$buttonLocationY,
        
        [int]$buttonWidth = 100,
        [int]$buttonHeight = 30
    )
    try {
        $button = New-Object System.Windows.Forms.Button
        $button.Text = $buttonText
        $button.Location = New-Object System.Drawing.Point($buttonLocationX, $buttonLocationY)
        $button.Size = New-Object System.Drawing.Size($buttonWidth, $buttonHeight)
        $parentControl.Controls.Add($button)
        return $button
    }
    catch {
        Write-Error "Failed to add button: $_"
    }
}

function Add-Table {
    param (
        [System.Windows.Forms.Control]$parentControl,
        [int]$tableWidth,
        [int]$tableHeight,
        [int]$tableLocationX,
        [int]$tableLocationY
    )
    $table = New-Object System.Windows.Forms.DataGridView
    $table.Size = New-Object System.Drawing.Size($tableWidth, $tableHeight)
    $table.Location = New-Object System.Drawing.Point($tableLocationX, $tableLocationY)
    $parentControl.Controls.Add($table)
    return $table
}

function Set-Table {
    param (
        [System.Windows.Forms.DataGridView]$table,
        [array]$data
    )
    if ($data.Length -eq 0 -or $data[0].Length -le 1) {
        Write-Error "Invalid data format for table. Ensure the data array is not empty and has at least two columns."
        return
    }

    $table.Rows.Clear()
    $table.ColumnCount = $data[0].Length - 1
    for ($i = 1; $i -lt $data.Length; $i++) {
        $row = $table.Rows.Add()
        for ($j = 1; $j -lt $data[$i].Length; $j++) {
            if ($null -ne $table.Rows[$row].Cells[$j - 1]) {
                $table.Rows[$row].Cells[$j - 1].Value = $data[$i][$j]
            }
        }
    }
    for ($j = 1; $j -lt $data[0].Length; $j++) {
        $table.Columns[$j - 1].HeaderText = $data[0][$j]
    }
    for ($i = 1; $i -lt $data.Length; $i++) {
        $table.Rows[$i - 1].HeaderCell.Value = $data[$i][0]
    }
    $table.RowHeadersWidth = 100
}

# Function to check values and notify
function Test-ValuesAndNotify {
    param (
        [int]$pi,
        [string]$pin,
        [datetime]$startTime,
        [datetime]$endTime
    )
    $dataDB = Get-PiPinSqliteDataLastOfAllPins -pi $pi
    foreach ($data in $dataDB) {
        if ($data.pin -eq $pin -and $data.timestamp -ge $startTime -and $data.timestamp -le $endTime) {
            if ($data.value_data -ne "0") {
                # Replace "expected_value" with the correct condition
                [System.Windows.Forms.MessageBox]::Show("Incorrect value detected for Pi $pi, Pin $pin at $($data.timestamp)")
            }
        }
    }
}
function Add-Chart {
    param (
        [System.Windows.Forms.Control]$parentControl,
        [int]$chartWidth,
        [int]$chartHeight,
        [int]$chartLocationX,
        [int]$chartLocationY
    )
    $chart = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
    $chart.Size = New-Object System.Drawing.Size($chartWidth, $chartHeight)
    $chart.Location = New-Object System.Drawing.Point($chartLocationX, $chartLocationY)
    $chartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
    $chart.ChartAreas.Add($chartArea)
    $parentControl.Controls.Add($chart)
    return $chart
}

function Set-Chart {
    param (
        [System.Windows.Forms.DataVisualization.Charting.Chart]$chart,
        [array]$data
    )
    $chart.Series.Clear()
    $series = New-Object System.Windows.Forms.DataVisualization.Charting.Series
    $series.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
    for ($i = 0; $i -lt $data.Length; $i++) {
        $series.Points.AddXY($data[$i][0], $data[$i][1])
    }
    $chart.Series.Add($series)
}