<#
.SYNOPSIS
    
    Function used to create a new Five9 list

.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER Name

    Name of new list
   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    New-Five9List -AdminClient $proxy -Name "Cold-Call-List"

    # Creates a new list

 
#>
function New-Five9List
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$Name

    )

    $response = $AdminClient.createList($Name)

    return $response


}

