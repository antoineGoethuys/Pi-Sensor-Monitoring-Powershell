#region Add Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms.DataVisualization
#endregion

function Set-Form {
    param (
        [string]$formText,
        [int]$formWidth,
        [int]$formHeight
    )
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $formText
    $form.Size = New-Object System.Drawing.Size($formWidth, $formHeight)
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    # $form.WindowState = "Maximized"
    $form.StartPosition = "CenterScreen"
    $form.AutoScroll = $true
    return $form
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
        [string]$buttonText,
        [int]$buttonLocationX,
        [int]$buttonLocationY
    )
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $buttonText
    $button.Location = New-Object System.Drawing.Point($buttonLocationX, $buttonLocationY)
    $parentControl.Controls.Add($button)
    return $button
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
    $table.Rows.Clear()
    $table.ColumnCount = $data[0].Length - 1
    for ($i = 1; $i -lt $data.Length; $i++) {
        $row = $table.Rows.Add()
        for ($j = 1; $j -lt $data[$i].Length; $j++) {
            $table.Rows[$row].Cells[$j - 1].Value = $data[$i][$j]
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