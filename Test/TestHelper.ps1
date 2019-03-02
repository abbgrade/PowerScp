#Requires -Modules Pester, @{ ModuleName="PSDocker"; ModuleVersion="1.3.0" }

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
}

function New-SftpServer {

    [CmdletBinding()]
    param ()

    Install-DockerImage -Repository 'atmoz/sftp' |
    New-DockerContainer `
        -Ports @{ 22 = 22 } `
        -Environment @{ SFTP_USERS = "$( $testConfig.Username ):$( $testConfig.PlainPassword ):::upload" } `
        -Volumes @{ ( Get-Item $ENV:TEMP ).FullName = "/home/$( $testConfig.Username )/upload" } `
        -Detach |
    Write-Output

    Start-Sleep -Seconds 1

}

function Remove-SftpServer {

    [CmdletBinding()]
    param (
        [Parameter( ValueFromPipeline = $true )]
        $Container
    )

    Remove-DockerContainer -Name $Container.Name -Force

}