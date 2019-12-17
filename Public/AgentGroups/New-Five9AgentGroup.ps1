<#
.SYNOPSIS
    
    Function used to create an agent group

.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER Name
 
    Name for new agent group
   
.PARAMETER Description
 
    Description for new agent group
   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    New-Five9AgentGroup -AdminClient $proxy -Name "Team Joe" -Description "Joe Montana's team members"
    
    # Creates new group named "Team Joe"
    
#>

function New-Five9AgentGroup
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][string]$Description
    )


    $agentGroup = New-Object PSFive9Admin.agentGroup
    $agentGroup.name = $Name
    $agentGroup.description = $Description

    
    $response =  $AdminClient.createAgentGroup($agentGroup)

    return $response

}



