## 1.0.0 (Oct 4, 2015)
Initial version of PSBamboo for Bamboo REST resources.
 - Basic Authentication support and resource helpers
 - Plan resources: Get, Clone, Disable, Enable
 - PlanBranch resource: Get, Add, Disable, Enable
 - Additional resources: Project, Artifact, Result, QueuedBuilds

## 1.2.0 (Mar 3, 2016)
- Fixes to `BambooQueuedBuilds`
- Support to start `CustomBuilds`

## 1.3.0 (Mar 3, 2016)
- Added paging support to `Get-BambooPlan`
- New switches to define target `Stage` or `ExecuteAllStages` for custombuilds
- Improved Error reporting
- Pipeline fixes

## 2.0.0 (Mar 6, 2016)
- Major Authentication changes to enable direct Token Usage
- Removed `Set-BambooCredential` function
- Introduced `Set-BambooAuthentication` with `PSCredential` and direct
`AuthenticationToken`
