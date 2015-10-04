<#
.SYNOPSIS
    Gets all the artifacts for a specific Bamboo Plan.
.PARAMETER PlanKey
    String for the Bamboo Plan.
.EXAMPLE
    Get-BambooArtifact -PlanKey 'PRJ-PLANKEY'
#>
function Get-BambooArtifact {
    param(
        [Parameter()]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey
    )

    Invoke-BambooRestMethod -Resource "plan/$PlanKey/artifact" |
    Expand-BambooResource -ResourceName 'artifact'
}
