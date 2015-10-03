function Set-BambooCredential {
    param(
        [Parameter()]
        [ValidateSet('Basic')]
        [string]$Authentication='Basic',

        [ValidateNotNullOrEmpty()]
        [string]$UserName,

        [ValidateNotNullOrEmpty()]
        [string]$Password
    )
    $script:BambooAuthMode = $Authentication
    $script:BambooCredential=[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $UserName,$Password)))
}
