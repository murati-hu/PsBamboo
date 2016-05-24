<#
.SYNOPSIS
    Gets build logs for a single Bamboo Build Result
.DESCRIPTION
    It fetches the build result for a specific or latest build a specific
    plan and returns it as text.
 
.PARAMETER BuildKey
    Optional - Key for the exact Bamboo build to get the build results
.PARAMETER PlanKey
    Optional - Key for the Bamboo Plans to filter 
.PARAMETER Build
    Optional - Parameter to specify the build in question, by default it
    always returns the latest build. The valid values are:
        LATEST - to return the latest build info
        BUILD-Number - to return an exact build result by its id

.EXAMPLE
    Get-BambooBuildLog -BuildKey PSB-BB-22

.EXAMPLE
    Get-BambooBuildLog 
#>
function Get-BambooBuildLog {
    [CmdletBinding(DefaultParameterSetName="ByPlanKey")]
    param(
        [Parameter(Mandatory,ParameterSetName="ByBuildKey")]
        [Alias('BuildResultKey')]
        [ValidatePattern('\w+-\w+-\d+')]
        [string]$BuildKey,

        [Parameter(Mandatory,ParameterSetName="ByPlanKey")]

        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey,

        [Parameter(ParameterSetName="ByPlanKey")]
        [ValidatePattern('\d+|latest')]
        [string]$Build='latest',
        
        [Parameter(Mandatory,ParameterSetName="ByPlanKey")]
        [Parameter(Mandatory,ParameterSetName="ByBuildKey")]
        [ValidatePattern('\w+')]
        [string]$StageKey
    )
    
    if ($BuildKey -and ($BuildKey -imatch '(\w+-\w+)-(\d+)')) {
        $PlanKey = $Matches[1]
        $Build = $Matches[2]
    }
    
    $buildResult = Get-BambooBuild -PlanKey $PlanKey -Build $Build
    $logUrl = "$($script:BambooServer)/download/$PlanKey-$StageKey/build_logs/$PlanKey-$StageKey-$($buildResult.buildNumber).log"
    (Invoke-WebRequest -Uri $logUrl -UseBasicParsing -ErrorAction Stop).Content
}
