Push-Location ($PSScriptRoot | Split-Path)
# clone the iTermColorSchemes repo
git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git | Out-Host

# and get all of the JSON files from it
$jsonFiles = Get-ChildItem -Path iTerm2-Color-Schemes -Recurse -Filter *.json  |
    Where-Object Fullname -like '*terminal*' |
    Where-Object FullName -notlike '*templates*'

# Get the credits from the CREDITS.md file in the iTerm2-Color-Schemes repo
$creditLines = Get-Content -Path (Join-Path iTerm2-Color-Schemes CREDITS.md)
# and declare a small pattern to match markdown links
$markdownLinkPattern = '\[(?<text>.+?)\]\((?<link>.+?)\)'
# and a filter to get the credits from the CREDITS.md file
filter GetCredits {
    $colorSchemeName = $_
    $colorSchemePattern = [Regex]::Escape($colorSchemeName) -replace '\\ ', '\s'    
    foreach ($line in $creditLines) {
        if (-not $line ) { continue }
        if ($line -notmatch $colorSchemePattern) {
            continue            
        }
        if ($line -notmatch $markdownLinkPattern) {
            continue
        }        
        [Ordered]@{credit=$Matches.text; link=$Matches.link}
    }
}

# Import the module
Import-Module .\4bitcss.psd1 -Global

# Build the index file.
$transpiledPreview = Build-PipeScript -InputPath (
    Join-Path $pwd "docs" | 
    Join-Path -ChildPath "index.ps.markdown"
)
# (we'll slightly modify this for each preview)
$transpiledText = [IO.File]::ReadAllText($transpiledPreview.FullName)
$yamlHeader, $transpiledText = $transpiledText -split '---' -ne ''

# Also, get the preview template.
$previewSvg    = (Get-ChildItem -Path docs -Filter 4bitpreviewtemplate.svg | Get-Content -raw)

# The ./docs directory is our destination for most file.

$docsPath = Join-Path $pwd docs

$allColorSchemes    = @()
$brightColorSchemes = @()
$darkColorSchemes   = @()

$allPalletes = [Ordered]@{}

# Walk thru each json file of a color scheme
foreach ($jsonFile in $jsonFiles) {
    # convert the contents from JSON
    $jsonContent = [IO.File]::ReadAllText($jsonFile.FullName)
    $jsonObject = $jsonContent | ConvertFrom-Json
    # and determine the name of the scheme and it's files.
    $colorSchemeName = $jsonObject.Name
    $colorSchemeFileName =
        $jsonObject.Name | Convert-4BitName
        
    $jsonObject | 
        Add-Member NoteProperty credits -Force -PassThru -Value @($colorSchemeName | GetCredits)

    if (-not $colorSchemeFileName) { continue }
    $distinctColors = @($jsonObject.psobject.Properties.value) -match '^#[0-9a-fA-F]{6}' | Select-Object -Unique

    $allPalletes[$colorSchemeFileName] = $jsonObject
    # If the name wasn't there, continue.
    if (-not $jsonObject.Name) { continue }
    # If it wasn't legal, continue.
    if ($jsonObject.Name -match '^\{') { continue }
    $cssPath = (Join-Path $pwd css)
    $jsonPath = (Join-Path $pwd json)
    # Export the theme to /css (so that repo-based CDNs have a logical link)
    $jsonObject | Export-4BitCSS -OutputPath $cssPath -OutVariable colorSchemeCssFile
    $jsonObject | Export-4BitJSON -OutputPath (
        Join-Path $jsonPath "$colorSchemeFileName.json"
    ) -OutVariable colorSchemeJsonFile
    $ColorSchemePath = Join-Path $docsPath $colorSchemeFileName
    if (-not (Test-Path $ColorSchemePath)) {
        $null = New-Item -ItemType Directory -Path $ColorSchemePath
    }
    # Then export it again to /docs (so the GitHub page works)
    $jsonObject | Export-4BitCSS -OutputPath $ColorSchemePath
    $jsonObject | Export-4BitJSON -OutputPath (
        Join-Path $ColorSchemePath "$colorSchemeFileName.json"
    ) -OutVariable colorSchemeJsonFile
    $dotTextPath = Join-Path $ColorSchemePath "$colorSchemeFileName.txt"
    $distinctColors -join ';' | Set-Content -Path $dotTextPath -Encoding utf8
    Get-Item -Path $dotTextPath
    $allColorSchemes += $colorSchemeFileName

    $wasBright = $colorSchemeCssFile | Select-String "IsBright: 1"
    if ($wasBright) {
        $brightColorSchemes += $colorSchemeFileName
    }
    $wasDark   = $colorSchemeCssFile | Select-String "IsDark: 1"
    if ($wasDark) {
        $darkColorSchemes += $colorSchemeFileName
    }

    # Create a preview file.  All we need to change is the stylesheet.
    $previewFilePath = Join-Path $ColorSchemePath "$colorSchemeFileName.md"
@"
---
stylesheet: /$colorSchemeFileName/$colorSchemeFileName.css
colorSchemeName: $colorSchemeName
colorSchemeFileName: $colorSchemeFileName
image: /$colorSchemeFileName/$colorSchemeFileName.png
description: $colorSchemeName color scheme
permalink: /$colorSchemeFileName/
---
$transpiledText
"@ |
    Set-Content $previewFilePath -Encoding utf8
    # output the file so that PipeScript will check it in.
    Get-Item -Path $previewFilePath

    # Now create a preview SVG
    $previewSvgPath = Join-Path $ColorSchemePath "$colorSchemeFileName.svg"

    # by expanding the string we have in $previewSVG (this will replace $ColorSchemeName)
    $executionContext.SessionState.InvokeCommand.ExpandString($previewSvg) |
        Set-Content -Path $previewSvgPath
    
    # output the file so that PipeScript will check it in.
    Get-Item -Path $previewSvgPath    
}

