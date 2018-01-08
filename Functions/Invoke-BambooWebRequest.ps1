<#
.SYNOPSIS
    Generic helper cmdlet to invoke web requests agains a target Bamboo server.
.DESCRIPTION
    This cmdlet extends the original Invoke-WebRequest cmdlet with Bamboo specific parameters, so it does user authorization and provides easier
    resource access.

.PARAMETER Resource
    Mandatory - Bamboo REST API Resource that needs to be accessed
.PARAMETER Method
    Optional - HTTP method to be used for the call. (Default is GET)
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
    Invoke-BambooWebRequest -Resource "plan"
.EXAMPLE
    Invoke-BambooWebRequest -Resource "plan/PRJ-PLAN/enable" -Method Delete

.LINK
    https://developer.atlassian.com/bamboodev/rest-apis
#>
function Invoke-BambooWebRequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Resource,

        [ValidateSet('Get','Put','Post','Delete')]
        [string]$Method = 'Get',

        [ValidateSet('latest')]
        [string]$Server = $script:BambooServer,
        [string]$Uri="$Server/$Resource",

        [string]$AuthenticationMode=$script:AuthenticationMode,
        [string]$AuthenticationToken = $script:AuthenticationToken,

        [string]$ContentType='text/html',
        
        [psobject]$UriParams=@{},
        [psobject]$Headers=@{},
        [psobject]$Body
    )

    if (-Not $UriParams) { $UriParams = @{} }

    switch ($AuthenticationMode) {
        "BASIC" {
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
        $response = Invoke-WebRequest -Uri $Uri -Method:$Method -Headers:$Headers -DisableKeepAlive -ContentType $ContentType 
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
