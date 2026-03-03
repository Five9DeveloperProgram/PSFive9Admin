#!/usr/bin/env pwsh

# Test connection with provided credentials
$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'

Write-Host "=== Testing Five9 Connection in PowerShell 7 ===" -ForegroundColor Cyan
Write-Host "PowerShell Version: $($PSVersionTable.PSVersion)" -ForegroundColor Yellow

try {
    # Import module
    Write-Host "`nImporting module..." -ForegroundColor Cyan
    Import-Module ./PSFive9Admin.psd1 -Force
    Write-Host "✓ Module imported" -ForegroundColor Green
    
    # Get credentials
    Write-Host "`nEnter your Five9 credentials..." -ForegroundColor Cyan
    $cred = Get-Credential -Message "Enter your Five9 admin credentials"
    if (-not $cred) {
        throw "Credentials are required"
    }
    Write-Host "✓ Credentials provided" -ForegroundColor Green
    
    # Connect
    Write-Host "`nConnecting to Five9..." -ForegroundColor Cyan
    Connect-Five9AdminWebService -Credential $cred -Verbose
    
    Write-Host "`n✓ SUCCESS - Connected to Five9!" -ForegroundColor Green
    
    # Get client info
    $client = Get-Five9AdminWebService
    Write-Host "`nConnection Details:" -ForegroundColor Cyan
    Write-Host "  Domain Name: $($client.Five9DomainName)" -ForegroundColor White
    Write-Host "  Domain ID: $($client.Five9DomainId)" -ForegroundColor White
    Write-Host "  Version: $($client.Version)" -ForegroundColor White
    Write-Host "  Data Center: $($client.DataCenter)" -ForegroundColor White
    
} catch {
    Write-Host "`n✗ ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "`nFull Error Details:" -ForegroundColor Yellow
    $_ | Format-List * -Force
    
    if ($_.Exception.InnerException) {
        Write-Host "`nInner Exception:" -ForegroundColor Yellow
        $_.Exception.InnerException | Format-List * -Force
    }
}
