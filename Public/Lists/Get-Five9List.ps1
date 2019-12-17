<#
.SYNOPSIS
    
    Function used to get list(s) from Five9

.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER NamePattern
 
    Returns lists matching a given regex string
   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9List -AdminClient $proxy
    
    # Returns all agent groups
    
.EXAMPLE
    
    Get-Five9List -AdminClient $proxy -NamePattern "Cold-Call-List"
    
    # Returns list that matches the name "Cold-Call-List"

 
#>
function Get-Five9List
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$false)][string]$NamePattern = '.*'

    )

    $response = $AdminClient.getListsInfo($NamePattern)

    return $response


}

