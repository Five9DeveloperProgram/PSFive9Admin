# PSFive9Admin - PowerShell 7 Migration Guide

## Overview

PSFive9Admin now supports **PowerShell 7+** while maintaining full backward compatibility with PowerShell 5.1. The module automatically detects your PowerShell version and uses the appropriate implementation.

## Quick Start

### Installation

```powershell
# Install from GitHub (recommended)
irm 'https://raw.githubusercontent.com/Five9DeveloperProgram/PSFive9Admin/main/PSFive9Admin-installer.ps1' | iex

# Optional: Install from PowerShell Gallery (if available)
Install-Module -Name PSFive9Admin
```

### Basic Usage

```powershell
# Import module
Import-Module PSFive9Admin

# Connect to Five9
Connect-Five9AdminWebService

# Start using Five9 API
Get-Five9AgentGroup
Get-Five9User -NamePattern "john.*"
Get-Five9Campaign
```

**That's it!** Your existing scripts work unchanged in both PowerShell 5.1 and 7+.

## Compatibility Matrix

| Platform | PowerShell 5.1 | PowerShell 7+ | Status |
|----------|---------------|---------------|---------|
| Windows | ✅ Supported | ✅ Supported | Fully Compatible |
| macOS | ❌ N/A | ✅ Supported | New in PS7 |
| Linux | ❌ N/A | ✅ Supported | New in PS7 |

## What Changed?

### For End Users
**Nothing!** The API remains identical:
- Same function names
- Same parameters
- Same behavior
- Same output

### Under the Hood
The module now includes two SOAP client implementations:

**PowerShell 5.1**: Uses `New-WebServiceProxy` (original implementation)
**PowerShell 7+**: Uses custom HTTP-based SOAP client

The switch is automatic based on `$PSVersionTable.PSVersion`.

## Technical Details

### How It Works

```
User Script
    ↓
Connect-Five9AdminWebService
    ↓
Version Detection
    ↓
┌───────────────┬────────────────┐
│  PS 5.1       │  PS 7+         │
│  ↓            │  ↓             │
│  New-WebSvc   │  Five9SOAP     │
│  Proxy        │  Client        │
└───────────────┴────────────────┘
    ↓
Five9 SOAP API
```

### New Components

1. **Five9SoapClient.ps1** - PowerShell class that implements SOAP over HTTP
   - Uses `System.Net.Http.HttpClient`
   - Builds SOAP 1.1 envelopes dynamically
   - Handles HTTP Basic Authentication
   - Parses XML responses to PowerShell objects

2. **Add-Five9SoapMethods.ps1** - Generates method wrappers
   - Maps parameter names from WSDL
   - Creates familiar method syntax
   - Maintains API compatibility

3. **Connect-Five9AdminWebService.ps1** - Enhanced connection logic
   - Detects PowerShell version
   - Loads appropriate client
   - Tests connection
   - Returns client object

### Architecture Benefits

- ✅ **No external dependencies** - Pure PowerShell implementation
- ✅ **Cross-platform** - Works on Windows, macOS, Linux
- ✅ **Maintainable** - Easy to extend with new methods
- ✅ **Backward compatible** - Zero breaking changes

### SOAP Details (Appendix)

**SOAP Envelope Format (SOAP 1.1)**
```xml
<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
                                    xmlns:ser="http://service.admin.ws.five9.com/">
    <soapenv:Header/>
    <soapenv:Body>
        <ser:getVCCConfiguration/>
    </soapenv:Body>
</soapenv:Envelope>
```

**Authentication**
```powershell
$credBytes = [System.Text.Encoding]::UTF8.GetBytes("${username}:${password}")
$credBase64 = [Convert]::ToBase64String($credBytes)
$HttpClient.DefaultRequestHeaders.Authorization = 
        [System.Net.Http.Headers.AuthenticationHeaderValue]::new("Basic", $credBase64)
```

**Response Parsing Notes**
- XML is parsed with `[xml]` and converted to `PSCustomObject` instances
- Arrays are detected by repeated elements and normalized to collections
- SOAP faults are detected and thrown as exceptions

## Known Limitations

### Parameter Mapping

Some Five9 API methods may require parameter name mapping. If you encounter an error like:

```
Unmarshalling Error: unexpected element... Expected elements are <{}paramName>
```

**Solution**: Add the method to the parameter mapping in `Add-Five9SoapMethods.ps1`:

```powershell
$parameterMappings = @{
    'methodName' = @('param1', 'param2')
}
```

To find correct parameter names:
```bash
grep -A 5 "complexType name=\"methodName\"" Public/AdminWebService/Five9Admin.wsdl
```

### Currently Mapped Methods

See `Add-Five9SoapMethods.ps1` for the complete list. The most common methods are already mapped:
- `getAgentGroups`, `getAgentGroup`
- `getUsers`, `getUsersInfo`, `getUser`
- `getCampaigns`, `getCampaign`
- `getSkills`, `getLists`, `getDispositions`
- `addAgentToGroup`, `addSkillsToCampaign`
- Many more...

## Troubleshooting

### Enable Verbose Logging

```powershell
$VerbosePreference = 'Continue'
Connect-Five9AdminWebService -Verbose
```

### Test Connection

```powershell
# Run connection test
.\Tests\Test-Connection.ps1

# Test specific functions
.\Tests\Test-Functions.ps1

# Quick PS7 client smoke test
.\Tests\Test-PS7Compatibility.ps1
```

### Common Issues

**"Unable to find type [Five9SoapClient]"**
- Restart PowerShell session
- Re-import module: `Import-Module PSFive9Admin -Force`

**"Expected elements are <{}paramName>"**
- Method needs parameter mapping (see above)

**"SOAP Fault"**
- Check credentials
- Verify domain access
- Check API version compatibility

## Contributing

### Adding New Method Mappings

1. Find the method in the WSDL:
   ```bash
   grep -A 10 "methodName" Public/AdminWebService/Five9Admin.wsdl
   ```

2. Add to `$parameterMappings` in `Add-Five9SoapMethods.ps1`

3. Test the method

4. Submit a pull request

### Reporting Issues

When reporting issues, please include:
- PowerShell version: `$PSVersionTable`
- Operating system
- Error message (full text)
- Method being called
- Minimal reproduction code

## Migration from PowerShell 5.1 to 7

### No Changes Required!

Your existing scripts work without modification:

```powershell
# This works in both PS 5.1 and PS 7+
Import-Module PSFive9Admin
Connect-Five9AdminWebService
Get-Five9AgentGroup
```

### Testing Your Scripts

```powershell
# In PowerShell 7
pwsh
Import-Module PSFive9Admin
.\YourExistingScript.ps1  # Should just work!
```

## Additional Resources

- [Five9 API Documentation](https://www.five9.com/products/application-integration)
- [PowerShell 7 Installation](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
- [Module Repository](https://github.com/Five9DeveloperProgram/PSFive9Admin)

## Support

For issues specific to this module:
- Open an issue on GitHub
- Check existing issues for solutions

For Five9 API questions:
- Consult Five9 documentation
- Contact Five9 support

---

**Note**: This is community-maintained software. See [LICENSE](LICENSE) and README disclaimer for details.
