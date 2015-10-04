<#
.SYNOPSIS
    Enables a Bamboo plan by its key.
.DESCRIPTION
    It doesn't return any object if it succeeds.
.PARAMETER PlanKey
    Mandatory - Key of the plan to be enabled
.EXAMPLE
    Enable-BambooPlan -PlanKey 'PRJ-PLANKEY'
#>
function Enable-BambooPlan {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey
    )
    Invoke-BambooRestMethod -Resource "plan/$PlanKey/enable" -Method Post
}
