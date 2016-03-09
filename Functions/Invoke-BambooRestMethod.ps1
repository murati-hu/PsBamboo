<#
.SYNOPSIS
    Generic helper cmdlet to invoke Rest methods agains a target Bamboo server.
.DESCRIPTION
    This cmdlet extends the original Invoke-RestMethod cmdlet with Bamboo REST
    API specific parameters, so it does user authorization and provides easier
    resource access.

.PARAMETER Resource
    Mandatory - Bamboo REST API Resource that needs to be accessed
.PARAMETER Method
    Optional - REST method to be used for the call. (Default is GET)
.PARAMETER ApiVersion
    Optional - REST API version that needs to be targeted for the call,
    for future purposes. Default is the latest.

.PARAMETER AuthenticationMode
    Optional - Authentication Mode to access Bamboo Server
.PARAMETER AuthenticationToken
    Optional - Authentication Token to access Bamboo Server

.PARAMETER UriParams
    Optional - Parameters that needs to be appended to the GET url.
.PARAMETER Headers
    Optional - HTTP Headers that needs to be added for the REST call.
.PARAMETER Body
    Optional - HTTP Body payload

.EXAMPLE
    Invoke-BambooRestMethod -Resource "plan"
.EXAMPLE
    Invoke-BambooRestMethod -Resource "plan/PRJ-PLAN/enable" -Method Delete

.LINK
    https://developer.atlassian.com/bamboodev/rest-apis
#>
function Invoke-BambooRestMethod {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Resource,

        [ValidateSet('Get','Put','Post','Delete')]
        [string]$Method = 'Get',

        [ValidateSet('latest')]
        [string]$ApiVersion='latest',
        [string]$Server = $script:BambooServer,
        [string]$Uri="$Server/rest/api/$ApiVersion/$Resource",

        [string]$AuthenticationMode=$script:AuthenticationMode,
        [string]$AuthenticationToken = $script:AuthenticationToken,

        [string]$Expand,
        [string]$ContentType='application/xml',
        
        [psobject]$UriParams=@{},
        [psobject]$Headers=@{},
        [psobject]$Body
    )

    if (-Not $UriParams) { $UriParams = @{} }

    if ($Expand) { $UriParams.expand=$Expand }

    switch ($AuthenticationMode) {
        "BASIC" {
            $UriParams.os_authType='basic'
            $Headers.Authorization = "$AuthenticationMode $AuthenticationToken"
        }
        default {
            Write-Verbose "Accessing Bamboo without credentials."
        }
    }

    if ($UriParams -and $UriParams.Keys) {
        $Params = ''
        foreach($key in $UriParams.Keys) {
            $Params+="$key=$($UriParams.$key)&"
        }
        if ($Params) {
            $Uri = "$($Uri)?$Params"
        }
    }
    $response = $null

    try {
        Write-Verbose "$Method : $Uri"
        $response = Invoke-RestMethod -Uri $Uri -Method:$Method -Headers:$Headers -DisableKeepAlive -ContentType $ContentType
    } catch {
        if ($_.ErrorDetails) {
            Write-Error $_.ErrorDetails.Message
        } else {
            Write-Error $_
        }
    }

    Write-Verbose "Response: $response"
    if ($response -is [xml]) {
        Write-Debug ($response.OuterXml -replace '><',">`n<")
    }
    $response
}
