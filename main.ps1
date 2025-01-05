# Dot-source the scripts
. "$PSScriptRoot/Gui/screen.ps1"
. "$PSScriptRoot/Database/database.ps1"

# Load the configuration file
$config = Get-Content "$PSScriptRoot/config.json" | ConvertFrom-Json

#region GUI
function Start-Screen {
    $form = Set-Form -formText "Pi-Sensor-Monitoring-Powershell" -formWidth 800 -formHeight 800

    # Add a tab control to the form
    $tabControl = Add-TabControl -parentControl $form -tabControlWidth 750 -tabControlHeight 700 -tabControlLocationX 10 -tabControlLocationY 10

    # Add tabs to the tab control
    $tabPage1 = Add-tabPage -tabControl $tabControl -tabText "Pi 1"
    $tabPage2 = Add-tabPage -tabControl $tabControl -tabText "Pi 2"

    # Add a nested tab control to the first tab
    $nestedTabControl1 = Add-TabControl -parentControl $tabPage1 -tabControlWidth 700 -tabControlHeight 650 -tabControlLocationX 10 -tabControlLocationY 10
    $nestedTabPage11 = Add-tabPage -tabControl $nestedTabControl1 -tabText "table"
    $table1 = Add-Table -parentControl $nestedTabPage11 -tableWidth 650 -tableHeight 550 -tableLocationX 10 -tableLocationY 10

    # Add a nested tab control to the second tab
    $nestedTabControl2 = Add-TabControl -parentControl $tabPage2 -tabControlWidth 700 -tabControlHeight 650 -tabControlLocationX 10 -tabControlLocationY 10
    $nestedTabPage21 = Add-tabPage -tabControl $nestedTabControl2 -tabText "table"
    $table2 = Add-Table -parentControl $nestedTabPage21 -tableWidth 650 -tableHeight 550 -tableLocationX 10 -tableLocationY 10

    # Add buttons to update the tables
    $updateTableButton1 = Add-Button -parentControl $nestedTabPage11 -buttonText "Update Table" -buttonLocationY 575 -buttonLocationX 300
    $updateTableButton1.Add_Click({
            Sync-Data -Pi 1 -IP $config.pi1IP -port "8000"
            $dataDB = Get-PiPinSqliteDataLastOfAllPins -pi 1
            $newData = @()
            for ($i = -1; $i -lt $dataDB.Count; $i++) {
                $newData += , @($dataDB[$i].pi, $dataDB[$i].pin, $dataDB[$i].timestamp, $dataDB[$i].value_data)
            }
            $newData[0] = @("Pi", "Pin", "Timestamp", "Value Data")
            Set-Table -table $table1 -data $newData
        })

    $updateTableButton2 = Add-Button -parentControl $nestedTabPage21 -buttonText "Update Table" -buttonLocationY 575 -buttonLocationX 300
    $updateTableButton2.Add_Click({
            Sync-Data -Pi 2 -IP $config.pi2IP -port "8000"
            $dataDB = Get-PiPinSqliteDataLastOfAllPins -pi 2
            $newData = @()
            for ($i = -1; $i -lt $dataDB.Count; $i++) {
                $newData += , @($dataDB[$i].pi, $dataDB[$i].pin, $dataDB[$i].timestamp, $dataDB[$i].value_data)
            }
            $newData[0] = @("Pi", "Pin", "Timestamp", "Value Data")
            Set-Table -table $table2 -data $newData
        })

    # Show the form
    $form.ShowDialog()
}

Start-Screen