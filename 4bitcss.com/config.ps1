<#
.SYNOPSIS
    Configures the site
.DESCRIPTION
    Configures the site.  
    
    At the point this runs, a $Site dictionary should exist, and it should contain a list of files to build.

    Any *.json, *.psd1, or *.yaml files in the root should have already been loaded into the $Site dictionary.

    Any additional configuration or common initialization should be done here.
#>

param()

#region Core
if ($psScriptRoot) {Push-Location $psScriptRoot}
if (-not $Site) { $Site = [Ordered]@{} }
$parentFolderManifest =
    Get-ChildItem -File -Path .. |
    Where-Object Extension -eq .psd1 |
    Select-String 'ModuleVersion\s{0,}='

if ($parentFolderManifest) {
    $ImportedParentModule = Import-Module -Name ../ -PassThru -Global
    if ($ImportedParentModule) {
        $site.Module = $ImportedParentModule
    }
}

if ($psScriptRoot -and -not $site.PSScriptRoot) {
    $site.PSScriptRoot = $PSScriptRoot
}
#endregion Core

#region _
if ($site.PSScriptRoot) {
    $underbarItems = 
        Get-ChildItem -Path $site.PSScriptRoot -Filter '_*' -Recurse

    $underbarFileQueue = [Collections.Queue]::new()

    foreach ($underbarItem in $underbarItems) {
        $relativePath = $underbarItem.FullName.Substring($site.PSScriptRoot.Length + 1)
        if ($underbarItem -is [IO.FileInfo]) {
            $underbarFileQueue.Enqueue($underbarItem)
        }
        else {
            foreach ($childItem in $underbarItem.GetFileSystemInfos()) {
                if ($childItem -is [IO.FileInfo]) {
                    $underbarFileQueue.Enqueue($childItem)
                }
            }            
        }
    }

    foreach ($underbarFile in $underbarFileQueue.ToArray()) {
        $relativePath = $underbarFile.FullName.Substring($site.PSScriptRoot.Length + 1)
        $pointer = $site
        $hierarchy = @($relativePath -split '[\\/]')
        for ($index = 0; $index -lt ($hierarchy.Length - 1); $index++) {
            $subdirectory = $hierarchy[$index] -replace '_'
            if (-not $pointer[$subdirectory]) {
                $pointer[$subdirectory] = [Ordered]@{}
            }
            $pointer = $pointer[$subdirectory]
        }
                        
        $propertyName = $hierarchy[-1] -replace '\.ps1$'
        
        $getFile = @{LiteralPath=$underbarFile.FullName}
        $fileData  =
            switch -regex ($underbarFile.Extension) {
                '\.ps1$' { $ExecutionContext.SessionState.InvokeCommand.GetCommand($underbarFile.FullName, 'ExternalScript') }
                '\.(css|html|txt)$' { Get-Content @getFile }
                '\.json$' { Get-Content @getFile | ConvertFrom-Json }
                '\.jsonl$' { Get-Content @getFile | ConvertFrom-Json }
                '\.psd1$' { Get-Content @getFile -Raw | ConvertFrom-StringData }
                '\.(?>ps1xml|xml|svg)$' { (Get-Content @getFile -Raw) -as [xml] }
                '\.(?>yaml|toml)$' { Get-Content @getFile -Raw }
                '\.csv$' { Import-Csv @getFile }
                '\.tsv$' { Import-Csv @getFile -Delimiter "`t" }
            }        
        if (-not $fileData) { continue }
        switch ($underbarFile.Extension) {
            .toml { RequireModule PSToml; $fileData = $fileData | ConvertFrom-Toml }
            .yaml { RequireModule YaYaml; $fileData = $fileData | ConvertFrom-Yaml }
        }

        if ($fileData) {
            $pointer[$propertyName] = $fileData
        }
    }
}
#region _

#region Site Metadata
$Site.Title = '4bitcss'
$Site.Description = 'Terminal Color Palettes'
#endregion Site Metadata

#region Site Icons
$Site.Icon  = [Ordered]@{
    # 'BlueSky' = $site.includes.'BlueSky.svg'.OuterXml
    'GitHub' = . $site.includes.Feather 'GitHub'
    'RSS' = . $site.includes.Feather 'RSS'
    'Settings' = . $site.includes.Feather 'Settings'
    'Help' = . $site.includes.Feather 'Help-Circle'
}
#endregion Site Icons

#region Site Menus
$Site.Logo = Get-Content -Path ../Assets/4bitcss.svg
    

# $site.Logo = . ($site.Logo | Get-Random)


<# $Site.Logo = $Site.Logo | Set-Turtle PathAnimation @{
    type = 'rotate'   ; values = 0, 360 ;repeatCount = 'indefinite'; dur = "31s"; additive = 'sum'; id ='rotate-logo'
} #>

$Site.NoIndex = $true

$site.Taskbar = [Ordered]@{
    # 'BlueSky' = 'https://bsky.app/profile/psturtle.com'
    'GitHub' = 'https://github.com/2bitdesigns/4bitcss'
    'RSS' = 'https://psturtle.com/RSS/index.rss'
    <#'Help' = @(

    ) -join [Environment]::NewLine#>
    'Settings' = @(
        . $site.includes.SelectPalette -PaletteCDN "/css/"
        . $site.includes.GetRandomPalette
    )
}

<#$site.HeaderMenu = [Ordered]@{

}#>
#endregion Site Menus

#region Highlight Settings
$site.HighlightJS = [Ordered]@{Languages=@('powershell')}
#endregion Highlight Settings

#region Google Analytics
$site.AnalyticsID = 'G-27ME7M0HYR' # replace with your Google Analytics ID
#endregion Google Analytics

if ($PSScriptRoot) { Pop-Location }