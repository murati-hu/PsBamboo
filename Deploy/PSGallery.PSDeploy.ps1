# Publish to gallery with a few restrictions
if ($env:BHBuildSystem -ine 'Unknown' -and $env:BHBranchName -eq "master") {
    Deploy Module {
        By PSGalleryModule {
            FromSource Resolve-Path '../'
            To PSGallery
            WithOptions @{
                ApiKey = $ENV:PsGalleryApiKey
            }
        }
    }
} else {
    "Skipping deployment: To deploy, ensure that...`n" +
    "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
    "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n"
}
