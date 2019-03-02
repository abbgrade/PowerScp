
param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

. $PSScriptRoot\TestHelper.ps1

Describe 'ModuleManifest' {
    It 'manifest is valid' {
        Test-ModuleManifest -Path $ModuleManifestPath |
        Should -Not -BeNullOrEmpty
        $? | Should -Be $true
    }
}
