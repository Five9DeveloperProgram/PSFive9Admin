<#
.SYNOPSIS
    
    Function to reset a campaign to redial every number, except for numbers on the Do-Not-Call list
 
.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER CampaignName
 
    Campaign name to be reset

.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Reset-Five9Campaign -AdminClient $proxy -CampaignName 'Hot-Leads'

    # resets campaign named 'Hot-Leads'

#>
function Reset-Five9Campaign
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$CampaignName
    )

    return $AdminClient.resetCampaign($CampaignName)

}
