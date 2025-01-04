# Dot-source the scripts
. "$PSScriptRoot/Gui/screen.ps1"
. "$PSScriptRoot/Database/database.ps1"


# Example: Get all sensor data from the database
# $sensorData = Get-AllSqliteData
# $sensorData | Out-GridView

#region GUI
$form = Set-Form -formText "Pi-Sensor-Monitoring-Powershell" -formWidth 800 -formHeight 800

# Add a tab control to the form
$tabControl = Add-TabControl -parentControl $form -tabControlWidth 750 -tabControlHeight 700 -tabControlLocationX 10 -tabControlLocationY 10

#region tabs
# Add tabs to the tab control
$tabPage1 = Add-tabPage -tabControl $tabControl -tabText "Pi 1"
$tabPage2 = Add-tabPage -tabControl $tabControl -tabText "Pi 2"
#endregion

# Add a nested tab control to the first tab
$nestedTabControl1 = Add-TabControl -parentControl $tabPage1 -tabControlWidth 700 -tabControlHeight 650 -tabControlLocationX 10 -tabControlLocationY 10

# Add tabs to the nested tab control
$nestedTabPage11 = Add-tabPage -tabControl $nestedTabControl1 -tabText "table"
# $nestedTabPage12 = Add-tabPage -tabControl $nestedTabControl1 -tabText "graph"

# Add a table to the first nested tab
$table1 = Add-Table -parentControl $nestedTabPage11 -tableWidth 650 -tableHeight 550 -tableLocationX 10 -tableLocationY 10

# Add a nested tab control to the first tab
$nestedTabControl2 = Add-TabControl -parentControl $tabPage2 -tabControlWidth 700 -tabControlHeight 650 -tabControlLocationX 10 -tabControlLocationY 10

# Add tabs to the nested tab control
$nestedTabPage21 = Add-tabPage -tabControl $nestedTabControl2 -tabText "table"
# $nestedTabPage22 = Add-tabPage -tabControl $nestedTabControl2 -tabText "graph"

# Add a table to the first nested tab
$table2 = Add-Table -parentControl $nestedTabPage21 -tableWidth 650 -tableHeight 550 -tableLocationX 10 -tableLocationY 10

# Fill the table with data
$data = @(
    @("", "Column1", "Column2", "Column3"),
    @("Row1", "Row1Col1", "Row1Col2", "Row1Col3"),
    @("Row2", "Row2Col1", "Row2Col2", "Row2Col3")
)
Set-Table -table $table1 -data $data
Set-Table -table $table2 -data $data

# Add a chart to the second nested tab
# $chart = Add-Chart -parentControl $nestedTabPage12 -chartWidth 650 -chartHeight 550 -chartLocationX 10 -chartLocationY 10
# $chart = Add-Chart -parentControl $nestedTabPage22 -chartWidth 650 -chartHeight 550 -chartLocationX 10 -chartLocationY 10

# # Fill the chart with data
# $chartData = @(
#     @("Jan", 10),
#     @("Feb", 20),
#     @("Mar", 30),
#     @("Apr", 40)
# )
# Set-Chart -chart $chart -data $chartData

# Add a button to update the table
$updateTableButton = Add-Button -parentControl $nestedTabPage11 -buttonText "Update Table" -buttonLocationY 575 -buttonLocationX 300
$updateTableButton.Add_Click({
        # $dataDB = Get-PiSqliteData -pi 1
        $dataDB = Get-PiPinSqliteDataLastOfAllPins -pi 1
        $newData = @(
            # @("ID", "Pi", "Pin", "Timestamp", "Value Data")  # Header row
        )
        for ($i = -1; $i -lt $dataDB.Count; $i++) {
            $newData += , @($dataDB[$i].id, $dataDB[$i].pi, $dataDB[$i].pin, $dataDB[$i].timestamp, $dataDB[$i].value_data)
            # write-host $dataDB[$i].id $dataDB[$i].pi $dataDB[$i].pin $dataDB[$i].timestamp $dataDB[$i].value_data
        }
        $newData[0] = @("ID", "Pi", "Pin", "Timestamp", "Value Data")
        Set-Table -table $table1 -data $newData
    })

# Add a button to update the chart
# $updateChartButton = Add-Button -parentControl $nestedTabPage21 -buttonText "Update Chart" -buttonLocationY 575 -buttonLocationX 300
# $updateChartButton.Add_Click({
#         $newChartData = @(
#             @("May", 50),
#             @("Jun", 60),
#             @("Jul", 70),
#             @("Aug", 80)
#         )
#         Set-Chart -chart $chart -data $newChartData
#     })
    
# Show the form
$form.ShowDialog()
#endregion
# Start-Sync-Data -Pi 1 -IP "10.0.0.254" -port "8000"
