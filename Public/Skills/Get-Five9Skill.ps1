<#
.SYNOPSIS
    
    Function used to get Skill objects from Five9

.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client


.PARAMETER NamePattern
 
    Returns only skills matching a given regex string
   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9Skill -AdminClient $proxy
    
    # Returns all skills
    
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9Skill -AdminClient $proxy -NamePattern "MultiMedia"
    
    # Returns all skills matching the string "MultiMedia"
    

 
#>

function Get-Five9Skill
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$false)][string]$NamePattern = '.*'
    )
    
    return $AdminClient.getSkills($NamePattern)

}



