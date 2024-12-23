class SensorScreen {
    [System.Windows.Forms.Form]$form

    SensorScreen() {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        Add-Type -AssemblyName System.Windows.Forms.DataVisualization

        # Create the form
        $this.form = New-Object System.Windows.Forms.Form
        $this.form.Text = "Dashboard"
        # $this.form.Size = New-Object System.Drawing.Size(800, 600)
        $this.form.WindowState = "Maximized"
        $this.form.StartPosition = "CenterScreen"

        # Add a label
        $label = New-Object System.Windows.Forms.Label
        $label.Text = "label1"
        $label.AutoSize = $true
        # $label.Location = New-Object System.Drawing.Point(400, 300)
        $this.form.Controls.Add($label)
    }

    [void] ShowForm() {
        [void]$this.form.ShowDialog()
    }
}

# Instantiate and use the class
$sensorScreen = [SensorScreen]::new()
$sensorScreen.ShowForm()