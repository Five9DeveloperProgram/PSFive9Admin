# Example: Export Five9 users to CSV
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$OutputPath,

    [Parameter(Mandatory = $false)]
    [string]$NamePattern = ".*",

    [Parameter(Mandatory = $false)]
    [System.Management.Automation.PSCredential]$Credential
)

if (-not $OutputPath) {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $OutputPath = Join-Path $PSScriptRoot ("five9-users-{0}.csv" -f $timestamp)
}

if (-not $Credential) {
    $Credential = Get-Credential -Message "Enter your Five9 admin credentials"
}

Import-Module (Join-Path $PSScriptRoot "../../PSFive9Admin.psd1") -Force
Connect-Five9AdminWebService -Credential $Credential | Out-Null

Write-Host "Exporting users to: $OutputPath" -ForegroundColor Cyan
Get-Five9User -NamePattern $NamePattern -OutputPath $OutputPath | Out-Null
Write-Host "Done." -ForegroundColor Green
