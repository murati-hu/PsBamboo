function Set-BambooServer {
    param(
        [Parameter()]
        [ValidatePattern('^(https?:\/\/)([\w\.-]+)(:\d+)*\/*')]
        [string]$Url
    )
    $script:BambooServer = $Url
}
