<#
.SYNOPSIS
    Clones / Copies a Bamboo plan to a new Plan.
.DESCRIPTION
    If it succeeds, it returns the newly created plan details.
.PARAMETER PlanKey
    Mandatory - Key of the plan to be copied
.PARAMETER NewPlanKey
    Mandatory - New Plankey that will be created as a copy of the original PlanKey
.EXAMPLE
    Copy-BambooPlan -PlanKey 'PRJ-PLANKEY' -NewPlanKey 'PRJ-NEWPLAN'
#>
function Copy-BambooPlan {
    [CmdletBinding()]
     param(
        [Parameter(Mandatory)]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey,

        [Parameter(Mandatory)]
        [ValidatePattern('\w+-\w+')]
        [string]$NewPlanKey
    )

    Invoke-BambooRestMethod -Resource "clone/$($PlanKey):$($NewPlanKey)" -Method Put |
    Expand-BambooResource -ResourceName 'plan' |
    Add_ObjectType -TypeName 'PsBamboo.Plan'
}
