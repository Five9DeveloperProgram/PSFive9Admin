# PowerShell 7+ Compatibility Update

## Overview

This PowerShell module has been updated to work with PowerShell 7+ (PowerShell Core). The original implementation used `New-WebServiceProxy` which is not available in PowerShell 7+. The new implementation uses a custom HTTP-based SOAP client that works in both Windows PowerShell 5.1 and PowerShell 7+.

## What Changed

### New Files Added

1. **Five9SoapClient.psm1** - PowerShell class that implements SOAP client functionality using `HttpClient`
   - Builds SOAP envelopes dynamically
   - Handles HTTP Basic Authentication
   - Parses SOAP responses to PowerShell objects
   - Works natively in PowerShell 7+

2. **Add-Five9SoapMethods.ps1** - Helper function that adds method wrappers to the SOAP client
   - Makes the new client API-compatible with the old `New-WebServiceProxy` approach
   - Maps method parameters correctly based on WSDL
   - Existing module functions continue to work without changes

3. **Test-PS7Compatibility.ps1** - Test script to verify PowerShell 7 compatibility

### Modified Files

1. **Connect-Five9AdminWebService.ps1** - Updated to detect PowerShell version and use appropriate implementation
   - PowerShell 7+: Uses new `Five9SoapClient` class
   - PowerShell 5.1: Uses original `New-WebServiceProxy` approach
   - Maintains backward compatibility

## How It Works

### PowerShell Version Detection

The connection function now detects which version of PowerShell is running:

```powershell
if ($PSVersionTable.PSVersion.Major -ge 7)
{
    # Use new HTTP-based SOAP client
}
else
{
    # Use legacy New-WebServiceProxy
}
```

### SOAP Client Implementation

The new `Five9SoapClient` class:

1. **Creates HTTP client** with Basic Authentication headers
2. **Builds SOAP envelopes** dynamically based on method name and parameters
3. **Sends HTTP POST** requests to the Five9 SOAP endpoint
4. **Parses XML responses** and converts them to PowerShell objects
5. **Handles errors** and SOAP faults appropriately

### Method Wrapper System

The `Add-Five9SoapMethods` function adds ScriptMethod members to the client object that:

1. Accept the same parameters as the original proxy
2. Map parameters to correct WSDL parameter names
3. Call `InvokeMethod()` on the SOAP client
4. Return results in the same format as before

This means existing code like:
```powershell
$groups = $client.getAgentGroups(".*")
```

Works identically in both PowerShell 5.1 and 7+.

## Testing

### Basic Test

Run the compatibility test:

```powershell
pwsh ./Test-PS7Compatibility.ps1
```

### Connection Test

Connect to Five9 using PowerShell 7:

```powershell
pwsh
Connect-Five9AdminWebService -Verbose
```

### Function Test

Test existing module functions:

```powershell
# After connecting
Get-Five9AgentGroup
Get-Five9User
Get-Five9Campaign
```

## Compatibility

- ✅ **PowerShell 7.0+** - Fully supported using new SOAP client
- ✅ **PowerShell 5.1** - Continues using original `New-WebServiceProxy`
- ✅ **Windows** - Both PowerShell versions work
- ✅ **macOS/Linux** - PowerShell 7+ works

## Technical Details

### SOAP Envelope Format

The client generates SOAP 1.1 envelopes with proper namespacing:

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

### Authentication

HTTP Basic Authentication is configured in the `HttpClient`:

```powershell
$credBytes = [System.Text.Encoding]::UTF8.GetBytes("${username}:${password}")
$credBase64 = [Convert]::ToBase64String($credBytes)
$HttpClient.DefaultRequestHeaders.Authorization = 
    [System.Net.Http.Headers.AuthenticationHeaderValue]::new("Basic", $credBase64)
```

### Response Parsing

XML responses are parsed using `[xml]` type accelerator and converted to PSCustomObjects:

- Arrays are detected automatically (multiple elements with same name)
- Nested objects are handled recursively
- SOAP faults are detected and thrown as exceptions

## Known Limitations

1. **Complex Parameter Types** - Some complex object types may require additional mapping
2. **Performance** - Slight overhead compared to native proxy (negligible for most uses)
3. **Binary Data** - File attachments may require special handling

## Troubleshooting

### Enable Verbose Logging

```powershell
Connect-Five9AdminWebService -Verbose
```

### Check SOAP Request/Response

The SOAP client includes debug output when warnings occur. To see full XML:

```powershell
$VerbosePreference = 'Continue'
# Your commands here
```

### Common Issues

**"Method not found"** - Method may not be in the wrapper list. Add it to `Add-Five9SoapMethods.ps1`

**"Parameter mismatch"** - Check parameter name mapping in `Add-Five9SoapMethods.ps1`

**"Connection timeout"** - Increase timeout in the client initialization (default: 1000 seconds)

## Future Enhancements

1. **Complete WSDL-based proxy generation** - Use `dotnet-svcutil` to generate full client
2. **Async method support** - Add async versions of SOAP methods
3. **Connection pooling** - Reuse HTTP connections for better performance
4. **Enhanced error messages** - Parse Five9-specific error codes

## References

- [Five9 API Documentation](https://www.five9.com/products/application-integration)
- [PowerShell 7 Migration Guide](https://docs.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7)
- [.NET 8 SOAP Client Guide](dotNet8.md)
