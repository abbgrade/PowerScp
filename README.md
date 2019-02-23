# PowerScp

## Development

```powershell
Invoke-Build ReBuild
Import-Module .\bin\Debug\netstandard2.0\PowerScp.psd1

Get-Command -Module PowerScp

Connect-ScpServer -HostName 'localhost' -UserName $ENV:USERNAME -AnyFingerprint
Connect-ScpServer -HostName 'localhost' -UserName $ENV:USERNAME -Fingerprint 'abc'

Remove-Module PowerScp

```
