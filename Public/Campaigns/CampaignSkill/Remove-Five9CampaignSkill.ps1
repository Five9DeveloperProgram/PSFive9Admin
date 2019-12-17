<#
.SYNOPSIS
    
    Function to remove skill(s) from a Five9 campaign
 
.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER CampaignName
 
    Campaign name that skill(s) will be removed from

.PARAMETER Skill

    Single skill name, or array of multiple skill names to be removed from a campaign


.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Remove-Five9CampaignDNIS -AdminClient $proxy -CampaignName 'Hot-Leads' -Skill 'Skill-1'

    # removes a single skill from a campaign

.EXAMPLE

    $skillsToBeRemoved = @('Skill-1', 'Skill-2', 'Skill-3')
    Remove-Five9CampaignDNIS -AdminClient $proxy -CampaignName 'Hot-Leads' -Skill $skillsToBeRemoved
    
    # removes array of multiple skills from a campaign
    
 
#>
function Remove-Five9CampaignSkill
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$CampaignName,
        [Parameter(Mandatory=$true)][string[]]$Skill
    )

    return $AdminClient.removeSkillsFromCampaign($CampaignName, $Skill)

}
