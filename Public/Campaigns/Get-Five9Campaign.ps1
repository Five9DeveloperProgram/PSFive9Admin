<#
.SYNOPSIS
    
    Function used to get campaign(s) from Five9
 
 
.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER Type
 
    Campaign Type. Options are: INBOUND, OUTBOUND, AUTODIAL

.PARAMETER NamePattern
 
    Optional parameter. Returns only dispositions matching a given regex string

.NOTES

    Returning a single campaign also returns additional details that are NOT returned when multiple campaigns are returned.
   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9Campaign -AdminClient $proxy -Type OUTBOUND
    
    # Returns basic info on all outbound campaigns
    
.EXAMPLE
    
    Get-Five9Campaign -AdminClient $proxy -Type OUTBOUND -NamePattern 'MultiMedia' 

    # Returns basic and additional info for outbound campaign with name "MultiMedia"
    
 
#>
function Get-Five9Campaign
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][ValidateSet('OUTBOUND', 'INBOUND', 'AUTODIAL')][string]$Type,
        [Parameter(Mandatory=$false)][string]$NamePattern = '.*'
        
    )


    $response = @($AdminClient.getCampaigns($NamePattern, $Type, $true))

    if ($response.Count -gt 1)
    {
        return $response

    }
    elseif ($response.Count -eq 1)
    {
        $response = $response | select -First 1

        if ($Type -eq "OUTBOUND")
        {
            $AdminClient.getOutboundCampaign($response.name)
        }
        elseif ($Type -eq "INBOUND")
        {
            $AdminClient.getInboundCampaign($response.name)
        }
        elseif ($Type -eq "AUTODIAL")
        {
            $AdminClient.getAutodialCampaign($response.name)
        }
    }



}

