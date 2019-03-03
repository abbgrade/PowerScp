task ReBuild Clean, Build

task Build bin

task bin lib, {
    dotnet build
    Copy-Item .\Source\PowerScp.psd1                                            -Destination bin/Debug/netstandard2.0/
    Copy-Item .\lib\winscp\*\lib\netstandard*\WinSCPnet.dll                     -Destination bin/Debug/netstandard2.0/
    Copy-Item .\lib\newtonsoft.json\*\lib\netstandard2.0\Newtonsoft.Json.dll    -Destination bin/Debug/netstandard2.0/
}

task lib {
    dotnet restore --packages .\lib

    Get-ChildItem -Path .\lib -Recurse | Write-Verbose -Verbose
}

task Clean {
    Remove-Item .\bin -Recurse -Force -ErrorAction SilentlyContinue -Verbose
    Remove-Item .\doc -Recurse -Force -ErrorAction SilentlyContinue -Verbose
    Remove-Item .\obj -Recurse -Force -ErrorAction SilentlyContinue -Verbose
    Remove-Item .\lib -Recurse -Force -ErrorAction SilentlyContinue -Verbose
}

task Test {
    Invoke-Pester .\Test
}

task Docs {
	Import-Module .\bin\Debug\netstandard2.0\PowerScp.psd1 -Force
	New-MarkdownHelp -Module PowerScp -OutputFolder .\doc -Force
}
