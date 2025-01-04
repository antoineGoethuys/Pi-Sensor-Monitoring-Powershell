# Dot-source the scripts
. "$PSScriptRoot/Gui/screen.ps1"
. "$PSScriptRoot/Database/database.ps1"

# Example: Fill the database with sensor data
FillDatabase

# Example: Get all sensor data from the database
# $sensorData = Get-AllSqliteData
# $sensorData | Out-GridView

#region GUI
$form = Set-Form -formText "Pi-Sensor-Monitoring-Powershell" -formWidth 500 -formHeight 500

# Add a tab control to the form
$tabControl = Add-TabControl -parentControl $form -tabControlWidth 500 -tabControlHeight 500 -tabControlLocationX 10 -tabControlLocationY 10

#region tabs
# Add tabs to the tab control
$tabPage1 = Add-tabPage -tabControl $tabControl -tabText "Pi 1"
$tabPage2 = Add-tabPage -tabControl $tabControl -tabText "Pi 2"
#endregion

# Add a nested tab control to the first tab
$nestedTabControl1 = Add-TabControl -parentControl $tabPage1 -tabControlWidth 400 -tabControlHeight 400 -tabControlLocationX 10 -tabControlLocationY 10

# Add tabs to the nested tab control
$nestedTabPage11 = Add-tabPage -tabControl $nestedTabControl1 -tabText "table"
$nestedTabPage12 = Add-tabPage -tabControl $nestedTabControl1 -tabText "graph"

# Add a table to the first nested tab
$table1 = Add-Table -parentControl $nestedTabPage11 -tableWidth 350 -tableHeight 350 -tableLocationX 0 -tableLocationY 0

# Add a nested tab control to the first tab
$nestedTabControl2 = Add-TabControl -parentControl $tabPage2 -tabControlWidth 400 -tabControlHeight 400 -tabControlLocationX 10 -tabControlLocationY 10

# Add tabs to the nested tab control
$nestedTabPage21 = Add-tabPage -tabControl $nestedTabControl2 -tabText "table"
$nestedTabPage22 = Add-tabPage -tabControl $nestedTabControl2 -tabText "graph"

# Add a table to the first nested tab
$table2 = Add-Table -parentControl $nestedTabPage21 -tableWidth 350 -tableHeight 350 -tableLocationX 0 -tableLocationY 0

# Fill the table with data
$data = @(
    @("", "Column1", "Column2", "Column3"),
    @("Row1", "Row1Col1", "Row1Col2", "Row1Col3"),
    @("Row2", "Row2Col1", "Row2Col2", "Row2Col3")
)
Set-Table -table $table1 -data $data
Set-Table -table $table2 -data $data

# Add a chart to the second nested tab
$chart = Add-Chart -parentControl $nestedTabPage12 -chartWidth 350 -chartHeight 350 -chartLocationX 0 -chartLocationY 0
$chart = Add-Chart -parentControl $nestedTabPage22 -chartWidth 350 -chartHeight 350 -chartLocationX 0 -chartLocationY 0

# Fill the chart with data
$chartData = @(
    @("Jan", 10),
    @("Feb", 20),
    @("Mar", 30),
    @("Apr", 40)
)
Set-Chart -chart $chart -data $chartData

# Add a button to update the table
$updateTableButton = Add-Button -parentControl $nestedTabPage1 -buttonText "Update Table" -buttonLocationX 10 -buttonLocationY 370
$updateTableButton.Add_Click({
        $newData = @(
            @("", "Column1", "Column2", "Column3"),
            @("Row1", "New1", "New2", "New3"),
            @("Row2", "New4", "New5", "New6")
        )
        Set-Table -table $table -data $newData
    })

# Add a button to update the chart
$updateChartButton = Add-Button -parentControl $nestedTabPage2 -buttonText "Update Chart" -buttonLocationX 10 -buttonLocationY 370
$updateChartButton.Add_Click({
        $newChartData = @(
            @("May", 50),
            @("Jun", 60),
            @("Jul", 70),
            @("Aug", 80)
        )
        Set-Chart -chart $chart -data $newChartData
    })
    
# Show the form
$form.ShowDialog()
#endregion
Start-Sync-Data -Pi 1 -IP "10.0.0.254" -port "8000"
