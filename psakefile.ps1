# Visuals and shared properties
FormatTaskName ("`n$("-"*70)`n{0}`n$("-"*70)`n")

Properties {
    $ProjectRoot = $ENV:BHProjectPath
    if(-not $ProjectRoot) {
        $ProjectRoot = $PSScriptRoot
    }

    $Timestamp = Get-date -uformat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $TestFile = "TestResults_PS$PSVersion`_$TimeStamp.xml"

    $Verbose = @{}
    if($ENV:BHCommitMessage -match "!verbose") {
        $Verbose = @{Verbose = $True}
    }
}

Task Default -Depends Deploy

Task Init {
    Set-Location $ProjectRoot

    "Prepare module output"
    Remove-Item -Path $Env:BHBuildOutput -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -Path $Env:BHPSModulePath -Force -ItemType Directory
    Copy-Item -Path ./* -Destination $Env:BHPSModulePath -Recurse -Exclude @('BuildOutput','Deploy','appveyor.yml','build.ps1','psakefile.ps1')

    "Build System"
    Get-Item ENV:BH*
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
    $TestResults = Invoke-Pester -Path $Env:BHPSModulePath\Tests -PassThru -OutputFormat NUnitXml -OutputFile "$ProjectRoot\$TestFile"

    # In Appveyor?  Upload our tests! #Abstract this into a function?
    If($ENV:BHBuildSystem -ieq 'AppVeyor') {
        (New-Object 'System.Net.WebClient').UploadFile(
            "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)",
            "$ProjectRoot\$TestFile" )
    }

    Remove-Item "$ProjectRoot\$TestFile" -Force -ErrorAction SilentlyContinue


    if($TestResults.FailedCount -gt 0) {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
}

Task Deploy -Depends Test {
    $Params = @{
        Path = $Env:BHPSModulePath
        Force = $true
        Recurse = $true
    }
    Invoke-PSDeploy @Verbose @Params
}
