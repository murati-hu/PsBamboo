PsBamboo PowerShell module
==========================

PsBamboo is a PowerShell module that provides a wrapper for [Bamboo][bamboo]
[REST API][bambooapi] to allow easier access and manipulation of [Bamboo][bamboo]
resources in a scriptable and automatable manner.

The module handles both authenticated and anonymous methods and supports the following
resources: Project, Plan, PlanBranch, BuildQueue, Artifact, Server, CurrentUser

In addition to several already implemented functions, it also provides
generic cmdlets to access any not yet covered Bamboo REST resources too.

## Usage
```powershell
Import-Module PsBamboo

# Set the target server
Set-BambooServer -Url 'http://bamboo.mydomain.com:8085'

# Get all Projects
Get-BambooProject
```

Authenticated access
```powershell
Set-BambooCredential -UserName <user> -Password <password>
Get-BambooCurrentUser
```

All available Cmdlets
```powershell
Get-Command -Module PsBamboo | Select Name

Add-BambooPlanBranch
Copy-BambooPlan
Disable-BambooPlan
Disable-BambooPlanBranch
Enable-BambooPlan
Enable-BambooPlanBranch
Expand-BambooResource
Get-BambooArtifact
Get-BambooCurrentUser
Get-BambooPlan
Get-BambooPlanBranch
Get-BambooProject
Get-BambooQueuedBuild
Get-BambooResult
Invoke-BambooRestMethod
Resume-BambooQueuedBuild
Set-BambooCredential
Set-BambooServer
Stop-BambooQueuedBuild
```

## Documentation
Cmdlets and functions for PsBamboo have their own help PowerShell help, which
you can read with `help <cmdlet-name>`. Wiki is also added to this project with
some more information.

## Versioning
PsBamboo aims to adhere to [Semantic Versioning 2.0.0][semver].

## Development

* Source hosted at [BitBucket][repo]
* Report issues/questions/feature requests on [Bitbucket Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors
Created and maintained by [Akos Murati][muratiakos] (<akos@murati.hu>).

## License
Apache License, Version 2.0 (see [LICENSE][LICENSE])

[repo]: https://bitbucket.org/murati-hu/psbamboo
[wiki]: https://bitbucket.org/murati-hu/psbamboo/wiki
[issues]: https://bitbucket.org/murati-hu/psbamboo/issues
[bamboo]: https://www.atlassian.com/software/bamboo
[bambooapi]: https://developer.atlassian.com/bamboodev/rest-apis
[muratiakos]: http://murati.hu
[license]: LICENSE
[semver]: http://semver.org/
