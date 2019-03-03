
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

. $PSScriptRoot\TestHelper.ps1

Describe 'Connect-Server' {

    It 'fails on invalid host' {
        {
            Connect-ScpServer -HostName 'invalidhostname'
        } | Should -Throw
    }

    Context 'running SFTP server' {

        BeforeAll {
            $container = New-SftpServer
        }

        AfterAll {
            $container | Remove-SftpServer
        }

        It 'connects with any fingerprint' {
            $session = Connect-ScpServer `
                -HostName $testConfig.Hostname `
                -Port $testConfig.Port `
                -UserName $testConfig.Username `
                -Password $testConfig.Password `
                -AnyFingerprint

            $session.Opened | Should -Be $true
        }

        It 'connects with correct fingerprint' {
            $fingerprint = Get-ScpFingerprint `
                -HostName $testConfig.Hostname `
                -Port $testConfig.Port `
                -UserName $testConfig.Username `
                -Password $testConfig.Password `
                -AnyFingerprint `
                -Algorithm SHA256

            $session = Connect-ScpServer `
                -HostName $testConfig.Hostname `
                -Port $testConfig.Port `
                -UserName $testConfig.Username `
                -Password $testConfig.Password `
                -Fingerprint $fingerprint

            $session.Opened | Should -Be $true
        }

        It 'fails with wrong fingerprint' {
            {
                Connect-ScpServer `
                    -HostName $testConfig.Hostname `
                    -UserName $testConfig.Username `
                    -Password $testConfig.Password `
                    -Fingerprint 'nonsense'
            } | Should -Throw
        }
    }
}
