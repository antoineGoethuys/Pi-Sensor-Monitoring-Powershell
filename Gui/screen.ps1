class SensorScreen {
    [System.Windows.Forms.Form]$form

    SensorScreen() {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        Add-Type -AssemblyName System.Windows.Forms.DataVisualization

        # Create the form
        $this.form = New-Object System.Windows.Forms.Form
        $this.form.Text = "Dashboard"
        $this.form.Size = New-Object System.Drawing.Size(800, 600)
        $this.form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
        $this.form.MaximizeBox = $false
        $this.form.MinimizeBox = $false
        # $this.form.WindowState = "Maximized"
        $this.form.StartPosition = "CenterScreen"

        # Add a toolbar
        $toolStrip = New-Object System.Windows.Forms.ToolStrip

        $toolStripButton1 = New-Object System.Windows.Forms.ToolStripButton
        $toolStripButton1.Text = "Button1"

        $toolStripButton2 = New-Object System.Windows.Forms.ToolStripButton
        $toolStripButton2.Text = "Close Current tab"

        $toolStrip.Items.Add($toolStripButton1)
        $toolStrip.Items.Add($toolStripButton2)
        $this.form.Controls.Add($toolStrip)

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
        
        $this.form.Controls.Add($tabControl)
    }

    [void] ShowForm() {
        [void]$this.form.ShowDialog()
    }
}

# Instantiate and use the class
$sensorScreen = [SensorScreen]::new()
$sensorScreen.ShowForm()