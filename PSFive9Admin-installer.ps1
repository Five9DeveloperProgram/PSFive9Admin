<#
.SYNOPSIS
    Installs or updates the PSFive9Admin module (cross-platform).

.DESCRIPTION
    Downloads the latest main branch zip from GitHub, extracts it, and installs or updates
    the module into the user's PowerShell Modules folder (Windows, macOS, Linux compatible).

.NOTES
    Author: Five9 Developer Program
    Updated: 2025-05-12
#>

$ErrorActionPreference = 'Stop'

$moduleName = "PSFive9Admin"
$repoUrl = "https://github.com/Five9DeveloperProgram/$moduleName"
$zipUrl = "$repoUrl/archive/refs/heads/main.zip"

# Get temp folder in a cross-platform way
$tempFolder = [System.IO.Path]::GetTempPath()
$tempZip = Join-Path $tempFolder "$moduleName.zip"
$tempExtract = Join-Path $tempFolder "$moduleName"

# Detect PSModulePath separator for platform
$modulePaths = $env:PSModulePath -split [System.IO.Path]::PathSeparator

# Try to find user module path
$moduleRoot = $modulePaths | Where-Object { $_ -match "Documents.*(WindowsPowerShell|PowerShell).*Modules" } | Select-Object -First 1

if (-not $moduleRoot) {
    $userHome = [Environment]::GetFolderPath("UserProfile")
    switch ($true) {
        { $IsLinux -or $IsMacOS } { $moduleRoot = "$userHome/.local/share/powershell/Modules"; break }
        { $IsWindows } { $moduleRoot = "$userHome/Documents/PowerShell/Modules"; break }
        default { throw "❌ Unsupported OS. Aborting." }
    }
}

$modulePath = Join-Path $moduleRoot $moduleName
$existingInstall = Test-Path $modulePath

# Helper for output
function Write-Info($message) {
    Write-Host $message -ForegroundColor Cyan
}
function Write-Success($message) {
    Write-Host $message -ForegroundColor Green
}
function Write-WarningMsg($message) {
    Write-Host $message -ForegroundColor Yellow
}
function Write-ErrorMsg($message) {
    Write-Host $message -ForegroundColor Red
}

if ($existingInstall) {
    Write-WarningMsg "🔄 Existing installation detected at $modulePath. Will attempt update."
} else {
    Write-Info "📂 Installing module to $modulePath."
}

# Clean up old temp files
if (Test-Path $tempZip) { Remove-Item $tempZip -Force }
if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force }

try {
    Write-Info "⬇️ Downloading latest module archive..."
    try {
        Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing
    } catch {
        throw "❌ Failed to download archive. Check your network or proxy settings."
    }

    Write-Info "📦 Extracting archive..."
    Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

    $extractedFolder = Get-ChildItem -Path $tempExtract | Where-Object { $_.PSIsContainer } | Select-Object -First 1
    if (-not $extractedFolder) {
        throw "❌ Extraction failed. No folder found."
    }

    $nestedModulePath = Join-Path $extractedFolder.FullName $moduleName
    $sourcePath = if (Test-Path $nestedModulePath) { $nestedModulePath } else { $extractedFolder.FullName }

    if ($existingInstall) {
        Write-Info "🗑️ Removing previous version..."
        Remove-Item $modulePath -Recurse -Force -ErrorAction SilentlyContinue
    }

    New-Item -ItemType Directory -Path $modulePath -Force | Out-Null
    Copy-Item -Path (Join-Path $sourcePath '*') -Destination $modulePath -Recurse -Force

    $manifestPath = Join-Path $modulePath "$moduleName.psd1"
    if (-not (Test-Path $manifestPath)) {
        throw "❌ Module manifest not found at $manifestPath. Installation failed."
    }

    Import-Module $moduleName -Force

    if ($existingInstall) {
        Write-Success "✅ Module '$moduleName' was updated successfully at '$modulePath'."
    } else {
        Write-Success "✅ Module '$moduleName' installed successfully at '$modulePath'."
    }

    Write-Host "`n🔗 To use the module, run: Connect-Five9AdminWebService -Verbose" -ForegroundColor Magenta
}
catch {
    Write-ErrorMsg $_.Exception.Message
    throw
}
finally {
    if (Test-Path $tempZip) { Remove-Item $tempZip -Force }
    if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force }
}