$DataPath = Join-Path $docsPath "_data"
if (-not (Test-Path $DataPath)) {
    $null = New-Item -ItemType Directory -Path $DataPath
}

$allSchemesPath = Join-Path $docsPath "Palette-List.json"

$allColorSchemes |
    ConvertTo-Json -Compress |
    Set-Content -Path $allSchemesPath

Get-Item -Path $allSchemesPath
Get-Item -Path $allSchemesPath |
    Copy-Item -Destination $DataPath -Force -PassThru

$allBrightSchemesPath = Join-Path $docsPath "Bright-Palette-List.json"
$brightColorSchemes |
    ConvertTo-Json -Compress |
    Set-Content -Path $allBrightSchemesPath

Get-Item -Path $allBrightSchemesPath
Get-Item -Path $allBrightSchemesPath |
    Copy-Item -Destination $DataPath -Force -PassThru

$allDarkSchemesPath = Join-Path $docsPath "Dark-Palette-List.json"
    
$darkColorSchemes |
    ConvertTo-Json -Compress |
    Set-Content -Path $allDarkSchemesPath

Get-Item -Path $allDarkSchemesPath
Get-Item -Path $allDarkSchemesPath |
    Copy-Item -Destination $DataPath -Force -PassThru

$allPalletesPath = Join-Path $docsPath "Palletes.json"
$allPalletes |
    ConvertTo-Json -Depth 4 -Compress |
    Set-Content -Path $allPalletesPath

Get-Item -Path $allPalletesPath
Get-Item -Path $allPalletesPath  |
    Copy-Item -Destination $DataPath -Force -PassThru

$4bitJS = Export-4BitJS -ColorSchemeName $allColorSchemes -DarkColorSchemeName $darkColorSchemes -LightColorSchemeName $LightColorSchemeName

$4bitJSDocsPath = Join-Path $docsPath "js" | Join-Path -ChildPath "4bit.js"
New-Item -ItemType File -Path $4bitJSDocsPath -Force -Value $4bitJS

New-Item -ItemType File -Path ".\4bit.js" -Force -Value $4bitJS


#region Icons
$IncludesPath = Join-Path $docsPath "_includes"
if (-not (Test-Path $IncludesPath)) {
    $null = New-Item -ItemType Directory -Path $IncludesPath
}

Export-4BitSVG -SVG https://raw.githubusercontent.com/feathericons/feather/master/icons/download.svg -Stroke "ansi6" -OutputPath (Join-Path $IncludesPath "download-icon.svg")
Export-4BitSVG -SVG https://raw.githubusercontent.com/feathericons/feather/master/icons/download-cloud.svg -Stroke "ansi6" -OutputPath (Join-Path $IncludesPath "download-cloud-icon.svg")
Export-4BitSVG -SVG https://raw.githubusercontent.com/feathericons/feather/master/icons/shuffle.svg -Stroke "ansi6" -OutputPath (Join-Path $IncludesPath "shuffle-icon.svg")
Export-4BitSVG -SVG https://raw.githubusercontent.com/feathericons/feather/master/icons/help-circle.svg -Stroke "ansi6" -OutputPath (Join-Path $IncludesPath "help-circle-icon.svg")
Export-4BitSVG -SVG https://raw.githubusercontent.com/feathericons/feather/master/icons/save.svg -OutputPath (Join-Path $IncludesPath "save-icon.svg")
Export-4BitSVG -SVG https://raw.githubusercontent.com/feathericons/feather/master/icons/skip-back.svg -OutputPath (Join-Path $IncludesPath "skip-back-icon.svg")

Get-Module 4bitcss | 
    Split-Path | 
    Join-Path -ChildPath Assets | 
    Get-ChildItem -Filter 4bitpreview.svg |
    Copy-Item -Destination (Join-Path $IncludesPath "4bitpreview.svg") -Force -PassThru

$defaultColorScheme = 'Konsolas'
@"
---
stylesheet: /$defaultColorScheme/$defaultColorScheme.css
colorSchemeName: $defaultColorScheme
colorSchemeFileName: $defaultColorScheme
image: /$defaultColorScheme/$defaultColorScheme.png
description: $defaultColorScheme color scheme
permalink: /
---
$transpiledText
"@ |
    Set-Content (Join-Path $docsPath "index.md") -Encoding utf8
Get-item -Path (Join-Path $docsPath "index.md")
#endregion Icons 

if  ($env:GITHUB_WORKSPACE) {
    Remove-Item -Path iTerm2-Color-Schemes -Recurse -Force
}