function Install-PowerShell() {
  <#
    .SYNOPSIS
      Download and install PowerShell.

    .DESCRIPTION

    .PARAMETER Version
      PowerShell version.
      Alias: '-V'.

    .PARAMETER Type
      Package type.
      Default: 'zip'.
      Alias: '-T'.

    .PARAMETER MSIOpenPS
      Property controls the option for adding the 'Open PowerShell' item to the context menu in Windows Explorer.
      Default: '0'.
      Alias: '-OPS'.
    .PARAMETER MSIRunPS
      Property controls the option for adding the 'Run with PowerShell' item to the context menu in Windows Explorer.
      Default: '0'.
      Alias: '-RPS'.
    .PARAMETER MSIPSRemoting
      Property controls the option for enabling PowerShell remoting during installation.
      Default: '1'.
      Alias: '-PSR'.
    .PARAMETER MSIManifest
      Property controls the option for registering the Windows Event Logging manifest.
      Default: '1'.
      Alias: '-PSM'.
    .PARAMETER MSIMUUse
      Updating through Microsoft Update, WSUS, or Configuration Manager.
      Default: '1'.
      Alias: '-MUU'.
    .PARAMETER MSIMUEnable
      Using Microsoft Update for Automatic Updates.
      Default: '1'.
      Alias: '-MUE'.
    .PARAMETER MSIPath
      Property controls the option for adding PowerShell to the Windows PATH environment variable.
      Default: '1'.
      Alias: '-PSP'.

    .EXAMPLE
      Install-PowerShell -V '7.2.8' -T 'zip'

    .EXAMPLE
      Install-PowerShell -V '7.2.8' -T 'msi' -OPS 1 -RPS 1

    .LINK
      Package Store: https://github.com/pkgstore

    .NOTES
      Author: Kitsune Solar <mail@kitsune.solar>
  #>

  [CmdletBinding()]

  Param(
    [Parameter(Mandatory)]
    [ValidatePattern('^((\d+)\.(\d+)\.(\d+))$')]
    [Alias('V')]
    [string]${Version},

    [ValidateSet('msi', 'zip')]
    [Alias('T')]
    [string]${Type} = 'zip',

    [ValidateRange(0,1)]
    [Alias('OPS')]
    [int]${MSIOpenPS} = 0,

    [ValidateRange(0,1)]
    [Alias('RPS')]
    [int]${MSIRunPS} = 0,

    [ValidateRange(0,1)]
    [Alias('PSR')]
    [int]${MSIPSRemoting} = 1,

    [ValidateRange(0,1)]
    [Alias('PSM')]
    [int]${MSIManifest} = 1,

    [ValidateRange(0,1)]
    [Alias('MUU')]
    [int]${MSIMUUse} = 1,

    [ValidateRange(0,1)]
    [Alias('MUE')]
    [int]${MSIMUEnable} = 1,

    [ValidateRange(0,1)]
    [Alias('PSP')]
    [int]${MSIPath} = 1
  )

  ${URL_DL} = "https://github.com/PowerShell/PowerShell/releases/download"
  ${D_APPS} = "${env:SystemDrive}\Apps"
  ${D_PWSH} = "${D_APPS}\PowerShell"
  ${F_PWSH} = "PowerShell-${Version}-win-x64.${Type}"

  Write-Information -MessageData "Create directory: '${D_APPS}'..." -InformationAction "Continue"
  New-Item -Path "${D_APPS}" -ItemType "Directory" -Force | Out-Null

  Write-Information -MessageData "Download PowerShell: '${F_PWSH}'..." -InformationAction "Continue"
  Invoke-WebRequest "${URL_DL}/v${Version}/${F_PWSH}" -OutFile "${D_APPS}\${F_PWSH}"

  if ( "${Type}" -eq 'zip' ) {
    if ( Test-Path -Path "${D_PWSH}" ) { Remove-Item -Path "${D_PWSH}" -Recurse -Force }
    Write-Information -MessageData "Expand: '${F_PWSH}'" -InformationAction "Continue"
    Expand-Archive -Path "${D_APPS}\${F_PWSH}" -DestinationPath "${D_PWSH}"
    Remove-Item -Path "${D_APPS}\${F_PWSH}";
  } elseif ( "${Type}" -eq 'msi' ) {
    Write-Information -MessageData "Install: '${F_PWSH}'" -InformationAction "Continue"
    msiexec.exe /package "${D_APPS}\${F_PWSH}" /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=${MSIOpenPS} ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=${MSIRunPS} ENABLE_PSREMOTING=${MSIPSRemoting} REGISTER_MANIFEST=${MSIManifest} USE_MU=${MSIMUUse} ENABLE_MU=${MSIMUEnable} ADD_PATH=${MSIPath}
  } else {
    Write-Error -Message "Package type not found!" -ErrorAction "Stop"
  }
}
