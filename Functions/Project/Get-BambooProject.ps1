<#
.SYNOPSIS
    Gets all projects or describes a single Bamboo Project.
.DESCRIPTION
    If -ProjectKey is specified it describes only that project.
.PARAMETER ProjectKey
    Optional - Key for the Bamboo Project to be described
.EXAMPLE
    Get-BambooProject
.EXAMPLE
    Get-BambooProject -ProjectKey 'PRJ'
#>
function Get-BambooProject {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidatePattern('\w+')]
        [string]$ProjectKey,
        [Parameter()]
        [switch]$JsonResponse
    )

    $ContentType = 'application/xml'
    
    if ($JsonResponse -eq $True){
        $ContentType = 'application/json'
    }

    $resource = 'project'
    if ($ProjectKey) {
        $resource = "project/$ProjectKey"
    }

    $response = Invoke-BambooRestMethod -Resource $resource -ContentType $ContentType 
    
    if (-not $JsonResponse){
        $response = $response | Expand-BambooResource -ResourceName 'project'
    }

    $response | Add_ObjectType -TypeName 'PsBamboo.Project'
}
