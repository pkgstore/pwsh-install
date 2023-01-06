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

    .EXAMPLE
      Install-PowerShell -V '7.2.8' -T 'zip'

    .EXAMPLE
      Install-PowerShell -V '7.2.8' -T 'msi'

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
    [string]${Type} = 'zip'
  )

  ${URL_DL} = "https://github.com/PowerShell/PowerShell/releases/download"
  ${D_APPS} = "${env:SystemDrive}\Apps"
  ${D_PWSH} = "${D_APPS}\PowerShell"
  ${F_PWSH} = "PowerShell-${Version}-win-x64.${Type}"

  Write-Information -MessageData "--- Create directory: '${D_APPS}'..."
  New-Item -Path "${D_APPS}" -ItemType "Directory" -Force

  Write-Information -MessageData "--- Download PowerShell: '${F_PWSH}'..."
  Invoke-WebRequest "${URL_DL}/v${Version}/${F_PWSH}" -OutFile "${D_APPS}\${F_PWSH}"

  if ( "${Type}" -eq 'zip' ) {
    if ( Test-Path -Path "${D_PWSH}" ) { Remove-Item -Path "${D_PWSH}" -Recurse -Force }
    Write-Information -MessageData "--- Expand: '${F_PWSH}'"
    Expand-Archive -Path "${D_APPS}\${F_PWSH}" -DestinationPath "${D_PWSH}"
    Remove-Item -Path "${D_APPS}\${F_PWSH}";
  } elseif ( "${Type}" -eq 'msi' ) {
    Write-Information -MessageData "--- Install: '${F_PWSH}'"
    msiexec.exe /package "${D_APPS}\${F_PWSH}" /quiet ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1 ADD_PATH=1
  } else {
    Write-Error -Message "Package type not found!" -ErrorAction "Stop"
  }
}
