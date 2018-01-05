# Publish to AppVeyor if we're in AppVeyor
if($env:BHBuildSystem -eq 'AppVeyor') {
    Deploy DeveloperBuild {
        By AppVeyorModule {
            FromSource (Resolve-Path -Path './')
            To AppVeyor
            WithOptions @{
                Version = $env:APPVEYOR_BUILD_VERSION
            }
        }
    }
}
