<#
.SYNOPSIS
    
    Function used to get User Profile object(s) from Five9

.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client


.PARAMETER NamePattern
 
    Returns only user profiles matching a given regex string
   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9UserProfile -AdminClient $proxy
    
    # Returns all User Profiles
    
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9UserProfile -AdminClient $proxy -NamePattern "Call_Center_Agent"
    
    # Returns all profiles matching the string "Call_Center_Agent"
    

 
#>

function Get-Five9UserProfile
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$false)][string]$NamePattern = '.*'
    )
    
    return $AdminClient.getUserProfiles($NamePattern)

}



