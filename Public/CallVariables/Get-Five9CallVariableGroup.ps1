<#
.SYNOPSIS
    
    Function used to get call variable group(s) from Five9

.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client


.PARAMETER GroupName
 
    Returns only call variable groups matching a given regex string. If omitted, all groups will be returned
   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9CallVariableGroup -AdminClient $proxy
    
    # Returns all call variable groups
    
.EXAMPLE
    
    Get-Five9CallVariableGroup -AdminClient $proxy -GroupName "Agent"
    
    # Returns call variable group matching group name "Agent"
    

 
#>

function Get-Five9CallVariableGroup
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$false)][string]$GroupName = '.*'
    )
    
    return $AdminClient.getCallVariableGroups($GroupName)

}



