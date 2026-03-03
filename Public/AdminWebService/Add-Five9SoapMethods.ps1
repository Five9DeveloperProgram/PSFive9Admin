function Add-Five9SoapMethods
{
    <#
    .SYNOPSIS
        Adds dynamic method wrappers to the Five9 SOAP client for PowerShell 7+ compatibility

    .DESCRIPTION
        This function adds ScriptMethod members to the Five9 SOAP client object that wrap
        the InvokeMethod calls, making it compatible with code written for the old New-WebServiceProxy

    .EXAMPLE
        Add-Five9SoapMethods -Client $global:DefaultFive9AdminClient

    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [object]$Client
    )

    # List of common Five9 API methods - expand as needed
    $methods = @(
        'getVCCConfiguration',
        'getApiVersions',
        'getAgentGroups',
        'getAgentGroup',
        'createAgentGroup',
        'modifyAgentGroup',
        'deleteAgentGroup',
        'getAgentsInGroup',
        'addAgentToGroup',
        'removeAgentFromGroup',
        'getUsers',
        'getUser',
        'getUsersInfo',
        'createUser',
        'modifyUser',
        'deleteUser',
        'resetPassword',
        'getUserProfile',
        'getUserProfiles',
        'getUsersGeneralInfo',
        'getCampaigns',
        'getCampaign',
        'createInboundCampaign',
        'createOutboundCampaign',
        'createAutodialCampaign',
        'modifyInboundCampaign',
        'modifyOutboundCampaign',
        'modifyAutodialCampaign',
        'deleteCampaign',
        'startCampaign',
        'stopCampaign',
        'getCampaignProfiles',
        'getCampaignProfile',
        'createCampaignProfile',
        'modifyCampaignProfile',
        'deleteCampaignProfile',
        'getCampaignProfileFilter',
        'getCampaignProfileFilters',
        'modifyCampaignProfileFilter',
        'getDispositions',
        'getDisposition',
        'createDisposition',
        'modifyDisposition',
        'deleteDisposition',
        'getDispositionsImportResult',
        'addDispositionsToCampaign',
        'removeDispositionsFromCampaign',
        'getCallVariables',
        'getCallVariable',
        'getCallVariablesGroup',
        'getCallVariablesGroups',
        'createCallVariable',
        'modifyCallVariable',
        'deleteCallVariable',
        'createCallVariablesGroup',
        'modifyCallVariablesGroup',
        'deleteCallVariablesGroup',
        'getContactFields',
        'getContactField',
        'createContactField',
        'modifyContactField',
        'deleteContactField',
        'addRecordToList',
        'addRecordToListSimple',
        'addToList',
        'addToListCsv',
        'asyncAddRecordsToList',
        'asyncDeleteRecordsFromList',
        'deleteAllFromList',
        'deleteFromContacts',
        'getContactRecords',
        'getLists',
        'getList',
        'createList',
        'modifyList',
        'deleteList',
        'getListsInfo',
        'getContactImportResult',
        'getSkills',
        'getSkill',
        'createSkill',
        'modifySkill',
        'deleteSkill',
        'addSkillsToCampaign',
        'removeSkillsFromCampaign',
        'addSkillAudioFile',
        'getDNISList',
        'getDNIS',
        'createDNIS',
        'modifyDNIS',
        'deleteDNIS',
        'addDNISToCampaign',
        'removeDNISFromCampaign',
        'getIVRScripts',
        'getIVRScript',
        'createIVRScript',
        'modifyIVRScript',
        'deleteIVRScript',
        'getPrompts',
        'getPrompt',
        'getPromptWav',
        'addPromptWav',
        'addPromptWavInline',
        'addPromptTTS',
        'deletePrompt',
        'getSpeedDialNumbers',
        'getSpeedDialNumber',
        'createSpeedDialNumber',
        'modifySpeedDialNumber',
        'deleteSpeedDialNumber',
        'getUserVoicemail',
        'getUsersVoicemail',
        'setUserVoicemailActive',
        'setUserVoicemailGreeting',
        'getDNCList',
        'addNumbersToDnc',
        'deleteNumbersFromDnc',
        'checkDncForNumbers',
        'getReportResults',
        'runReport',
        'isReportRunning'
    )

    # Parameter name mappings based on Five9 WSDL (common patterns)
    # Maps methodName to array of parameter names in order
    $parameterMappings = @{
        'getAgentGroups' = @('groupNamePattern')
        'getAgentGroup' = @('groupName')
        'deleteAgentGroup' = @('groupName')
        'getUsers' = @('userNamePattern')
        'getUsersInfo' = @('userNamePattern')
        'getUser' = @('userName')
        'deleteUser' = @('userName')
        'getCampaigns' = @('campaignNamePattern')
        'getCampaign' = @('campaignName')
        'deleteCampaign' = @('campaignName')
        'startCampaign' = @('campaignName')
        'stopCampaign' = @('campaignName')
        'getSkills' = @('skillNamePattern')
        'getSkill' = @('skillName')
        'deleteSkill' = @('skillName')
        'getLists' = @('listNamePattern')
        'getList' = @('listName')
        'deleteList' = @('listName')
        'getDispositions' = @('dispositionNamePattern')
        'getDisposition' = @('dispositionName')
        'deleteDisposition' = @('dispositionName')
        'getContactFields' = @('fieldNamePattern')
        'getContactField' = @('fieldName')
        'deleteContactField' = @('fieldName')
        'createAgentGroup' = @('agentGroup')
        'modifyAgentGroup' = @('agentGroup')
        'createUser' = @('userGeneralInfo', 'password', 'roles')
        'modifyUser' = @('userGeneralInfo')
        'createCampaign' = @('campaign')
        'modifyCampaign' = @('campaign')
        'getContactRecords' = @('lookupCriteria')
        'addRecordToList' = @('listName', 'record')
        'addDNISToCampaign' = @('campaignName', 'dnisName')
        'removeDNISFromCampaign' = @('campaignName', 'dnisName')
        'addDispositionsToCampaign' = @('campaignName', 'dispositionNames')
        'removeDispositionsFromCampaign' = @('campaignName', 'dispositionNames')
        'addSkillsToCampaign' = @('campaignName', 'skillNames')
        'removeSkillsFromCampaign' = @('campaignName', 'skillNames')
        'addAgentToGroup' = @('groupName', 'userName')
        'removeAgentFromGroup' = @('groupName', 'userName')
        'runReport' = @('folderName', 'reportName', 'criteria')
        'getReportResults' = @('identifier')
        'isReportRunning' = @('identifier')
    }

    foreach ($methodName in $methods)
    {
        # Get parameter mapping for this method
        $paramNames = $parameterMappings[$methodName]
        
        $scriptBlock = if ($paramNames) {
            # Create script block with proper parameter mapping
            [ScriptBlock]::Create(@"
                param([Parameter(ValueFromRemainingArguments)][object[]]`$argList)
                
                `$params = @{}
                `$paramNames = @('$($paramNames -join "', '")')
                
                if (`$null -ne `$argList)
                {
                    for (`$i = 0; `$i -lt [Math]::Min(`$argList.Count, `$paramNames.Count); `$i++)
                    {
                        `$params[`$paramNames[`$i]] = `$argList[`$i]
                    }
                }
                
                return `$this.InvokeMethod('$methodName', `$params)
"@)
        }
        else {
            # No parameters or unknown method - handle generically
            [ScriptBlock]::Create(@"
                param([Parameter(ValueFromRemainingArguments)][object[]]`$argList)
                
                `$params = @{}
                
                if (`$null -ne `$argList -and `$argList.Count -gt 0)
                {
                    for (`$i = 0; `$i -lt `$argList.Count; `$i++)
                    {
                        `$params["arg`$i"] = `$argList[`$i]
                    }
                }
                
                return `$this.InvokeMethod('$methodName', `$params)
"@)
        }

        # Add the method as a ScriptMethod
        $Client | Add-Member -MemberType ScriptMethod -Name $methodName -Value $scriptBlock -Force
    }

    Write-Verbose "Added $($methods.Count) method wrappers to Five9 SOAP client"
}
