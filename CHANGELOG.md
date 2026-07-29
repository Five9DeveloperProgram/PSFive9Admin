# Changelog

All notable changes to PSFive9Admin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - TBD

### Added
- **PowerShell 7+ Support** - Module now works on PowerShell 7.0+ across Windows, macOS, and Linux
- New `Five9SoapClient.ps1` - HTTP-based SOAP client for PowerShell 7+ compatibility
- New `Add-Five9SoapMethods.ps1` - Dynamic method wrapper generation
- Test scripts: `Tests/Test-Connection.ps1`, `Tests/Test-Functions.ps1`, `Tests/Test-PS7Compatibility.ps1`
- Documentation: `MIGRATION-GUIDE.md`, `CHANGELOG.md`, `DOCUMENTATION-REVIEW.md`
- New example scripts in `assets/ExampleScripts/`
- New `CONTRIBUTING.md` contributor guide

### Changed
- `Connect-Five9AdminWebService.ps1` - Now auto-detects PowerShell version and uses appropriate SOAP client
- Module automatically switches between `New-WebServiceProxy` (PS 5.1) and custom HTTP client (PS 7+)
- Updated README with accurate PowerShell 7 compatibility information
- Fixed documentation file path references
- Improved SOAP error messaging in `Five9SoapClient.ps1`

### Security
- Removed hardcoded test credentials from all test scripts
- Test scripts now use `Get-Credential` for secure authentication

### Fixed
- SOAP envelope namespace handling for Five9 API compatibility
- Parameter mapping for multiple Five9 API methods

### Maintained
- **Full backward compatibility** - No breaking changes for PowerShell 5.1 users
- All existing functions continue to work identically

## [1.0.128] - Previous Release

- Base version from original sqone2 project
- PowerShell 5.1 support
- Core Five9 Admin API functions

---

## Migration Guide

### For PowerShell 5.1 Users
No action required! The module works exactly as before.

### For PowerShell 7 Users
Simply update to the latest version and enjoy cross-platform support!

```powershell
# Install/Update
Import-Module PSFive9Admin

# Connect (same command, works everywhere)
Connect-Five9AdminWebService

# All your existing scripts just work!
```

See [MIGRATION-GUIDE.md](MIGRATION-GUIDE.md) for technical details.
