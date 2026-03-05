# Example: Export campaign data to CSV
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("OUTBOUND", "INBOUND", "AUTODIAL")]
    [string]$Type,

    [Parameter(Mandatory = $false)]
    [string]$NamePattern = ".*",

    [Parameter(Mandatory = $false)]
    [string]$OutputPath,

    [Parameter(Mandatory = $false)]
    [System.Management.Automation.PSCredential]$Credential
)

if (-not $OutputPath) {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $OutputPath = Join-Path $PSScriptRoot ("five9-campaigns-{0}.csv" -f $timestamp)
}

if (-not $Credential) {
    $Credential = Get-Credential -Message "Enter your Five9 admin credentials"
}

Import-Module (Join-Path $PSScriptRoot "../../PSFive9Admin.psd1") -Force
Connect-Five9AdminWebService -Credential $Credential | Out-Null

Write-Host "Exporting campaigns to: $OutputPath" -ForegroundColor Cyan
$campaigns = Get-Five9Campaign -Type $Type -NamePattern $NamePattern
$campaigns | Export-Csv -Path $OutputPath -NoTypeInformation
Write-Host "Done." -ForegroundColor Green
