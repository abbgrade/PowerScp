
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

. $PSScriptRoot\TestHelper.ps1

Describe 'Get-Fingerprint' {

    Context 'running SFTP server' {

        BeforeAll {
            $container = New-SftpServer
        }

        AfterAll {
            $container | Remove-SftpServer
        }

        It 'returns something' {
            Get-ScpFingerprint `
                -HostName $testConfig.Hostname `
                -Port $testConfig.Port `
                -UserName $testConfig.Username `
                -Password $testConfig.Password `
                -AnyFingerprint `
                -Algorithm SHA256 |
            Should -Not -BeNullOrEmpty
        }
    }
}
