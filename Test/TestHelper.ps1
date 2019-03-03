#Requires -Modules Pester, @{ ModuleName="PSDocker"; ModuleVersion="1.4.0" }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } ),
    [string] $ModuleManifestPath = "$PSScriptRoot\..\bin\Debug\netstandard2.0\PowerScp.psd1"
)

Import-Module $ModuleManifestPath

$testConfig = New-Object PsObject -Property @{
    Hostname = 'localhost'
    Username = 'foo'
    PlainPassword = 'pass'
    Password = ConvertTo-SecureString 'pass' -AsPlainText -Force
    Port = 2222
}

function New-SftpServer {

    [CmdletBinding()]
    param (
        $VolumePath = "$( $TestDrive.FullName )\upload"
    )

    if ( -not ( Test-Path $VolumePath ) ) {
        New-Item -Type Container -Path $VolumePath | Out-Null
    }

    $container = Install-DockerImage -Repository 'atmoz/sftp' |
    New-DockerContainer `
        -Ports @{ $testConfig.Port = 22 } `
        -Environment @{ SFTP_USERS = "$( $testConfig.Username ):$( $testConfig.PlainPassword ):::upload" } `
        -Volumes @{ $VolumePath = "/home/$( $testConfig.Username )/upload" } `
        -Detach
    $container | Add-Member VolumePath $VolumePath | Out-Null
    $container | Write-Output

    Start-Sleep -Seconds 1 | Out-Null

}

function Remove-SftpServer {

    [CmdletBinding()]
    param (
        [Parameter( ValueFromPipeline = $true )]
        $Container
    )

    Remove-DockerContainer -Name $Container.Name -Force

}
