<#
.SYNOPSIS
    
    Function to returns the list of DNIS for the domain
 
.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER SelectUnassigned

    • True: only DNIS not assigned to a campaign are returned
    • False (Default): all DNIS provisioned for the domain are returned


.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9DNIS -AdminClient $proxy

    # returns list of all DNIS for the domain

.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9DNIS -AdminClient $proxy -SelectUnassigned: $true

    # returns only DNIS not assigned to a campaign
    
#>
function Get-Five9DNIS
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$false)][bool]$SelectUnassigned = $false
    )

    return $AdminClient.getDNISList($SelectUnassigned, $true)

}
