<#
.SYNOPSIS
    Disables a Bamboo plan by its key.
.DESCRIPTION
    It doesn't return any object if it succeeds.
.PARAMETER PlanKey
    Mandatory - Key of the plan to be disabled
.EXAMPLE
    Disable-BambooPlan -PlanKey 'PRJ-PLANKEY'
#>
function Disable-BambooPlan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey
    )
    Invoke-BambooRestMethod -Resource "plan/$PlanKey/enable" -Method Delete
}
