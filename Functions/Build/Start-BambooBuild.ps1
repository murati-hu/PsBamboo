<#
.SYNOPSIS
    Triggers a build for the specified Plan.
.DESCRIPTION
    The cmdlet returns the build details, if it succeeds.
.PARAMETER PlanKey
    Mandatory - PlanKey for the latest build to be started
.EXAMPLE
    Start-BambooBuild -PlanKey 'PRJ-PLANKEY'
#>
function Start-BambooBuild {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey
    )

    Start-BambooCustomBuild -PlanKey $PlanKey
}
