<#
.SYNOPSIS
    
    Function to returns the list of DNIS associated with an inbound campaign
 
.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER CampaignName
 
    Inbound campaign name

.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9CampaignDNIS -AdminClient $proxy -CampaignName 'Hot-Leads'

    # Returns the list of DNIS associated with a campaign
    
#>
function Get-Five9CampaignDNIS
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$CampaignName
    )

    return $AdminClient.getCampaignDNISList($CampaignName)

}
