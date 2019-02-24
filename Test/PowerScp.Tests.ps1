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

$hostname = 'localhost'
$username = 'foo'
$plainPassword = 'pass'
$password = ConvertTo-SecureString $plainPassword -AsPlainText -Force

$image = Install-DockerImage -Repository 'atmoz/sftp'
$serverContainer = $image | New-DockerContainer `
    -Ports @{ 22 = 22 } `
    -Environment @{ SFTP_USERS = "$( $username ):$plainPassword:::upload" } `
    -Detach

Describe 'Get-Fingerprint' {
    It 'returns something' {
        Get-ScpFingerprint -HostName $hostname -UserName $username -Password $password -AnyFingerprint -Algorithm SHA256 |
        Should -Not -BeNullOrEmpty
    }
}

Describe 'Connect-Server' {
    It 'fails on invalid host' {
        {
            Connect-ScpServer -HostName 'invalidhostname'
        } | Should -Throw
    }

    It 'returns session' {
        Connect-ScpServer -HostName $hostname -UserName $username -Password $password -AnyFingerprint |
        Should -Not -BeNullOrEmpty
    }
}
$serverContainer | Remove-DockerContainer -Force
