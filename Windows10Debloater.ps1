Add-Type -AssemblyName System.Windows.Forms

function Disable-WindowsUpdate {
    Write-Host "Windows Update'i keelamine..."
    Stop-Service -Name wuauserv -Force
    Set-Service -Name wuauserv -StartupType Disabled
    Write-Host "Windows Update on keelatud."
}

function Disable-Cortana {
    Write-Host "Cortana keelamine..."
    Get-AppxPackage -AllUsers | Where-Object {$_.Name -like "*Cortana*"} | Remove-AppxPackage -ErrorAction SilentlyContinue
    Write-Host "Cortana on keelatud."
}

function Disable-Telemetry {
    Write-Host "Telemeetria keelamine..."
    Stop-Service -Name DiagTrack -Force
    Set-Service -Name DiagTrack -StartupType Disabled
    Write-Host "Telemeetria on keelatud."
}

function Remove-PreInstalledApps {
    Write-Host "Eelinstallitud rakenduste eemaldamine..."
    $Apps = @(
        "Microsoft.3DBuilder",
        "Microsoft.BingWeather",
        "Microsoft.DesktopAppInstaller",
        "Microsoft.GetHelp",
        "Microsoft.Getstarted",
        "Microsoft.Messaging",
        "Microsoft.MicrosoftOfficeHub",
        "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.MixedReality.Portal",
        "Microsoft.MixedReality.Portal",
        "Microsoft.MSPaint",
        "Microsoft.Office.OneNote",
        "Microsoft.OneConnect",
        "Microsoft.People",
        "Microsoft.Print3D",
        "Microsoft.ScreenSketch",
        "Microsoft.SkypeApp",
        "Microsoft.StorePurchaseApp",
        "Microsoft.Wallet",
        "Microsoft.WebMediaExtensions",
        "Microsoft.Windows.Photos",
        "Microsoft.WindowsAlarms",
        "Microsoft.WindowsCalculator",
        "Microsoft.WindowsCamera",
        "microsoft.windowscommunicationsapps",
        "Microsoft.WindowsFeedbackHub",
        "Microsoft.WindowsMaps",
        "Microsoft.WindowsSoundRecorder",
        "Microsoft.WindowsStore",
        "Microsoft.Xbox.TCUI",
        "Microsoft.XboxApp",
        "Microsoft.XboxGameOverlay",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.XboxSpeechToTextOverlay",
        "Microsoft.YourPhone"
    )
    foreach ($App in $Apps) {
        Get-AppxPackage -AllUsers | Where-Object {$_.Name -eq $App} | Remove-AppxPackage -ErrorAction SilentlyContinue
    }
    Write-Host "Eelinstallitud rakendused on eemaldatud."
}

function Uninstall-OneDrive {
    Write-Host "OneDrive'i desinstallimine..."
    Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:USERPROFILE\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Name "System.IsPinnedToNameSpaceTree" -ErrorAction SilentlyContinue
    Write-Host "OneDrive on desinstallitud."
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows 10 Debloater"
$form.Size = New-Object System.Drawing.Size(450,400)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::LightGray

$button1 = New-Object System.Windows.Forms.Button
$button1.Location = New-Object System.Drawing.Point(50,30)
$button1.Size = New-Object System.Drawing.Size(350,50)
$button1.Text = "Windows Update'i keelamine"
$button1.BackColor = [System.Drawing.Color]::DarkBlue
$button1.ForeColor = [System.Drawing.Color]::White
$button1.Add_Click({
    Disable-WindowsUpdate
})

$button2 = New-Object System.Windows.Forms.Button
$button2.Location = New-Object System.Drawing.Point(50,100)
$button2.Size = New-Object System.Drawing.Size(350,50)
$button2.Text = "Cortana keelamine"
$button2.BackColor = [System.Drawing.Color]::DarkBlue
$button2.ForeColor = [System.Drawing.Color]::White
$button2.Add_Click({
    Disable-Cortana
})

$button3 = New-Object System.Windows.Forms.Button
$button3.Location = New-Object System.Drawing.Point(50,170)
$button3.Size = New-Object System.Drawing.Size(350,50)
$button3.Text = "Telemeetria keelamine"
$button3.BackColor = [System.Drawing.Color]::DarkBlue
$button3.ForeColor = [System.Drawing.Color]::White
$button3.Add_Click({
    Disable-Telemetry
})

$button4 = New-Object System.Windows.Forms.Button
$button4.Location = New-Object System.Drawing.Point(50,240)
$button4.Size = New-Object System.Drawing.Size(350,50)
$button4.Text = "Eelinstallitud rakenduste eemaldamine"
$button4.BackColor = [System.Drawing.Color]::DarkBlue
$button4.ForeColor = [System.Drawing.Color]::White
$button4.Add_Click({
    Remove-PreInstalledApps
})

$button5 = New-Object System.Windows.Forms.Button
$button5.Location = New-Object System.Drawing.Point(50,310)
$button5.Size = New-Object System.Drawing.Size(350,50)
$button5.Text = "OneDrive'i desinstallimine"
$button5.BackColor = [System.Drawing.Color]::DarkBlue
$button5.ForeColor = [System.Drawing.Color]::White
$button5.Add_Click({
    Uninstall-OneDrive
})

$form.Controls.Add($button1)
$form.Controls.Add($button2)
$form.Controls.Add($button3)
$form.Controls.Add($button4)
$form.Controls.Add($button5)

$form.ShowDialog() | Out-Null
