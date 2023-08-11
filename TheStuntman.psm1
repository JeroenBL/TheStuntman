$InformationPreference = 'Continue'

function Get-LatestGitHubRelease {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $Owner,

        [Parameter(Mandatory)]
        [string]
        $Repository
    )   

    try {
        $url = "https://api.github.com/repos/$Owner/$Repository/releases/latest"
        $response = Invoke-RestMethod -Uri $url
    
        Write-Output @{
            LatestTagName    = $response.tag_name
            LatestReleaseUrl = $response.html_url
        }
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

function Get-ModuleVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $ModulePath
    )

    $psd1Content = Get-Content -Path $ModulePath -Raw

    $moduleVersion = $psd1Content -match 'ModuleVersion\s*=\s*''(.*?)''' | Out-Null
    $moduleVersion = $matches[1]
    Write-Output $moduleVersion
}

if ($MyInvocation.line -match '-verbose'){
    $VerbosePreference = 'Continue'
}

try {
    $moduleVersion = Get-ModuleVersion -ModulePath (Join-Path $PSScriptRoot 'TheStuntman.psd1')
    $latestVersion = (Get-LatestGitHubRelease -Owner JeroenBL -Repository TheStuntman)
    if ($($latestVersion.LatestTagName.Trim('v')) -gt $moduleVersion){
        Write-Information "Version: $($latestVersion.LatestTagName.Trim('v')) is available!"
        Write-Information "Download from: $($latestVersion.LatestReleaseUrl)"
    }
} catch {
    throw
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
    throw
}