function Install-CustomModule() {
  param(
    [Parameter(Mandatory)][Alias('MN')][string]$ModuleName,
    [Alias('MP')][string]$ModulePrefix = 'PkgStore',
    [Alias('MV')][string]$ModuleVersion = 'latest',
    [Alias('MD')][string]$ModuleDirectory = "$(($Env:PSModulePath -split ';')[0])",
    [Parameter(Mandatory)][Alias('GHP')][string]$GitHubPath,
    [Parameter(Mandatory)][Alias('GHT')][string]$GitHubToken
)

  $ModuleFullName = "${ModulePrefix}.${ModuleName}"
  $ModuleVersion = ($ModuleVersion -eq 'latest') ? $ModuleVersion : "tags/${ModuleVersion}"
  $ModulePath = (Join-Path $ModuleDirectory $ModuleFullName)
  $Headers = @{
    Authorization="Bearer ${GitHubToken}"
  }

  try {
    Invoke-RestMethod -Headers $Headers -Uri "https://api.github.com/repos/${GitHubPath}/releases/${ModuleVersion}"
      | ForEach-Object 'zipball_url'
      | ForEach-Object { Invoke-WebRequest $_ -OutFile "${ModulePath}.zip" }

    Expand-Archive -Path "${ModulePath}.zip" -DestinationPath "${ModuleDirectory}"
    if (Test-Path -Path "${ModulePath}") { Remove-Item -Path "${ModulePath}" -Recurse -Force}
    Rename-Item -Path (Join-Path $ModuleDirectory "$($GitHubPath.replace('/','-'))-*") -NewName "${ModulePath}"
    Remove-Item -Path "${ModulePath}.zip"
  } catch {
    $_ | Write-Error
  }
}
