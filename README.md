# PowerShell Install Module

Module for installing third-party modules from GitHub.

## Install

```powershell
$MOD = "Install"; $PFX = "PkgStore"; $DIR = "$(($Env:PSModulePath -split ';')[0])"; Invoke-WebRequest "https://github.com/pkgstore/pwsh-${MOD}/archive/refs/heads/main.zip" -OutFile (Join-Path $DIR "${MOD}.zip"); Expand-Archive -Path (Join-Path $DIR "${MOD}.zip") -DestinationPath "${DIR}"; if (Test-Path -Path (Join-Path $DIR "${PFX}.${MOD}")) { Remove-Item -Path (Join-Path $DIR "${PFX}.${MOD}") -Recurse -Force }; Rename-Item -Path (Join-Path $DIR "pwsh-${MOD}-main") -NewName (Join-Path $DIR "${PFX}.${MOD}"); Remove-Item -Path (Join-Path $DIR "${MOD}.zip");
```
