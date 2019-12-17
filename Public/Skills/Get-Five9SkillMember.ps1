<#
.SYNOPSIS
    
    Function used to get the members of a given skill

.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client


.PARAMETER SkillName
 
    Skill Name to get members of

   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Get-Five9SkillMember -AdminClient $proxy -SkillName "MultiMedia"
    
    # Gets members of skill MultiMedia
    

#>
function Get-Five9SkillMember
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$SkillName
    )

    $response = $AdminClient.getSkillInfo($SkillName)

    return $response.users
}



