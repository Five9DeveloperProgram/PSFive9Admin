<#
.SYNOPSIS
    
    Function used to delete an agent group

.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client


.PARAMETER Name
 
    Name of group being removed
   

   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Remove-Five9AgentGroup -AdminClient $proxy -Name "Team Joe"
    
    # Deletes agent group named "Team Joe"
    

    

 
#>

function Remove-Five9AgentGroup
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$Name
    )

    $response =  $AdminClient.deleteAgentGroup($Name)

    return $response

}



