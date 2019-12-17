<#
.SYNOPSIS
    
    Function used to delete an existing campaign in Five9
 
.PARAMETER Name

    Name of existing campaign to be removed

.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Remove-Five9InboundCampaign -AdminClient $proxy -Name "Cold-Calls"
    
    # Removes campaign named "Cold-Calls"

#>
function Remove-Five9Campaign
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$Name
    )

    $response = $AdminClient.deleteCampaign($Name)

    return $response

}

