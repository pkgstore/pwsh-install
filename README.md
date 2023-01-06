# PowerShell Install Module

PowerShell module for installing PowerShell from GitHub.

## Install

```powershell
Install-PSM -N 'Install'
```

## Syntax

1. Install PowerShell to `C:\Apps\PowerShell` directory.  
```powershell
Install-PowerShell -V '7.2.8' -T 'zip'
```
2. Install MSI PowerShell.  
```powershell
Install-PowerShell -V '7.2.8' -T 'msi'
```
