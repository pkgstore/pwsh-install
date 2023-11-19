function Install-CustomModule() {
  <#
    .SYNOPSIS
    Installing a module from GitHub.

    .DESCRIPTION
    Installing a third-party module from GitHub.

    .PARAMETER Name
    Module name.

    .PARAMETER Prefix
    Module prefix.

    .PARAMETER Version
    Module version.

    .PARAMETER Directory
    Directory for installing the module.

    .PARAMETER GitHubPath
    Organization and repository of the module on GitHub.

    .PARAMETER GitHubToken
    Token for GitHub API.

    .EXAMPLE
    Install-CustomModule -Name 'Kernel' -GitHubPath 'pkgstore/pwsh-kernel'

    .EXAMPLE
    Install-CustomModule -Name 'Kernel' -GitHubPath 'pkgstore/pwsh-kernel' -Version 'v0.1.0'

    .EXAMPLE
    Install-CustomModule -Name 'Kernel' -GitHubPath 'pkgstore/pwsh-kernel' -GitHubToken '<TOKEN>' -Version 'v0.1.0'
  #>

  param(
    [Parameter(Mandatory)][Alias('N')][string]$Name,
    [Alias('P')][string]$Prefix = 'PkgStore',
    [Alias('V')][string]$Version = 'latest',
    [Alias('D')][string]$Directory = "$(($Env:PSModulePath -split ';')[0])",
    [Parameter(Mandatory)][Alias('GHP')][string]$GitHubPath,
    [Alias('GHT')][string]$GitHubToken
  )

  $FullName = "${Prefix}.${Name}"
  $Version = ($Version -eq 'latest') ? $Version : "tags/${Version}"
  $Path = (Join-Path $Directory $FullName)
  $RestHeaders = ($GitHubToken) ? @{Authorization="Bearer ${GitHubToken}"} : @{}

  try {
    Invoke-RestMethod -Headers $RestHeaders -Uri "https://api.github.com/repos/${GitHubPath}/releases/${Version}"
      | ForEach-Object 'zipball_url'
      | ForEach-Object { Invoke-WebRequest $_ -OutFile "${Path}.zip" }

    Expand-Archive -Path "${Path}.zip" -DestinationPath "${Directory}"
    if (Test-Path -Path "${Path}") { Remove-Item -Path "${Path}" -Recurse -Force }
    Rename-Item -Path (Join-Path $Directory "$($GitHubPath.replace('/','-'))-*") -NewName "${Path}"
    Remove-Item -Path "${Path}.zip"
  } catch {
    $_ | Write-Error
  }
}
