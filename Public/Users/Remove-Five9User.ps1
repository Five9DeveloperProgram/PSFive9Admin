<#
.SYNOPSIS
    
    Function used to delete a user
 
.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client


.PARAMETER Username
 
    New skill name

   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Remove-Five9Skill -AdminClient $proxy -Username 'jdoe@domain.com'
    
    # Deletes user with username "jdoe@domain.com"
    

#>
function Remove-Five9Skill
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$Username
    )

    $response = $AdminClient.deleteUser($Username)

    return $response

}
