# Publish to gallery with a few restrictions
if ($env:BHBuildSystem -ine 'Unknown' -and $env:BHBranchName -eq "master") {
    Deploy Module {
        By PSGalleryModule {
            FromSource $Env:BHPSModulePath
            To PSGallery
            WithOptions @{
                ApiKey = $ENV:PsGalleryApiKey
            }
        }
    }
} else {
    "Skipping PSGallery deployment, since build running:`n" +
    "`t* in an unknown build system (Current: $ENV:BHBuildSystem)`n" +
    "`t* or not in the master branch (Current: $ENV:BHBranchName) `n" |
    Write-Host -ForegroundColor Yellow
}
