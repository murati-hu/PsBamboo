Properties {
    $Verbose = @{}
    if($ENV:BHCommitMessage -match "!verbose") {
        $Verbose = @{Verbose = $True}
    }
}

FormatTaskName ("`n$("-"*70)`n{0}`n$("-"*70)`n")

Task Default -Depends Deploy

Task Init {
    "Build System"
    Get-Item ENV:BH*

    "Prepare module output"
    Set-Location $PSScriptRoot
    Remove-Item -Path $Env:BHBuildOutput -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -Path $Env:BHPSModulePath -Force -ItemType Directory | Out-Null
    Copy-Item -Path ./* -Destination $Env:BHPSModulePath -Recurse -Exclude @('BuildOutput','Deploy','appveyor.yml','build.ps1','psakefile.ps1')
}

Task Build -depends Init {
    "Building $ModuleName manifest..."
    try {
        $CurrentVersion = Get-Metadata -Path $ENV:BHPSModuleManifest -PropertyName ModuleVersion

        if ($ENV:BHBuildNumber) {
            #$NextNugetVersion = Get-NextNugetPackageVersion -Name $ModuleName -ErrorAction Stop
            $Version = $CurrentVersion -replace '\d+$',$ENV:BHBuildNumber
            "Updating $CurrentVersion version with BuildNumber to $Version.."
            Update-Metadata -Path $ENV:BHPSModuleManifest -PropertyName ModuleVersion -Value $Version -ErrorAction stop
        }
    } catch {
        "Failed to update metadata for '$ENV:BHProjectName': $_.`nContinuing with existing version"
    }
}

Task Test -Depends Build  {
    $TestFile = Join-Path $Env:BHBuildOutput "PesterTestResults_$(Get-date -uformat "%Y%m%d-%H%M%S").xml"
    $TestResults = Invoke-Pester -Path $Env:BHPSModulePath\Tests -PassThru -OutputFormat NUnitXml -OutputFile $TestFile

    If($env:APPVEYOR_JOB_ID) {
        $appVeyorTestUrl = "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)"
        (New-Object 'System.Net.WebClient').UploadFile($appVeyorTestUrl, $TestFile)
    }
    Remove-Item -Path $TestFile -Force -ErrorAction SilentlyContinue

    if($TestResults.FailedCount -gt 0) {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
}

Task Deploy -Depends Test {
    $Params = @{
        Path = $Env:BHProjectPath
        Force = $true
        Recurse = $true
    }
    Invoke-PSDeploy @Verbose @Params
}
