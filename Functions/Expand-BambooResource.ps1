function Expand-BambooResource {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [ValidateNotNullOrEmpty()]
        [psobject[]]$Response,

        [Parameter()]
        [string]$ResourceName,

        [Parameter()]
        [string]$PluralResourceName="$($ResourceName)s",

        [Parameter()]
        [string]$Root=$PluralResourceName

    )

    if ($Response | Get-Member $Root) {
        if ($Response.$Root.$PluralResourceName | Get-Member $ResourceName) {
            $response.$Root.$PluralResourceName.$ResourceName
        }
    }
    elseif ($Response | Get-Member $ResourceName) {
        @($response.$ResourceName)
    }
}
