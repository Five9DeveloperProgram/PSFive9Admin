<#
.SYNOPSIS
    
    Function used to remove an existing call variable group

.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client


.PARAMETER Name
 
    Name of existing call variable group to be removed
   

.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Remove-Five9CallVariableGroup -AdminClient $proxy -Name Salesforce -Description
    
    # Deletes existing call variable group named "Salesforce"


 
#>

function Remove-Five9CallVariableGroup
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$Name
    )

    
    $response = $AdminClient.deleteCallVariablesGroup($Name)

    return $response

}



