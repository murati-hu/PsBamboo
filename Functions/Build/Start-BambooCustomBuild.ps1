<#
.SYNOPSIS
    Triggers a customised build for the specified Plan.
.DESCRIPTION
    The cmdlet returns the build details, if it succeeds.
.PARAMETER PlanKey
    Mandatory - PlanKey for the latest build to be started
.PARAMETER ExecuteAllStages
    Optional - Switch to execute all manual stages in the build
.PARAMETER Stage
    Optional - Name of the stage which should be finished
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
        [switch]$ExecuteAllStages,
        [string]$Stage,
        [psobject]$BambooVariables=@{},
        [string]$Revision
    )

    $UriParams = @{}

    if ($ExecuteAllStages) {
        $UriParams.Add('executeAllStages', 'true')
    }

    if (-not [string]::IsNullOrWhiteSpace($Stage)) {
        $UriParams.Add('stage', $Stage)
    }

    if (-not [string]::IsNullOrWhiteSpace($Revision)) {
        $UriParams.Add('customRevision', $Revision)
    }

    if ($BambooVariables -and $BambooVariables.Keys) {
        Add-Type -AssemblyName System.Web
        foreach($key in $BambooVariables.Keys) {
            $UriParams.Add([System.Web.HttpUtility]::UrlEncode("bamboo.variable.$($key)"), [System.Web.HttpUtility]::UrlEncode($BambooVariables.$key))
        }
    }

    Invoke-BambooRestMethod -Resource "queue/$($PlanKey)" -Method Post -UriParams $UriParams |
    Expand-BambooResource -ResourceName 'restQueuedBuild'
}
