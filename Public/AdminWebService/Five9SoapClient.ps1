# Five9 SOAP Helper for PowerShell 7+
# This class provides a SOAP client wrapper that works in PowerShell 7+ without New-WebServiceProxy

class Five9SoapClient {
    [string]$EndpointUrl
    [System.Net.Http.HttpClient]$HttpClient
    [string]$Username
    [string]$Password
    [hashtable]$Operations
    [string]$Five9DomainName
    [string]$Five9DomainId
    [string]$Version
    [string]$DataCenter
    [int]$Timeout = 1000000
    
    Five9SoapClient([string]$endpointUrl, [string]$username, [string]$password) {
        $this.EndpointUrl = $endpointUrl
        $this.Username = $username
        $this.Password = $password
        $this.HttpClient = [System.Net.Http.HttpClient]::new()
        $this.HttpClient.Timeout = [TimeSpan]::FromMilliseconds($this.Timeout)
        
        # Set Basic Auth header
        $credBytes = [System.Text.Encoding]::UTF8.GetBytes("${username}:${password}")
        $credBase64 = [Convert]::ToBase64String($credBytes)
        $this.HttpClient.DefaultRequestHeaders.Authorization = `
            [System.Net.Http.Headers.AuthenticationHeaderValue]::new("Basic", $credBase64)
        
        # Initialize operations hashtable
        $this.Operations = @{}
    }
    
    [object] InvokeMethod([string]$methodName, [hashtable]$parameters = @{}) {
        # Build SOAP envelope
        $soapEnvelope = $this.BuildSoapEnvelope($methodName, $parameters)
        
        # Create HTTP content
        $content = [System.Net.Http.StringContent]::new(
            $soapEnvelope,
            [System.Text.Encoding]::UTF8,
            "text/xml"
        )
        
        # Add SOAPAction header
        $content.Headers.Add("SOAPAction", "")
        
        try {
            # Send request
            $response = $this.HttpClient.PostAsync($this.EndpointUrl, $content).GetAwaiter().GetResult()
            $responseContent = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
            
            if (-not $response.IsSuccessStatusCode) {
                throw "SOAP request failed: $($response.StatusCode) - $responseContent"
            }
            
            # Parse response
            return $this.ParseSoapResponse($responseContent, $methodName)
        }
        catch {
            $message = @"
Failed to connect to Five9 API. Common causes:
1. Invalid credentials
2. Domain ID not accessible
3. Network/firewall blocking HTTPS to Five9
4. Five9 API maintenance window

Method: $methodName
Error: $($_.Exception.Message)
"@
            throw $message
        }
    }
    
    hidden [string] BuildSoapEnvelope([string]$methodName, [hashtable]$parameters) {
        $sb = [System.Text.StringBuilder]::new()
        [void]$sb.AppendLine('<?xml version="1.0" encoding="utf-8"?>')
        [void]$sb.AppendLine('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.admin.ws.five9.com/">')
        [void]$sb.AppendLine('  <soapenv:Header/>')
        [void]$sb.AppendLine('  <soapenv:Body>')
        [void]$sb.AppendLine("    <ser:$methodName>")
        
        # Add parameters without namespace prefix (Five9 expects unqualified parameter names)
        foreach ($key in $parameters.Keys) {
            $value = $parameters[$key]
            if ($null -eq $value) {
                [void]$sb.AppendLine("      <$key xsi:nil='true' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'/>")
            }
            elseif ($value -is [array]) {
                foreach ($item in $value) {
                    [void]$sb.AppendLine("      <$key>$([System.Security.SecurityElement]::Escape($item.ToString()))</$key>")
                }
            }
            elseif ($value -is [hashtable] -or $value.GetType().Name -like '*PSCustomObject*') {
                [void]$sb.AppendLine("      <$key>")
                $this.BuildComplexType($sb, $value, "        ")
                [void]$sb.AppendLine("      </$key>")
            }
            else {
                [void]$sb.AppendLine("      <$key>$([System.Security.SecurityElement]::Escape($value.ToString()))</$key>")
            }
        }
        
        [void]$sb.AppendLine("    </ser:$methodName>")
        [void]$sb.AppendLine('  </soapenv:Body>')
        [void]$sb.AppendLine('</soapenv:Envelope>')
        
        return $sb.ToString()
    }
    
    hidden [void] BuildComplexType([System.Text.StringBuilder]$sb, [object]$obj, [string]$indent) {
        if ($obj -is [hashtable]) {
            foreach ($key in $obj.Keys) {
                $value = $obj[$key]
                if ($null -eq $value) {
                    [void]$sb.AppendLine("${indent}<$key xsi:nil='true' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'/>")
                }
                elseif ($value -is [hashtable] -or $value.GetType().Name -like '*PSCustomObject*') {
                    [void]$sb.AppendLine("${indent}<$key>")
                    $this.BuildComplexType($sb, $value, "$indent  ")
                    [void]$sb.AppendLine("${indent}</$key>")
                }
                else {
                    [void]$sb.AppendLine("${indent}<$key>$([System.Security.SecurityElement]::Escape($value.ToString()))</$key>")
                }
            }
        }
        else {
            # Handle PSCustomObject
            $obj.PSObject.Properties | ForEach-Object {
                $key = $_.Name
                $value = $_.Value
                if ($null -eq $value) {
                    [void]$sb.AppendLine("${indent}<$key xsi:nil='true' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'/>")
                }
                elseif ($value -is [hashtable] -or $value.GetType().Name -like '*PSCustomObject*') {
                    [void]$sb.AppendLine("${indent}<$key>")
                    $this.BuildComplexType($sb, $value, "$indent  ")
                    [void]$sb.AppendLine("${indent}</$key>")
                }
                else {
                    [void]$sb.AppendLine("${indent}<$key>$([System.Security.SecurityElement]::Escape($value.ToString()))</$key>")
                }
            }
        }
    }
    
    hidden [object] ParseSoapResponse([string]$xml, [string]$methodName) {
        try {
            $xmlDoc = [xml]$xml
            
            # Check for SOAP fault using multiple namespace approaches
            $namespaceManager = [System.Xml.XmlNamespaceManager]::new($xmlDoc.NameTable)
            $namespaceManager.AddNamespace("soap", "http://schemas.xmlsoap.org/soap/envelope/")
            $namespaceManager.AddNamespace("soapenv", "http://schemas.xmlsoap.org/soap/envelope/")
            
            # Check for fault
            $fault = $xmlDoc.SelectSingleNode("//soap:Fault", $namespaceManager)
            if ($null -eq $fault) {
                $fault = $xmlDoc.SelectSingleNode("//soapenv:Fault", $namespaceManager)
            }
            if ($null -eq $fault) {
                $fault = $xmlDoc.GetElementsByTagName("Fault") | Select-Object -First 1
            }
            
            if ($null -ne $fault) {
                $faultString = $fault.GetElementsByTagName("faultstring")[0].InnerText
                $faultCode = $fault.GetElementsByTagName("faultcode")[0].InnerText
                throw "SOAP Fault ($faultCode): $faultString"
            }
            
            # Find response element (try multiple approaches)
            $responseElement = $xmlDoc.GetElementsByTagName("${methodName}Response") | Select-Object -First 1
            if ($null -eq $responseElement) {
                # Try finding by LocalName
                $responseElement = $xmlDoc.GetElementsByTagName("*") | 
                    Where-Object { $_.LocalName -eq "${methodName}Response" } | 
                    Select-Object -First 1
            }
            
            if ($null -ne $responseElement) {
                # Check for 'return' element (common in Five9 responses)
                $returnElement = $responseElement.GetElementsByTagName("return") | Select-Object -First 1
                if ($null -ne $returnElement) {
                    return $this.ConvertXmlToPSObject($returnElement)
                }
                
                # Otherwise convert the whole response
                if ($responseElement.ChildNodes.Count -gt 0) {
                    return $this.ConvertXmlToPSObject($responseElement)
                }
                
                return $null
            }
            
            # If no specific response element, try to find the body content
            $body = $xmlDoc.SelectSingleNode("//soap:Body/*", $namespaceManager)
            if ($null -eq $body) {
                $body = $xmlDoc.SelectSingleNode("//soapenv:Body/*", $namespaceManager)
            }
            
            if ($null -ne $body) {
                return $this.ConvertXmlToPSObject($body)
            }
            
            return $null
        }
        catch {
            Write-Warning "Error parsing SOAP response: $($_.Exception.Message)"
            Write-Verbose "Response XML: $xml"
            throw
        }
    }
    
    hidden [object] ConvertXmlToPSObject([System.Xml.XmlNode]$node) {
        # If node has no children or only text, return the text
        if ($node.ChildNodes.Count -eq 0 -or ($node.ChildNodes.Count -eq 1 -and $node.ChildNodes[0].NodeType -eq 'Text')) {
            return $node.InnerText
        }
        
        # Check if this is an array (multiple elements with same name)
        $childGroups = $node.ChildNodes | Where-Object { $_.NodeType -eq 'Element' } | Group-Object -Property LocalName
        
        $result = [PSCustomObject]@{}
        
        foreach ($group in $childGroups) {
            if ($group.Count -gt 1) {
                # Array of elements
                $array = @()
                foreach ($element in $group.Group) {
                    $array += $this.ConvertXmlToPSObject($element)
                }
                $result | Add-Member -MemberType NoteProperty -Name $group.Name -Value $array
            }
            else {
                # Single element
                $value = $this.ConvertXmlToPSObject($group.Group[0])
                $result | Add-Member -MemberType NoteProperty -Name $group.Name -Value $value
            }
        }
        
        return $result
    }
    
    [void] Dispose() {
        if ($null -ne $this.HttpClient) {
            $this.HttpClient.Dispose()
        }
    }
}
