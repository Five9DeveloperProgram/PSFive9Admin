<#
.SYNOPSIS
    
    Function to stop a campaign
 
.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER CampaignName
 
    Campaign name that will be stopped

.PARAMETER Force

    Force stops the campaign, which immediately disconnects all active calls

.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Stop-Five9Campaign -AdminClient $proxy -CampaignName 'Hot-Leads'

    # stops campaign named 'Hot-Leads' gracefully

.EXAMPLE
    
    Stop-Five9Campaign -AdminClient $proxy -CampaignName 'Hot-Leads' -Force $true

    # stops campaign named 'Hot-Leads' forcefully, which immediately disconnects all active calls

 
#>
function Stop-Five9Campaign
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$CampaignName,
        [Parameter(Mandatory=$false)][bool]$Force = $false
    )

    if ($Force -eq $true)
    {
        return $AdminClient.forceStopCampaign($CampaignName)
    }
    else
    {
        return $AdminClient.stopCampaign($CampaignName)
    }

    

}
