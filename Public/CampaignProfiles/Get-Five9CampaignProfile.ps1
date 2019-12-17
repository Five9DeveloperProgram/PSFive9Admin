<#
.SYNOPSIS
    
    Function used to return campaign profile(s) from Five9
 
.PARAMETER Name

    Name of existing campaign profile. If omitted, all campaign profiles will be returned

.EXAMPLE

    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9CampaignProfile -AdminClient $proxy

    # Returns all campaign profiles

.EXAMPLE
    
    Get-Five9CampaignProfile -AdminClient $proxy -Name "Cold-Calls-Profile"
    
    # Returns campaign profile with name "Cold-Calls-Profile"

#>
function Get-Five9CampaignProfile
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$false)][string]$NamePattern = '.*'
    )

    return $AdminClient.getCampaignProfiles($NamePattern)

}
