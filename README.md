# PowerScp

[![Build status](https://ci.appveyor.com/api/projects/status/ieexkg9xk2c63947?svg=true)](https://ci.appveyor.com/project/abbgrade/powerscp)


## Development

```powershell
Invoke-Build ReBuild
Import-Module .\bin\Debug\netstandard2.0\PowerScp.psd1

Get-Command -Module PowerScp

Connect-ScpServer -HostName 'localhost' -UserName $ENV:USERNAME -AnyFingerprint
Connect-ScpServer -HostName 'localhost' -UserName $ENV:USERNAME -Fingerprint 'abc'

Remove-Module PowerScp

```
