if ($MyInvocation.line -match '-verbose'){
    $VerbosePreference = 'Continue'
}

try {
    Write-Verbose 'loading [Bogus] assembly'
    Add-Type -AssemblyName (Join-Path $PSScriptRoot "libs/netstandard2.0/bogus.dll")
} catch {
    throw
}

try {
    Write-Verbose 'Loading external functions'
    $public = @(Get-ChildItem -Recurse -Path $PSScriptRoot\public\*.ps1 -ErrorAction Stop)
    foreach($psFile in @($public)) {
        . $psFile.FullName
    }
} catch {
    throw $_
}
