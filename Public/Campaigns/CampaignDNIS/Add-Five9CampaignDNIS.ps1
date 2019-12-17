<#
.SYNOPSIS
    
    Function to add a single 10 digit DNIS, or multiple DNISes to a Five9 inbound campaign
 
.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER CampaignName
 
    Inbound campaign name that a single 10 digit DNIS, or multiple DNISes will be added to

.PARAMETER DNIS
 
    Single 10 digit DNIS, or array of multiple DNISes to be added to an inbound campaign


.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Add-Five9CampaignDNIS -AdminClient $proxy -CampaignName 'Hot-Leads' -DNIS '5991230001'

    # adds a single DNIS to a campaign

.EXAMPLE

    $dnisToBeAdded = @('5991230001', '5991230002', '5991230003')
    Add-Five9CampaignDNIS -AdminClient $proxy -CampaignName 'Hot-Leads' -DNIS $dnisToBeAdded
    
    # adds multiple DNISes to a campaign
    
 
#>
function Add-Five9CampaignDNIS
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$CampaignName,
        [Parameter(Mandatory=$true)][ValidatePattern('^\d{10}$')][string[]]$DNIS
    )

    return $AdminClient.addDNISToCampaign($CampaignName, $DNIS)

}
