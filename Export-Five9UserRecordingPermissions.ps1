<#
.SYNOPSIS
    Exports all Five9 users with their recording permissions to a CSV file.

.DESCRIPTION
    This script connects to the Five9 Admin Web Service, retrieves all users,
    extracts their recording permissions, and exports the data to a CSV file.
    The script will prompt for Five9 admin credentials when run.

.PARAMETER OutputPath
    The path where the CSV file will be saved. Defaults to the current directory
    with filename "Five9-UserRecordingPermissions-[timestamp].csv"

.PARAMETER DataCenter
    The Five9 data center to connect to. Options: US (default), EU, EU_Frankfurt, Canada

.EXAMPLE
    .\Export-Five9UserRecordingPermissions.ps1
    
    # Prompts for credentials and exports to default location with timestamp

.EXAMPLE
    .\Export-Five9UserRecordingPermissions.ps1 -OutputPath "C:\Reports\RecordingPermissions.csv"
    
    # Exports to specified file path

.EXAMPLE
    .\Export-Five9UserRecordingPermissions.ps1 -DataCenter "EU"
    
    # Connects to EU data center
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$OutputPath,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet('US', 'EU', 'EU_Frankfurt', 'Canada')]
    [string]$DataCenter = 'US'
)

# Import the PSFive9Admin module if not already loaded
$modulePath = Join-Path $PSScriptRoot "PSFive9Admin.psd1"
if (Test-Path $modulePath) {
    Import-Module $modulePath -Force
} else {
    Write-Error "PSFive9Admin module not found. Make sure you're running this script from the module directory."
    exit 1
}

# Set default output path with timestamp if not specified
if (-not $OutputPath) {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $OutputPath = Join-Path (Get-Location) "Five9-UserRecordingPermissions-$timestamp.csv"
}

# Validate output path
if ($OutputPath -notmatch '\.csv$') {
    throw 'Parameter -OutputPath should end with ".csv"'
}

$folderPath = Split-Path $OutputPath
if ($folderPath -and -not (Test-Path $folderPath)) {
    throw "Specified output directory does not exist: ""$folderPath"""
}

try {
    Write-Host "`nConnecting to Five9 Admin Web Service..." -ForegroundColor Cyan
    Write-Host "Data Center: $DataCenter" -ForegroundColor Cyan
    
    # Prompt for credentials and connect
    $credential = Get-Credential -Message "Please enter your Five9 admin credentials"
    
    if (-not $credential) {
        Write-Host "Connection cancelled by user." -ForegroundColor Yellow
        exit 0
    }
    
    Connect-Five9AdminWebService -Credential $credential -DataCenter $DataCenter
    
    Write-Host "Connected successfully!`n" -ForegroundColor Green
    
    # Verify connection
    if (-not $global:DefaultFive9AdminClient) {
        throw "Connection failed - DefaultFive9AdminClient is not initialized"
    }
    
    # Get all users
    Write-Host "Retrieving all users from Five9..." -ForegroundColor Cyan
    Write-Verbose "Calling Get-Five9User with NamePattern '.*'" -Verbose
    $users = Get-Five9User -NamePattern '.*' -ErrorAction Stop
    
    if (-not $users) {
        Write-Warning "No users were retrieved. This might indicate a connection or permission issue."
    }
    
    Write-Host "Retrieved $($users.Count) users`n" -ForegroundColor Green
    
    # Extract recording permissions for each user
    Write-Host "Extracting recording permissions..." -ForegroundColor Cyan
    
    $recordingReport = @()
    $i = 0
    
    foreach ($user in $users) {
        $i++
        Write-Progress -Activity "Processing Users" -Status "User: $($user.userName)" -PercentComplete (($i / $users.Count) * 100)
        
        # Initialize recording permission variables
        $allowCallRecording = $null
        $allowRecordingAccess = $null
        $allowRecordingDeletion = $null
        
        # Extract recording permissions from agent role
        if ($user.roles.agent) {
            $allowCallRecording = $user.roles.agent.allowCallRecording
            $allowRecordingAccess = $user.roles.agent.allowRecordingAccess
            $allowRecordingDeletion = $user.roles.agent.allowRecordingDeletion
        }
        
        # Create custom object with user info and recording permissions
        $recordingReport += [PSCustomObject]@{
            UserName = $user.userName
            FullName = $user.fullName
            Email = $user.EMail
            Extension = $user.extension
            Active = $user.active
            IsAgent = $user.agent
            IsAdmin = $user.admin
            IsSupervisor = $user.supervisor
            AllowCallRecording = $allowCallRecording
            AllowRecordingAccess = $allowRecordingAccess
            AllowRecordingDeletion = $allowRecordingDeletion
            UserProfileName = $user.userProfileName
            StartDate = $user.startDate
        }
    }
    
    Write-Progress -Activity "Processing Users" -Completed
    
    # Export to CSV
    Write-Host "Exporting to CSV..." -ForegroundColor Cyan
    $recordingReport | Export-Csv -Path $OutputPath -NoTypeInformation
    
    Write-Host "`nExport completed successfully!" -ForegroundColor Green
    Write-Host "File location: $OutputPath" -ForegroundColor Green
    Write-Host "Total users exported: $($recordingReport.Count)" -ForegroundColor Green
    
    # Display summary statistics
    $agentsWithRecording = ($recordingReport | Where-Object { $_.AllowCallRecording -eq $true }).Count
    $agentsWithAccess = ($recordingReport | Where-Object { $_.AllowRecordingAccess -eq $true }).Count
    $agentsWithDeletion = ($recordingReport | Where-Object { $_.AllowRecordingDeletion -eq $true }).Count
    
    Write-Host "`nRecording Permissions Summary:" -ForegroundColor Cyan
    Write-Host "  Users with Allow Call Recording: $agentsWithRecording" -ForegroundColor White
    Write-Host "  Users with Allow Recording Access: $agentsWithAccess" -ForegroundColor White
    Write-Host "  Users with Allow Recording Deletion: $agentsWithDeletion" -ForegroundColor White
    
} catch {
    Write-Host "`nError occurred: $($_.Exception.Message)" -ForegroundColor Red
    Write-Error $_
    exit 1
}
