<#
.SYNOPSIS
    Triggers a customised build for the specified Plan.
.DESCRIPTION
    The cmdlet returns the build details, if it succeeds.
.PARAMETER PlanKey
    Mandatory - PlanKey for the latest build to be started
.PARAMETER BambooVariables
    Optional - The variables that you wish to pass to the build plan
.PARAMETER Revision
    Optional - The revision of the repository (by default it will use the latest)
.EXAMPLE
    Start-BambooCustomBuild -PlanKey 'PRJ-PLANKEY' -BambooVariables @{'environment'='Production';'timeout'='300'} -Revision '9c3133faca5d886a809126719e13dc7853edf7df'
#>
function Start-BambooCustomBuild {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey,
        [psobject]$BambooVariables=@{},
        [string]$Revision
    )

    $UriParams = @{}

    if (-not [string]::IsNullOrWhiteSpace($Revision)) {
        $UriParams.Add("customRevision", $Revision)
    }

    if ($BambooVariables -and $BambooVariables.Keys) {
        foreach($key in $BambooVariables.Keys) {
            $UriParams.Add([System.Web.HttpUtility]::UrlEncode("bamboo.variable.$($key)"), [System.Web.HttpUtility]::UrlEncode($BambooVariables.$key))
        }
    }

    Start-BambooBuild -PlanKey $PlanKey -UriParams $UriParams
}
