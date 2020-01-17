<#
.SYNOPSIS
    Gets all environments for a Bamboo Deploy Project or describes a single Bamboo Deploy Project environment.
.DESCRIPTION
    If -EnvironmentId is specified it describes only that Deploy Project environment.
.PARAMETER EnvironmentId
    Mandatory - Id for the Bamboo Deploy Project environment to find tasks for
.EXAMPLE
    Get-BambooDeployProjectEnvironmentTasks
.EXAMPLE
    Get-BambooDeployProjectEnvironmentTasks -EnvironmentId 70778893 -Verbose
#>
function Get-BambooDeployProjectEnvironmentTasks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('\w+')]
        [string]$EnvironmentId
    )

    Write-Warning "Get-BambooDeployProjectEnvironmentTasks: The Bamboo API does not allow for querying of 'Deploy Project Environment Tasks' so we do some rather nasty screen scraping of the web UI here"

    $resource = "deploy/config/configureEnvironmentTasks.action"
    $uriParams = @{"environmentId" = $EnvironmentId}

    $bambooResponse = Invoke-BambooWebRequest -Resource $resource -UriParams $uriParams

    $taskDetails = New-Object System.Collections.ArrayList
    $items = $bambooResponse.ParsedHTML.body.getElementsByClassName('item')
    
    foreach ($item in $items) {

        $itemTitle = ($item.getElementsByClassName('item-title'))[0].innerHTML
        if ($itemTitle -ne $null) {
            
            $itemDescription = "---"
            try {
                $itemDescription = ($item.getElementsByClassName('item-description'))[0].innerHTML
            }
            catch {
                $itemDescription = "---"
            }
            
            $taskDetail = New-Object PSObject -Property @{
                orderId = [Int]$item.getAttribute('data-item-id')
                title = $itemTitle
                description = $itemDescription
                isDisabled = $item.innerText.Contains("Disabled")
            }       
            $taskDetails.Add($taskDetail) > $null
        }
    }

    return $taskDetails

}
