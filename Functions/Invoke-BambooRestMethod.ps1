function Invoke-BambooRestMethod {
    [CmdletBinding()]
    param(
        [string]$Resource,
        [string]$Method = 'Get',
        [string]$ApiVersion='latest',
        [string]$Server = $script:BambooServer,
        [string]$Uri="$Server/rest/api/$ApiVersion/$Resource",
        [string]$Authentication=$script:BambooAuthMode,
        [string]$Credential = $script:BambooCredential,
        [string]$Expand,
        [psobject]$UriParams=@{},
        [psobject]$Headers=@{}
    )

    if ($Expand) {
        $UriParams.expand=$Expand
    }

    if ($Method -match 'Post|Get|Put') {
        $Headers."Content-Type"="application/xml"
    }

    switch ($Authentication) {
        "BASIC" {
            #$UriParams.os_authType="basic"
            $Headers.Authorization = "$Authentication $Credential"
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
        $response = Invoke-RestMethod -Uri $Uri -Method:$Method -Headers:$Headers
    } catch {
        Write-Error $_.ErrorDetails.Message
        #Write-Error $_.Exception
    }

    $response
    #TODO: better error handling
}
