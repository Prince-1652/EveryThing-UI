param([string]$SkinName)

Add-Type -AssemblyName System.Windows.Forms

$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.Filter = "Image Files|*.png;*.jpg;*.jpeg;*.bmp;*.gif"
$dialog.Title = "Select a Photo for the Widget"

# This creates a dummy invisible window to force the OpenFileDialog to the front
$form = New-Object System.Windows.Forms.Form
$form.TopMost = $true
$form.ShowInTaskbar = $false
$form.WindowState = 'Minimized'

$result = $dialog.ShowDialog($form)

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $file = $dialog.FileName
    $dest = $PSScriptRoot
    
    # Remove all existing images safely to ensure QuotePlugin picks the new one
    Remove-Item -Path "$dest\*.jpg" -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$dest\*.jpeg" -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$dest\*.png" -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$dest\*.bmp" -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$dest\*.gif" -Force -ErrorAction SilentlyContinue
    
    $ext = [System.IO.Path]::GetExtension($file)
    $newFile = Join-Path $dest ("Photo" + $ext)
    Copy-Item -Path $file -Destination $newFile -Force
    
    # Refresh the Rainmeter widget so it loads the new image immediately
    $RainmeterPath = "C:\Program Files\Rainmeter\Rainmeter.exe"
    if (Test-Path $RainmeterPath) {
        Start-Process -FilePath $RainmeterPath -ArgumentList "!Refresh", "`"$SkinName`""
    }
}

$form.Dispose()
