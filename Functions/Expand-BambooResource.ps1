<#
.SYNOPSIS
    Helper cmdlet to convert Bamboo REST API responses to PS pipeline output
.DESCRIPTION
    It accepts any response XML object as an input and expands it content by
    the -ResourceName parameter.
.PARAMETER Response
    Mandatory - Response object as an input
.PARAMETER ResourceName
    Mandatory - Name of the single resource to be expanded from the response XML.
.PARAMETER PluralResourceName
    Optional - Plural name of the resource in case teh response contains
    multiple items. This parameter requires override if appending an 's'
    character to the -ResourceName is not the valid PluralResourceName.
.PARAMETER Root
    Optional - Root node of the XML response that needs to be processed.
    This parameter requires an override, if the root element name is different
    from the -PluralResourceName.

.EXAMPLE
    Invoke-BambooRestMethod -Resource "plan/$PlanKey/artifact" |
    Expand-BambooResource -ResourceName 'artifact' |
#>
function Expand-BambooResource {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [ValidateNotNullOrEmpty()]
        [psobject[]]$Response,

        [Parameter(Mandatory)]
        [string]$ResourceName,

        [Parameter()]
        [string]$PluralResourceName="$($ResourceName)s",

        [Parameter()]
        [string]$Root=$PluralResourceName

    )

    if (-Not $Response) { return }

    if ($Response | Get-Member $Root) {
        if ($Response.$Root.$PluralResourceName | Get-Member $ResourceName) {
            $response.$Root.$PluralResourceName.$ResourceName
        }
    }
    elseif ($Response | Get-Member $ResourceName) {
        @($response.$ResourceName)
    }
}
