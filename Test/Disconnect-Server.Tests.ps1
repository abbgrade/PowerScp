
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

. $PSScriptRoot\TestHelper.ps1

Describe 'Disconnect-Server' {

    Context 'running SFTP server with open session' {

        BeforeAll {
            $container = New-SftpServer
            $session = Connect-ScpServer `
                -HostName $testConfig.Hostname `
                -Port $testConfig.Port `
                -UserName $testConfig.Username `
                -Password $testConfig.Password `
                -AnyFingerprint
        }

        AfterAll {
            $container | Remove-SftpServer
        }

        It 'closes the session' {
            $session | Disconnect-ScpServer
            $session.Opened | Should -Be $false
        }
    }
}
