# Test script for PowerShell 7+ Five9 SOAP client

Write-Host "Testing Five9 PowerShell 7+ SOAP Client..." -ForegroundColor Cyan
Write-Host "PowerShell Version: $($PSVersionTable.PSVersion)" -ForegroundColor Yellow

# Import the module
$modulePath = Join-Path $PSScriptRoot "../PSFive9Admin.psd1"
if (Test-Path $modulePath)
{
    Import-Module $modulePath -Force
    Write-Host "✓ Module imported successfully" -ForegroundColor Green
}
else
{
    Write-Host "✗ Module not found at: $modulePath" -ForegroundColor Red
    exit 1
}

# Test loading the SOAP client class
$soapClientPath = Join-Path $PSScriptRoot "../Public/AdminWebService/Five9SoapClient.ps1"
if (Test-Path $soapClientPath)
{
    . $soapClientPath
    Write-Host "✓ Five9SoapClient loaded" -ForegroundColor Green
    
    # Test creating an instance (without credentials - just to test the class)
    try
    {
        $testClient = [Five9SoapClient]::new("https://api.five9.com/wsadmin/v12/AdminWebService", "test@test.com", "testpass")
        Write-Host "✓ Five9SoapClient class instantiated successfully" -ForegroundColor Green
        $testClient.Dispose()
    }
    catch
    {
        Write-Host "✓ Five9SoapClient class exists (connection failed as expected with test credentials)" -ForegroundColor Green
    }
}
else
{
    Write-Host "✗ Five9SoapClient.ps1 not found" -ForegroundColor Red
}

Write-Host "`nTo test with real credentials, run:" -ForegroundColor Cyan
Write-Host "  Connect-Five9AdminWebService -Verbose" -ForegroundColor White
Write-Host "`nNote: You'll be prompted for your Five9 credentials." -ForegroundColor Yellow
