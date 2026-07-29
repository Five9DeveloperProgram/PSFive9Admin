# Debug script to test Get-Five9User
Import-Module (Join-Path $PSScriptRoot "../PSFive9Admin.psd1") -Force

$cred = Get-Credential -Message "Enter Five9 credentials"
Connect-Five9AdminWebService -Credential $cred

Write-Host "Testing raw API call..." -ForegroundColor Cyan
try {
    $response = $global:DefaultFive9AdminClient.getUsersInfo('.*')
    Write-Host "Got $($response.Count) users from API" -ForegroundColor Green
    
    # Check first user structure
    if ($response.Count -gt 0) {
        $firstUser = $response[0]
        Write-Host "`nFirst user structure:" -ForegroundColor Cyan
        Write-Host "Username: $($firstUser.generalInfo.userName)"
        Write-Host "Has roles: $($firstUser.roles -ne $null)"
        Write-Host "Has agent role: $($firstUser.roles.agent -ne $null)"
        
        if ($firstUser.roles.agent -ne $null) {
            Write-Host "`nAgent role structure:"
            $firstUser.roles.agent | Get-Member -MemberType Properties | Select-Object Name, MemberType
            
            Write-Host "`nAgent permissions array:"
            $firstUser.roles.agent.permissions | ForEach-Object {
                if ($_.type -match 'Record') {
                    Write-Host "  Type: $($_.type), Value: $($_.value)" -ForegroundColor Yellow
                } else {
                    Write-Host "  Type: $($_.type), Value: $($_.value)"
                }
            }
        }
    }
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    $_ | Write-Error
}
