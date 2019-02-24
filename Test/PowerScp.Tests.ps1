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

    It 'works with any fingerprint' {
        $session = Connect-ScpServer -HostName $hostname -UserName $username -Password $password -AnyFingerprint
        $session.Opened | Should -Be $true
    }

    It 'works with correct fingerprint' {
        $fingerprint = Get-ScpFingerprint -HostName $hostname -UserName $username -Password $password -AnyFingerprint -Algorithm SHA256
        $session = Connect-ScpServer -HostName $hostname -UserName $username -Password $password -Fingerprint $fingerprint
        $session.Opened | Should -Be $true
    }

    It 'fails with wrong fingerprint' {
        {
            Connect-ScpServer -HostName $hostname -UserName $username -Password $password -Fingerprint 'nonsense'
        } | Should -Throw
    }
}

Describe 'Disconnect-Server' {
    $session = Connect-ScpServer -HostName $hostname -UserName $username -Password $password -AnyFingerprint

    It 'does not throw' {
        $session | Disconnect-ScpServer
        $session.Opened | Should -Be $false
    }
}

$serverContainer | Remove-DockerContainer -Force
