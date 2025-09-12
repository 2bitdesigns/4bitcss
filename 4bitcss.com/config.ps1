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



#region Custom
$site.FilesProcessed = $filesProcessed = [Ordered]@{}
$cssOutputRoot  = Join-Path $PSScriptRoot css
if (-not (Test-Path $cssOutputRoot)) {
    $null = New-Item -ItemType Directory -Path $cssOutputRoot
}

$allPalettes = ./Palettes.json.ps1
if (-not $site) {
    $site = [Ordered]@{}
}
$site.Palettes = $allPalettes


Import-Module ../4bitcss.psd1 -Global

$allFiles = @()

$allFiles += foreach ($paletteKeyValue in $allPalettes.GetEnumerator()) {
    $paletteName = $paletteKeyValue.Key
    $paletteObject = $paletteKeyValue.Value
    $paletteObject | Export-4BitCSS -OutputPath $cssOutputRoot    
}

$colorOrder = 
    'Black','Red','Green','Yellow','Blue','Purple','Cyan','White',
    'BrightBlack','BrightRed','BrightGreen','BrightYellow','BrightBlue','BrightPurple','BrightCyan','BrightWhite'


$previewRectangleWidth = 640
$previewRectangleHeight = 240

filter PalettePreviewRectangle {
    $palette = $_
    $columnWidth = $previewRectangleWidth / ($colorOrder.Count / 2)
    $rowHeight = $previewRectangleHeight / 3
    $paletteRects = @(for ($index = 0; $index -lt $colorOrder.Count; $index++) {
        $row = [Math]::Floor($index / ($colorOrder.Count / 2))
        $column = $index % ($colorOrder.Count / 2)
        $colorValue = $palette.($colorOrder[$index])
        "<rect x='$($column * $columnWidth)' y='$($row * $rowHeight)' width='$($columnWidth)' height='$($rowHeight)' fill='$($colorValue)' class='$($colorOrder[$index])-fill' />"
    }) -join [Environment]::NewLine
    @("<svg viewBox='0 0 $previewRectangleWidth $previewRectangleHeight' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns='http://www.w3.org/2000/svg'>"
        "<defs>"        
        "</defs>"
        "<rect width='$previewRectangleWidth' height='$previewRectangleHeight' x='0' y='0' fill='$($palette.background)' />"
        "<text height='33%' x='50%' y='$(5 * 100/6)%' fill='$($palette.foreground)' text-anchor='middle' alignment-baseline='middle'>$([Security.Securityelement]::Escape($palette.Name))</text>"
        $paletteRects
    "</svg>") -join '' -as [xml] 
}


filter paletteToAnsi {
    $palette = $_    
    $colorList = @(foreach ($color in $colorOrder) {
        $hexColor = $palette.$color
        $hexString = $hexColor -replace '[#;]' 
        @(for ($hexIndex = 0; $hexIndex -lt 6; $hexIndex+=2) {
            $hexString[$hexIndex..($hexIndex + 1)] -join ''
        }) -join '/'
    })

    $e = [char]27
    $i = 0
    @(
        foreach ($color in $colorList) {
            "$e]4;$i;rgb:$color$e\"
            $i++
        }
        $hexColor = $palette.foreground -replace ';'
        $rgb   = ($hexColor -replace '#', '0x') -as [int]

        $r = [byte](($rgb -band 0xff0000) -shr 16)
        $g = [byte](($rgb -band 0x00ff00) -shr 8)
        $b = [byte]($rgb -band 0x0000ff)
        "$e[38;2;$r;$g;${b}m"
        $hexColor = $palette.background -replace ';'
        $rgb   = ($hexColor -replace '#', '0x') -as [int]

        $r = [byte](($rgb -band 0xff0000) -shr 16)
        $g = [byte](($rgb -band 0x00ff00) -shr 8)
        $b = [byte]($rgb -band 0x0000ff)
        "$e[48;2;$r;$g;${b}m"
    ) -join ''
}

$allFiles += foreach ($paletteKeyValue in $allPalettes.GetEnumerator()) {
    $paletteName = $paletteKeyValue.Key
    $paletteObject = $paletteKeyValue.Value
    $paletteRoot = Join-Path $PSScriptRoot $paletteName
    if (-not (Test-Path $paletteRoot)) {
        $null = New-Item -ItemType Directory -Path $paletteRoot
    }
    $paletteObject | Export-4BitCSS -OutputPath $paletteRoot
    $paletteJsonPath = Join-Path $paletteRoot "$paletteName.json"
    $paletteObject | 
        ConvertTo-Json -Depth 4 | 
        Set-Content -LiteralPath $paletteJsonPath
    Get-Item -LiteralPath $paletteJsonPath
    
    $paletteTextPath = Join-Path $paletteRoot "$paletteName.txt"

    $distinctColors = @($paletteObject.psobject.Properties.value) -match '^#[0-9a-fA-F]{6}' | Select-Object -Unique    
    $distinctColors -join ';' | Set-Content -Path $paletteTextPath -Encoding utf8

    Get-Item -LiteralPath $paletteTextPath

    $ansiTextPath = Join-Path $paletteRoot "$paletteName.ansi.txt"
    $paletteObject | paletteToAnsi | Set-Content $ansiTextPath
    Get-Item -LiteralPath $ansiTextPath
    

    $palettePreviewSVG = $paletteObject | PalettePreviewRectangle
    $palettePreviewPath = Join-Path $paletteRoot "$paletteName.svg"
    $palettePreviewSVG.Save("$palettePreviewPath")
    Get-Item -LiteralPath $palettePreviewPath

    $indexHtmlPs1 = ". `$site.views.palette '$($paletteName -replace "'","''")'"
    
    $paletteIndexHtmlPs1 = Join-Path $paletteRoot "$paletteName.html.ps1"
    $indexHtmlPs1 > $paletteIndexHtmlPs1
    Get-Item -LiteralPath $paletteIndexHtmlPs1
}

$site.Palettes = $allPalettes
if ($page -isnot [Collections.IDictionary]) {
    $page = [Ordered]@{}
}

if ($site.FilesProcessed) { 
    foreach ($file in $allFiles) {
        $site.FilesProcessed[$file.FullName] = $true
    }
}

$htmlPs1Files = $allFiles -match '\.html\.ps1$'

$layout = Get-Command ./layout.ps1

$htmlFiles = foreach ($htmlPs1 in $htmlPs1Files) {
    $paletteName = $htmlPs1.Directory.Name
    $layoutSplat = [Ordered]@{}
    if ($layout.Parameters['Title']) {
        $layoutSplat['Title'] = $paletteName
    }
    if ($layout.Parameters['Description']) {
        $layoutSplat['Description'] = 
            "$($htmlPs1.Directory.Name) color palette.  $(
                if ($allPalettes[$paletteName].credits) {
                    $allPalettes[$paletteName].credits
                }
            )"
    }    
    $outputFile = $htmlPs1.FullName -replace "$(
        [Regex]::Escape($paletteName)
    )\.html\.ps1$",'index.html'
    $output = . $htmlPs1.FullName | . $layout @layoutSplat
    $output > $outputFile
    Get-Item -LiteralPath $outputFile    
}

if ($site.FilesProcessed) {
    foreach ($htmlFile in $htmlFiles) {
        $site.FilesProcessed[$htmlFile.FullName] = $true
    }
}
#endregion Custom

if ($PSScriptRoot) { Pop-Location }
