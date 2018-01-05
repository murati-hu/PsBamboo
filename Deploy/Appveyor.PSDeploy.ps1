# Publish to AppVeyor if we're in AppVeyor
if($env:BHPSModulePath -and $env:BHBuildSystem -eq 'AppVeyor') {
    Deploy DeveloperBuild {
        By AppVeyorModule {
            FromSource $Env:BHPSModulePath
            To AppVeyor
            WithOptions @{
                Version = (Get-Metadata -Path $ENV:BHPSModuleManifest -PropertyName ModuleVersion)
            }
        }
    }
}
