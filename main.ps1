# Dot-source the scripts
. "$PSScriptRoot/Gui/screen.ps1"
. "$PSScriptRoot/Database/database.ps1"

# Example usage of the new functions
Add-NewButton -buttonText "New Button" -locationX 150 -locationY 530
Change-TabText -tabPage $tabPage1 -newText "Updated Tab1"
Save-FormData -filePath ".\formData.json"


# Now you can call the functions from screen.ps1 and database.ps1
# Example: Show the dashboard form
[void]$form.ShowDialog()

Change-TabText -tabPage $tabPage1 -newText "Updated Tab2"


# Example: Fill the database with sensor data
FillDatabase

# Example: Get all sensor data from the database
# $sensorData = Get-AllSqliteData
# $sensorData | Out-GridView