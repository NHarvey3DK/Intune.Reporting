function Get-GroupPolicyConfigurationsDefinitionValuesDefinition {
    <#
    .SYNOPSIS
    This function is used to get device configuration policies from the Graph API REST interface
    .DESCRIPTION
    The function connects to the Graph API Interface and gets any device configuration policies
    .EXAMPLE
    Get-DeviceConfigurationPolicy
    Returns any device configuration policies configured in Intune
    .NOTES
    NAME: Get-GroupPolicyConfigurations
    #>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$groupPolicyConfigurationID,

        [Parameter(Mandatory = $true)]
        [string]$GroupPolicyConfigurationsDefinitionValueID
    )
    $graphApiVersion = "Beta"
    $gpc_resource = "deviceManagement/groupPolicyConfigurations/$groupPolicyConfigurationID/definitionValues/$GroupPolicyConfigurationsDefinitionValueID/definition"
    try {
        $uri = "https://graph.microsoft.com/$graphApiVersion/$($gpc_resource)"
        $responseBody = Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get
    }
    catch {
        $ex = $_.Exception
        $errorResponse = $ex.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorResponse)
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $responseBody = $reader.ReadToEnd();
        Write-Host "Response content:`n$responseBody" -f Red
        Write-Error "Request to $uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
        Write-Host
        break
    }
    $responseBody
}