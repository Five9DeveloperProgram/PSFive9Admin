# Example: Bulk-create agent groups
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$CsvPath,

    [Parameter(Mandatory = $false)]
    [string[]]$GroupNames = @("Support", "Sales"),

    [Parameter(Mandatory = $false)]
    [System.Management.Automation.PSCredential]$Credential
)

if (-not $Credential) {
    $Credential = Get-Credential -Message "Enter your Five9 admin credentials"
}

Import-Module (Join-Path $PSScriptRoot "../../PSFive9Admin.psd1") -Force
Connect-Five9AdminWebService -Credential $Credential | Out-Null

$groupsToCreate = @()

if ($CsvPath) {
    if (-not (Test-Path $CsvPath)) {
        throw "CSV not found: $CsvPath"
    }
    $groupsToCreate = Import-Csv $CsvPath
} else {
    $groupsToCreate = $GroupNames | ForEach-Object { [pscustomobject]@{ Name = $_; Description = $null } }
}

foreach ($group in $groupsToCreate) {
    $name = $group.Name
    if (-not $name) {
        continue
    }

    $pattern = "^{0}$" -f [regex]::Escape($name)
    $existing = Get-Five9AgentGroup -NamePattern $pattern

    if ($existing) {
        Write-Host "Skipping existing group: $name" -ForegroundColor Yellow
        continue
    }

    Write-Host "Creating group: $name" -ForegroundColor Cyan
    if ($group.Description) {
        New-Five9AgentGroup -Name $name -Description $group.Description | Out-Null
    } else {
        New-Five9AgentGroup -Name $name | Out-Null
    }
}

Write-Host "Done." -ForegroundColor Green
