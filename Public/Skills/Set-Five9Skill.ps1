<#
.SYNOPSIS
    
    Function used to modify a skill

.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER SkillName
 
    Skill to modify's name

.PARAMETER Description
 
    New description

.PARAMETER RouteVoiceMails
 
    Whether to route voicemail messages to the skill
   

.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Set-Five9Skill -AdminClient $proxy -SkillName "MultiMedia" -Description "Skill used for MultiMedia" -RouteVoiceMails: $true
    
    # Modifies the skill MultiMedia's properties
    

#>
function Set-Five9Skill
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$SkillName,
        [Parameter(Mandatory=$false)][string]$Description,
        [Parameter(Mandatory=$false)][bool]$RouteVoiceMails
    )

    $skill = New-Object PSFive9Admin.skill
    $skill.name = $SkillName
    $skill.description = $Description

    if ($RouteVoiceMails -eq $true)
    {
        $skill.routeVoiceMailsSpecified = $true
        $skill.routeVoiceMails = $true
    }
    elseif ($RouteVoiceMails -eq $false)
    {
        $skill.routeVoiceMailsSpecified = $true
        $skill.routeVoiceMails = $false
    }


    $response = $AdminClient.modifySkill($skill)

    return $response.skill

}
