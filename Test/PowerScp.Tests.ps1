#Requires -Modules Pester, @{ ModuleName="PSDocker"; ModuleVersion="1.2.0" }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } ),
    [string] $ModuleManifestPath = "$PSScriptRoot\..\bin\Debug\netstandard2.0\PowerScp.psd1"
)

Describe 'ModuleManifest' {
    It 'is valid' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should -Not -BeNullOrEmpty
        $? | Should -Be $true
    }
}


Import-Module $ModuleManifestPath
$image = Install-DockerImage -Repository 'atmoz/sftp'
$serverContainer = $image | New-DockerContainer `
    -Ports @{ 22 = 22 } `
    -Environment @{ SFTP_USERS = 'foo:pass:::upload' } `
    -Detach

Describe 'Connect-Server' {
    It 'fails on invalid host' {
        {
            Connect-ScpServer -HostName 'invalidhostname'
        } | Should -Throw
    }

    It 'returns session' {
        $password = ConvertTo-SecureString 'pass' -AsPlainText -Force
        Connect-ScpServer -HostName 'localhost' -UserName 'foo' -Password $password -AnyFingerprint
    }
}

$serverContainer | Remove-DockerContainer -Force
