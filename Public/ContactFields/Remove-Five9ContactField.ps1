<#
.SYNOPSIS
    
    Function used to remove an existing contact field
 
.PARAMETER Name

    Name of contact field to be removed

.NOTES

    • All campaigns must be stopped before removing a contact field

.EXAMPLE
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Remove-Five9ContactField -AdminClient $proxy -Name 'hair_color'

    # Removes contact field named "hair_color"



#>
function Remove-Five9ContactField
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$Name
    )

    return $AdminClient.deleteContactField($Name)
}
