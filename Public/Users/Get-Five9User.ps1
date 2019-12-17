<#
.SYNOPSIS
    
    Function used to get User object(s) from Five9

.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client


.PARAMETER NamePattern
 
    Optional regex parameter. If used, function will return only users matching regex string
   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9User -AdminClient $proxy
    
    # Returns all Users
    
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9User -AdminClient $proxy -NamePattern "jdoe@domain.com"
    
    # Returns user who matches the string "jdoe@domain.com"
    

 
#>

function Get-Five9User
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$false)][string]$NamePattern = '.*'
    )
    
    $response = $AdminClient.getUsersInfo($NamePattern)

    return $response

}



