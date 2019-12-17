<#
.SYNOPSIS

    Function returns the attributes of the dialing lists associated with an outbound campaign
 
.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER CampaignName
 
    Outbound campaign name that list(s) will be returned from

.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9CampaignList -AdminClient $proxy -CampaignName 'Hot-Leads'

    # returns lists associated with a campaign


#>
function Get-Five9CampaignList
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$CampaignName
    )

    return $AdminClient.getListsForCampaign($CampaignName)

}

