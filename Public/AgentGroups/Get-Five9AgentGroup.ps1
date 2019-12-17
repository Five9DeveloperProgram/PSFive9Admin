<#
.SYNOPSIS
    
    Function used to get agent group(s) from Five9
 
.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER NamePattern
 
    Returns only agent groups matching a given regex string
   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9AgentGroup -AdminClient $proxy
    
    # Returns all agent groups
    
.EXAMPLE
    
    Get-Five9AgentGroup -AdminClient $proxy -NamePattern "Team Joe"
    
    # Returns agent group matching the string "Team Joe"
    
 
#>
function Get-Five9AgentGroup
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$false)][string]$NamePattern = '.*'
    )
    
    return $AdminClient.getAgentGroups($NamePattern)

}
