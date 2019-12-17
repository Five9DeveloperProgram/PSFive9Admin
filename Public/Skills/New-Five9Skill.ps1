<#
.SYNOPSIS
    
    Function used to create a new skill
 
.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client


.PARAMETER SkillName
 
    New skill name

.PARAMETER Description
 
    New skill description

.PARAMETER RouteVoiceMails
 
    Whether to route voicemail messages to the skill
   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    New-Five9Skill -AdminClient $proxy -SkillName "MultiMedia"
    
    # Creates a new skill named MultiMedia
    

#>
function New-Five9Skill
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


    $skillInfo = New-Object PSFive9Admin.skillInfo
    $skillInfo.skill = $skill
    $skillInfo.users = @()

    $response = $AdminClient.createSkill($skillInfo)

    return $response.skill

}
