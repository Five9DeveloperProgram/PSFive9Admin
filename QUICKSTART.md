# Quick Start Guide - PowerShell 7+ Support

## Summary

Your PSFive9Admin module now works with PowerShell 7+! The implementation automatically detects which PowerShell version you're using and adapts accordingly.

## What Was Done

1. **Created new SOAP client** ([Five9SoapClient.ps1](Public/AdminWebService/Five9SoapClient.ps1))
   - Pure PowerShell implementation using HttpClient
   - No external dependencies
   - Works on Windows, macOS, and Linux with PowerShell 7+

2. **Added method wrappers** ([Add-Five9SoapMethods.ps1](Public/AdminWebService/Add-Five9SoapMethods.ps1))
   - Maps 100+ Five9 API methods
   - Maintains compatibility with existing code
   - Proper parameter name mapping from WSDL

3. **Updated connection function** ([Connect-Five9AdminWebService.ps1](Public/AdminWebService/Connect-Five9AdminWebService.ps1))
   - Auto-detects PowerShell version
   - Uses appropriate implementation
   - Zero breaking changes for existing scripts

## Usage (Nothing Changes!)

Your existing code continues to work exactly as before:

```powershell
# Connect (works in PS 5.1 and 7+)
Connect-Five9AdminWebService

# Use any module function
Get-Five9AgentGroup
Get-Five9User -NamePattern "john.*"
Get-Five9Campaign
```

## Testing

### Quick Test
```powershell
# Run in PowerShell 7
pwsh ./Test-PS7Compatibility.ps1
```

### Full Test
```powershell
# Connect and verify
pwsh
Import-Module ./PSFive9Admin.psd1
Connect-Five9AdminWebService -Verbose
$client = Get-Five9AdminWebService
Write-Host "Connected to: $($client.Five9DomainName)"
```

## Files Created/Modified

### New Files
- `Public/AdminWebService/Five9SoapClient.ps1` - SOAP client class
- `Public/AdminWebService/Add-Five9SoapMethods.ps1` - Method wrapper generator
- `Test-PS7Compatibility.ps1` - Compatibility test script
- `PS7-COMPATIBILITY.md` - Detailed technical documentation
- `MIGRATION-GUIDE.md` - Complete migration guide
- `CHANGELOG.md` - Version history
- `QUICKSTART.md` - This file

### Modified Files
- `Public/AdminWebService/Connect-Five9AdminWebService.ps1` - Version detection logic

## How It Works

```
PowerShell 5.1                PowerShell 7+
     │                             │
     ├─ New-WebServiceProxy        ├─ Five9SoapClient class
     │  (Built-in cmdlet)          │  (Custom HTTP client)
     │                             │
     └─> Five9 SOAP API <──────────┘
         (Works with both)
```

## Next Steps

1. **Test your existing scripts** in PowerShell 7
2. **Report any issues** with specific method calls
3. **Add more methods** to Add-Five9SoapMethods.ps1 as needed

## Support

If you encounter issues:

1. Enable verbose output: `$VerbosePreference = 'Continue'`
2. Check error messages for missing methods
3. Verify credentials and network connectivity
4. Review [PS7-COMPATIBILITY.md](PS7-COMPATIBILITY.md) for details

## Example: Adding New Methods

If you need a method not yet wrapped:

```powershell
# Edit: Public/AdminWebService/Add-Five9SoapMethods.ps1

# Add to $methods array:
'yourNewMethod',

# Add parameter mapping (optional):
'yourNewMethod' = @('param1Name', 'param2Name')
```

That's it! Your module is now PowerShell 7 compatible. 🎉
