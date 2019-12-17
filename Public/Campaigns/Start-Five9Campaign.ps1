<#
.SYNOPSIS
    
    Function to start a campaign
 
.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER CampaignName
 
    Campaign name to be started

.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Start-Five9Campaign -AdminClient $proxy -CampaignName 'Hot-Leads'

    # starts campaign named 'Hot-Leads'


 
#>
function Start-Five9Campaign
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$CampaignName
    )

    return $AdminClient.startCampaign($CampaignName)

}
