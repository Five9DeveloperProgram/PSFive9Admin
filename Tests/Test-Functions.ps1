#!/usr/bin/env pwsh

# Test Five9 module functions
Write-Host "Enter your Five9 credentials..." -ForegroundColor Cyan
$cred = Get-Credential -Message "Enter your Five9 admin credentials"
if (-not $cred) {
    Write-Host "✗ Credentials are required" -ForegroundColor Red
    exit 1
}

Import-Module (Join-Path $PSScriptRoot "../PSFive9Admin.psd1") -Force
Connect-Five9AdminWebService -Credential $cred | Out-Null

Write-Host "`n=== Testing Get-Five9AgentGroup ===" -ForegroundColor Cyan
try {
    $groups = Get-Five9AgentGroup
    if ($groups) {
        $groups | Select-Object -First 5 | Format-Table name, id -AutoSize
        Write-Host "✓ Get-Five9AgentGroup works!" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== Testing Get-Five9User ===" -ForegroundColor Cyan
try {
    $users = Get-Five9User -NamePattern ".*"
    if ($users) {
        Write-Host "Returned $($users.Count) users"
        $users | Select-Object -First 5 | Get-Member | Select-Object -First 10
        Write-Host "✓ Get-Five9User works!" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== All tests completed! ===" -ForegroundColor Green
