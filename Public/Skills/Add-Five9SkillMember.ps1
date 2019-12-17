<#
.SYNOPSIS
    
    Function used to add a member to an existing skill

.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client


.PARAMETER Username
 
    Username of user being added to skill

.PARAMETER SkillName
 
    Skill Name that user is being added to

.PARAMETER SkillLevel
 
    Optional parameter. User's priority level in skill. Default value = 1


   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Add-Five9SkillMember -AdminClient $proxy -Username "jdoe@domain.com" -SkillName "Multimedia"
    
    # Adds user jdoe@domain.com to skill Multimedia
    

#>
function Add-Five9SkillMember
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$Username,
        [Parameter(Mandatory=$true)][string]$SkillName,
        [Parameter(Mandatory=$false)][string]$SkillLevel = 1
    )

    $userSkill = New-Object PSFive9Admin.userSkill
    $userSkill.userName = $Username
    $userSkill.skillName = $SkillName
    $userSkill.level = $SkillLevel
    
    $response = $AdminClient.userSkillAdd($userSkill)

    return $response
}



