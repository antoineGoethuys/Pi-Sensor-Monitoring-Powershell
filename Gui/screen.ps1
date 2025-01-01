#region Add Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms.DataVisualization
#endregion

#region Form
#region Create Form
# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Dashboard"
$form.Size = New-Object System.Drawing.Size(800, 600)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false
$form.MinimizeBox = $false
# $form.WindowState = "Maximized"
$form.StartPosition = "CenterScreen"
#endregion

#region Add Toolbar
# Add a toolbar
$toolStrip = New-Object System.Windows.Forms.ToolStrip

$toolStripButton1 = New-Object System.Windows.Forms.ToolStripButton
$toolStripButton1.Text = "Button1"

$toolStrip.Items.Add($toolStripButton1)
$form.Controls.Add($toolStrip)
#endregion

#region Add Tab Control
# Add a tab control
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(780, 500)
$tabControl.Location = New-Object System.Drawing.Point(5, 20)

$tabPage1 = New-Object System.Windows.Forms.TabPage
$tabPage1.Text = "Tab1"
$tabControl.TabPages.Add($tabPage1)

$tabPage2 = New-Object System.Windows.Forms.TabPage
$tabPage2.Text = "Tab2"
$tabControl.TabPages.Add($tabPage2)

$tabPage3 = New-Object System.Windows.Forms.TabPage
$tabPage3.Text = "+"
$tabControl.TabPages.Add($tabPage3)

# Handle the SelectedIndexChanged event to add new tabs
$tabControl.add_SelectedIndexChanged({
        if ($tabControl.SelectedTab -eq $tabPage3) {
            $newTabPage = New-Object System.Windows.Forms.TabPage
            $newTabPage.Text = "New Tab " + ($tabControl.TabPages.Count)
            $tabControl.TabPages.Insert($tabControl.TabPages.Count - 1, $newTabPage)
            $tabControl.SelectedTab = $newTabPage
            Add-ContextMenuToTab $newTabPage
        }
    })

$form.Controls.Add($tabControl)
#endregion

#region Add Change Color Button
# Add a button to change the background color
$changeColorButton = New-Object System.Windows.Forms.Button
$changeColorButton.Text = "Change Color"
$changeColorButton.Location = New-Object System.Drawing.Point(10, 530)
$changeColorButton.Add_Click({
        $form.BackColor = [System.Drawing.Color]::LightBlue
        Update-Form
    })
$form.Controls.Add($changeColorButton)
#endregion

#region Update Form Function
function Update-Form {
    [void]$form.Invalidate()
}
#endregion

#region Add Context Menu to Tabs
function Add-ContextMenuToTab {
    param ($tabPage)
    
    $contextMenu = New-Object System.Windows.Forms.ContextMenuStrip
    $closeMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
    $closeMenuItem.Text = "Close"
    $closeMenuItem.Add_Click({
            $tabControl.TabPages.Remove($tabPage)
        })
    $contextMenu.Items.Add($closeMenuItem)
    $tabPage.ContextMenuStrip = $contextMenu
}

# Add context menu to existing tabs
Add-ContextMenuToTab $tabPage1
Add-ContextMenuToTab $tabPage2
#endregion

#region Show Form
# Show the form
[void]$form.ShowDialog()
#endregion