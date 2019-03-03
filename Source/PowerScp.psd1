@{
    ModuleVersion = '0.0.0.0'
    Author = 'Steffen Kampmann'
    RootModule = 'PowerScp.dll'

    CmdletsToExport = 'Connect-Server', 'Disconnect-Server', 'Get-Fingerprint', 'Copy-Item'

    DefaultCommandPrefix = 'Scp'
}
