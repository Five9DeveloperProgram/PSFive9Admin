<#
.SYNOPSIS
    
    Function used to delete a skill

.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client


.PARAMETER SkillName
 
    Skill name to be deleted

   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Remove-Five9Skill -AdminClient $proxy -SkillName "MultiMedia"
    
    # Deletes skill named MultiMedia
    

#>
function Remove-Five9Skill
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$SkillName
    )

    $response = $AdminClient.deleteSkill($SkillName)

    return $response

}
