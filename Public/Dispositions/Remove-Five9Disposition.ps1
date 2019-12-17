<#
.SYNOPSIS
    
    Function used to delete a Five9 disposition

.PARAMETER AdminClient
 
    Mandatory parameter. SOAP Proxy Client Object. Use function "New-Five9AdminClient" to get SOAP client

.PARAMETER Name

    Name of existing disposition to be removed

   
.EXAMPLE
    
    $proxy = New-Five9AdminClient -Username "user@domain.com" -Password "P@ssword!"
    Remove-Five9Disposition -AdminClient $proxy -Name "Default-Disposition"

    # Deletes existing disposition named "Default-Disposition"

    
 
#>
function Remove-Five9Disposition
{
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        [Parameter(Mandatory=$true)][PSFive9Admin.WsAdminService]$AdminClient,
        [Parameter(Mandatory=$true)][string]$Name
    )


    $response = $AdminClient.removeDisposition($Name)

    return $response

}

