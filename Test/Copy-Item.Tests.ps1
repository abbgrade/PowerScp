
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

. $PSScriptRoot\TestHelper.ps1

Describe 'Copy-Item' {

    Context 'running SFTP server with test file and open session' {

        BeforeAll {
            $container = New-SftpServer

            # create local test file
            $testPath = "$( $TestDrive.FullName )\upload-test.txt"
            Set-Content $testPath -value "my test text."

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

        It 'copies the file to the server' {

            Copy-ScpItem `
                -Path $testPath `
                -Destination '/upload/test.txt' `
                -Session $session

            "$( $container.VolumePath )\test.txt" | Should -Exist
        }
    }
}
