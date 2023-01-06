# PowerShell Install Module

PowerShell module for installing PowerShell from GitHub.

## Install

```powershell
Install-PSM -N 'Install'
```

## Syntax

Install PowerShell `v7.2.8` to `C:\Apps\PowerShell` directory.

```powershell
Install-PowerShell -V '7.2.8' -T 'zip'
```
Install PowerShell `v7.3.1` from MSI package.

```powershell
Install-PowerShell -V '7.3.1' -T 'msi'
```
