
# EnigMano Tunnel Startup Script
# Starts ngrok tunnel and displays connection information

param(
    [int]$Port = 3389,
    [string]$Protocol = "tcp"
)

Write-Host "=== ENIGMANO TUNNEL MANAGER ===" -ForegroundColor Green

$ngrokPath = "C:\ngrok\ngrok.exe"

if (!(Test-Path $ngrokPath)) {
    Write-Host "Error: ngrok not found at $ngrokPath" -ForegroundColor Red
    Write-Host "Please run setup-rdp.ps1 first to install ngrok." -ForegroundColor Yellow
    exit 1
}

Write-Host "Starting ngrok tunnel on port $Port..." -ForegroundColor Cyan

# Start ngrok in background
Start-Process -FilePath $ngrokPath -ArgumentList "$Protocol $Port" -WindowStyle Hidden

# Wait for ngrok to initialize
Write-Host "Waiting for tunnel to establish..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Get tunnel information
try {
    $maxRetries = 5
    $retryCount = 0
    
    do {
        try {
            $ngrokApi = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels" -TimeoutSec 10
            break
        } catch {
            $retryCount++
            Write-Host "Retry $retryCount/$maxRetries - Waiting for ngrok API..." -ForegroundColor Yellow
            Start-Sleep -Seconds 3
        }
    } while ($retryCount -lt $maxRetries)
    
    if ($ngrokApi.tunnels.Count -gt 0) {
        $tunnel = $ngrokApi.tunnels[0]
        $publicUrl = $tunnel.public_url
        $host = $publicUrl -replace "$Protocol://", ""
        
        Write-Host "`n╔══════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║         ENIGMANO RDP ACCESS          ║" -ForegroundColor Cyan  
        Write-Host "╠══════════════════════════════════════╣" -ForegroundColor Cyan
        Write-Host "║ Status: CONNECTED                    ║" -ForegroundColor Green
        Write-Host "║ Host: $($host.PadRight(29))║" -ForegroundColor White
        Write-Host "║ Username: runneradmin                ║" -ForegroundColor White
        Write-Host "║ Password: P@ssw0rd!                  ║" -ForegroundColor White
        Write-Host "║ Protocol: $($Protocol.ToUpper().PadRight(28))║" -ForegroundColor White
        Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
        
        Write-Host "`nConnection Instructions:" -ForegroundColor Yellow
        Write-Host "1. Open Remote Desktop Connection (mstsc)" -ForegroundColor White
        Write-Host "2. Enter host: $host" -ForegroundColor White
        Write-Host "3. Use credentials shown above" -ForegroundColor White
        Write-Host "4. Keep this window open to maintain connection" -ForegroundColor Red
        
        # Additional tunnel info
        Write-Host "`nTunnel Details:" -ForegroundColor Cyan
        Write-Host "Local Address: $($tunnel.config.addr)" -ForegroundColor Gray
        Write-Host "Public URL: $($tunnel.public_url)" -ForegroundColor Gray
        Write-Host "Tunnel Name: $($tunnel.name)" -ForegroundColor Gray
        
    } else {
        Write-Host "No active tunnels found!" -ForegroundColor Red
        Write-Host "Please check ngrok configuration and try again." -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "Error retrieving tunnel information: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "ngrok may still be starting. Please wait and check manually at http://localhost:4040" -ForegroundColor Yellow
}

# Keep monitoring tunnel status
Write-Host "`nMonitoring tunnel status... (Press Ctrl+C to stop)" -ForegroundColor Green
$counter = 0

try {
    while ($true) {
        $counter++
        Start-Sleep -Seconds 30
        
        try {
            $status = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels" -TimeoutSec 5
            if ($status.tunnels.Count -gt 0) {
                Write-Host "[$((Get-Date).ToString('HH:mm:ss'))] Tunnel active - Heartbeat #$counter" -ForegroundColor Green
            } else {
                Write-Host "[$((Get-Date).ToString('HH:mm:ss'))] No active tunnels detected!" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "[$((Get-Date).ToString('HH:mm:ss'))] Tunnel monitoring error - ngrok may have stopped" -ForegroundColor Red
            break
        }
    }
} catch {
    Write-Host "`nTunnel monitoring stopped." -ForegroundColor Yellow
}
