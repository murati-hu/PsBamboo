function Get-BambooProject {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidatePattern('\w+')]
        [string]$ProjectKey
    )

    $resource = 'project'
    if ($ProjectKey) {
        $resource = "project/$ProjectKey"
    }

    Invoke-BambooRestMethod -Resource $resource | #-Expand 'projects.project'
    Expand-BambooResource -ResourceName 'project' #|
    #Add-Member -MemberType AliasProperty ProjectKey key -PassThru |
    #Add-Member -MemberType AliasProperty ProjectName name -PassThru
}
