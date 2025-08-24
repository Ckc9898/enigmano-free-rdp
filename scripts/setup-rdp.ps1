
# EnigMano RDP Setup Script
# This script configures Windows for RDP access with security enhancements

param(
    [string]$NgrokToken = $env:NGROK_AUTH_TOKEN,
    [string]$Username = "runneradmin",
    [string]$Password = "P@ssw0rd!"
)

Write-Host "=== ENIGMANO RDP SETUP SCRIPT ===" -ForegroundColor Green
Write-Host "Initializing secure RDP environment..." -ForegroundColor Cyan

# Function to write colored output
function Write-Status {
    param([string]$Message, [string]$Status = "INFO")
    switch ($Status) {
        "SUCCESS" { Write-Host "✓ $Message" -ForegroundColor Green }
        "ERROR" { Write-Host "✗ $Message" -ForegroundColor Red }
        "WARNING" { Write-Host "⚠ $Message" -ForegroundColor Yellow }
        default { Write-Host "ℹ $Message" -ForegroundColor Cyan }
    }
}

# Enable RDP
Write-Status "Enabling Remote Desktop Protocol..."
try {
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 0
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1
    Write-Status "RDP enabled successfully" "SUCCESS"
} catch {
    Write-Status "Failed to enable RDP: $($_.Exception.Message)" "ERROR"
    exit 1
}

# Configure user account
Write-Status "Configuring user account..."
try {
    $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    Set-LocalUser -Name $Username -Password $SecurePassword
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member $Username -ErrorAction SilentlyContinue
    Add-LocalGroupMember -Group "Administrators" -Member $Username -ErrorAction SilentlyContinue
    Write-Status "User account configured successfully" "SUCCESS"
} catch {
    Write-Status "Failed to configure user: $($_.Exception.Message)" "ERROR"
}

# Download and setup ngrok
Write-Status "Setting up ngrok tunnel service..."
try {
    $ngrokPath = "C:\ngrok"
    if (!(Test-Path $ngrokPath)) {
        New-Item -ItemType Directory -Path $ngrokPath -Force
    }
    
    if (!(Test-Path "$ngrokPath\ngrok.exe")) {
        Write-Status "Downloading ngrok..."
        Invoke-WebRequest -Uri "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip" -OutFile "$ngrokPath\ngrok.zip"
        Expand-Archive "$ngrokPath\ngrok.zip" -DestinationPath $ngrokPath -Force
        Remove-Item "$ngrokPath\ngrok.zip" -Force
    }
    
    # Configure ngrok
    if ($NgrokToken) {
        & "$ngrokPath\ngrok.exe" config add-authtoken $NgrokToken
        Write-Status "ngrok configured with auth token" "SUCCESS"
    } else {
        Write-Status "No ngrok token provided" "WARNING"
    }
} catch {
    Write-Status "Failed to setup ngrok: $($_.Exception.Message)" "ERROR"
}

# Install essential software
Write-Status "Installing essential software packages..."
try {
    # Install Chocolatey if not present
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Status "Installing Chocolatey package manager..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    
    # Install packages
    $packages = @("googlechrome", "7zip", "notepadplusplus", "firefox")
    foreach ($package in $packages) {
        Write-Status "Installing $package..."
        choco install $package -y --no-progress
    }
    
    Write-Status "Software installation completed" "SUCCESS"
} catch {
    Write-Status "Software installation failed: $($_.Exception.Message)" "WARNING"
}

# Configure Chrome with security extensions
Write-Status "Configuring browser security settings..."
try {
    $chromeDir = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default"
    if (!(Test-Path $chromeDir)) {
        New-Item -ItemType Directory -Path $chromeDir -Force
    }
    
    # Chrome preferences for security extensions
    $chromePrefs = @{
        "extensions" = @{
            "settings" = @{
                "cjpalhdlnbpafiamejdnhcphjbkeiagm" = @{
                    "state" = 1
                    "manifest" = @{
                        "name" = "uBlock Origin"
                    }
                }
            }
        }
        "profile" = @{
            "default_content_setting_values" = @{
                "notifications" = 2
                "popups" = 2
            }
        }
    }
    
    $chromePrefs | ConvertTo-Json -Depth 10 | Out-File -FilePath "$chromeDir\Preferences" -Encoding UTF8
    Write-Status "Browser security configured" "SUCCESS"
} catch {
    Write-Status "Browser configuration failed: $($_.Exception.Message)" "WARNING"
}

# Setup Cloudflare WARP
Write-Status "Installing Cloudflare WARP VPN..."
try {
    $warpInstaller = "$env:TEMP\CloudflareWARP.msi"
    Invoke-WebRequest -Uri "https://1111-releases.cloudflareclient.com/windows/Cloudflare_WARP_Release-x64.msi" -OutFile $warpInstaller
    Start-Process msiexec.exe -Wait -ArgumentList "/I `"$warpInstaller`" /quiet"
    Remove-Item $warpInstaller -Force
    Write-Status "Cloudflare WARP installed successfully" "SUCCESS"
} catch {
    Write-Status "Cloudflare WARP installation failed: $($_.Exception.Message)" "WARNING"
}

# Create desktop shortcuts
Write-Status "Creating desktop shortcuts..."
try {
    $desktop = [Environment]::GetFolderPath("Desktop")
    
    # Chrome shortcut
    $chromeShortcut = "$desktop\Chrome.lnk"
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($chromeShortcut)
    $Shortcut.TargetPath = "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"
    $Shortcut.Save()
    
    Write-Status "Desktop shortcuts created" "SUCCESS"
} catch {
    Write-Status "Failed to create shortcuts: $($_.Exception.Message)" "WARNING"
}

Write-Status "EnigMano RDP setup completed successfully!" "SUCCESS"
Write-Host "`nSystem is ready for remote access." -ForegroundColor Green
Write-Host "Username: $Username" -ForegroundColor Yellow
Write-Host "Password: $Password" -ForegroundColor Yellow
