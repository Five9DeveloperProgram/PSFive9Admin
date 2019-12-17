<#
.SYNOPSIS
    
    Function removes disposition(s) from a Five9 campaign
 
.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER CampaignName
 
    Campaign that disposition(s) will be removed from

.PARAMETER DispositionName
 
    Single disposition name, or multiple disposition names to be added removed from a campaign


.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Remove-Five9CampaignDisposition -AdminClient $proxy -CampaignName 'MultiMedia' -DispositionName 'Wrong Number'

    # removes a single disposition from a campaign

.EXAMPLE

    $dispositionsToBeRemoved = @('Dead Air', 'Wrong Number')
    Remove-Five9CampaignDisposition -AdminClient $proxy -CampaignName 'MultiMedia' -DispositionName $dispositionsToBeRemoved
    
    # removes multiple dispositions from a campaign
    
 
#>
function Remove-Five9CampaignDisposition
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$CampaignName,
        [Parameter(Mandatory=$true)][string[]]$DispositionName
    )

    return $AdminClient.removeDispositionsFromCampaign($CampaignName, $DispositionName)

}

