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

    "Build System"
    Get-Item ENV:BH*
}

Task Build -Depends Init {
    $ModuleManifest = Get-ChildItem -Filter '*.psd1' | Select-Object -Expand FullName
    $ModuleName = (Split-Path $ModuleManifest -Leaf) -replace '.psd1',''

    "Building $ModuleName manifest..."
    try {
        $CurrentVersion = Get-Metadata -Path $ModuleManifest -PropertyName ModuleVersion

        if ($ENV:BHBuildNumber) {
            $Version = [System.Version]$CurrentVersion
            #+ "." + $ENV:BHBuildNumber
            "Updating $CurrentVersion version with buildNumber to $Version.."
            Update-Metadata -Path $ModuleManifest -PropertyName ModuleVersion -Value $Version -ErrorAction stop
        }
        #$NextNugetVersion = Get-NextNugetPackageVersion -Name $ModuleName -ErrorAction Stop
    } catch {
        "Failed to update metadata for '$ModuleName': $_.`nContinuing with existing version"
    }
}

Task Test -Depends Build  {
    "Testing with PowerShell $PSVersion"

    # Gather test results. Store them in a variable and file
    $TestResults = Invoke-Pester -Path $ProjectRoot\Tests -PassThru -OutputFormat NUnitXml -OutputFile "$ProjectRoot\$TestFile"

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
        Path = $ProjectRoot
        Force = $true
        Recurse = $true
    }
    Invoke-PSDeploy @Verbose @Params
}
