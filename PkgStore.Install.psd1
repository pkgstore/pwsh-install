@{
  RootModule = 'PkgStore.Install.psm1'
  ModuleVersion = '1.0.0'
  GUID = '78d6af89-e15c-4f0d-834e-05df4f51fa97'
  Author = 'Kitsune Solar'
  CompanyName = 'v77 Development'
  Copyright = '(c) 2023 v77 Development. All rights reserved.'
  Description = 'PowerShell module for installing PowerShell from GitHub.'
  PowerShellVersion = '7.1'
  RequiredModules = @('PkgStore.Kernel')
  FunctionsToExport = @('Install-PowerShell')
  PrivateData = @{
    PSData = @{
      Tags = @('pwsh', 'install')
      LicenseUri = 'https://github.com/pkgstore/pwsh-install/blob/main/LICENSE'
      ProjectUri = 'https://github.com/pkgstore/pwsh-install'
    }
  }
}
