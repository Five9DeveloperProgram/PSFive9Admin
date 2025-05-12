<#
.SYNOPSIS
    Installs or updates the PSFive9Admin module.

.DESCRIPTION
    Downloads the latest main branch zip from GitHub, extracts it, and installs or updates
    the module into the user's WindowsPowerShell or PowerShell Modules folder.

.NOTES
    Author: Five9 Developer Program
    Date: 2025-05-12
#>

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$zipUrl = "https://github.com/Five9DeveloperProgram/PSFive9Admin/archive/refs/heads/main.zip"
$moduleName = "PSFive9Admin"
$tempZip = Join-Path $env:TEMP "$moduleName.zip"
$tempExtract = Join-Path $env:TEMP "$moduleName"

$moduleRoot = ($env:PSModulePath -split ';' | Where-Object { $_ -like "*Documents*WindowsPowerShell*Modules" } | Select-Object -First 1)
if (-not $moduleRoot) {
    $moduleRoot = ($env:PSModulePath -split ';' | Where-Object { $_ -like "*Documents*PowerShell*Modules" } | Select-Object -First 1)
}
if (-not $moduleRoot) {
    Write-Error "❌ Could not detect a valid Documents modules folder. Aborting."
    exit 1
}

$modulePath = Join-Path $moduleRoot $moduleName
$existingInstall = Test-Path $modulePath

if ($existingInstall) {
    Write-Host "🔄 Existing installation detected at $modulePath. Will attempt update."
} else {
    Write-Host "📂 Installing module to $modulePath."
}

Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue

try {
    Write-Host "⬇️ Downloading latest module archive..."
    Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip

    Write-Host "📦 Extracting archive..."
    Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

    $extractedFolder = Get-ChildItem -Path $tempExtract | Where-Object { $_.PSIsContainer } | Select-Object -First 1
    if (-not $extractedFolder) {
        throw "❌ Extraction failed. No folder found."
    }

    $nestedModulePath = Join-Path $extractedFolder.FullName $moduleName
    $sourcePath = if (Test-Path $nestedModulePath) { $nestedModulePath } else { $extractedFolder.FullName }

    if ($existingInstall) {
        Write-Host "🗑️ Removing previous version..."
        Remove-Item $modulePath -Recurse -Force -ErrorAction SilentlyContinue
    }

    New-Item -ItemType Directory -Path $modulePath -Force | Out-Null
    Copy-Item -Path (Join-Path $sourcePath '*') -Destination $modulePath -Recurse -Force

    if (-not (Test-Path (Join-Path $modulePath "$moduleName.psd1"))) {
        throw "❌ Module manifest not found. Installation failed."
    }

    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Import-Module $moduleName -Force

    if ($existingInstall) {
        Write-Host "✅ Module '$moduleName' was updated successfully at '$modulePath'."
    } else {
        Write-Host "✅ Module '$moduleName' installed successfully at '$modulePath'."
    }
    # write a message to the user about how to use the module with a blank line
    Write-Host "`n🔗 To use the module, run: Connect-Five9AdminWebService -Verbose"
}
catch {
    Write-Error $_.Exception.Message
    exit 1
}
finally {
    Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
    Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue
}
