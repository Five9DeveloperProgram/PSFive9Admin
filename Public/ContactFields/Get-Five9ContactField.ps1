<#
.SYNOPSIS
    
    Function used to return contact field(s) from Five9
 
.PARAMETER Name

    Name of existing contact field. If omitted, all contact fields will be returned

.EXAMPLE

    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9ContactField -AdminClient $proxy

    # Returns all contact fields

.EXAMPLE
    
    Get-Five9ContactField -AdminClient $proxy -Name "first_name"
    
    # Returns contact field with name ""first_name"

#>
function Get-Five9ContactField
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$false)][string]$NamePattern = '.*'
    )

    return $AdminClient.getContactFields($NamePattern)

}
