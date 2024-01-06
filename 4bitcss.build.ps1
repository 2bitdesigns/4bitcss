
# If running in a github workflow
if ($env:GITHUB_WORKSPACE) {
    # clone the iTermColorSchemes repo
    git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git | Out-Host

    # and get all of the JSON files from it
    $jsonFiles = Get-ChildItem -Path iTerm2-Color-Schemes -Recurse -Filter *.json  |
        Where-Object Fullname -like '*terminal*' |
        Where-Object FullName -notlike '*templates*'
} else {
    # Otherwise get them locally
    $jsonFiles = Get-ChildItem $home\documents\git\iTerm2-Color-Schemes -Recurse -Filter *.json  |
        Where-Object Fullname -like '*terminal*' |
        Where-Object FullName -notlike '*templates*'         
}


# Import the module
Import-Module .\4bitcss.psd1 -Global

# Build the index file.
$transpiledPreview = Build-PipeScript -InputPath .\docs\index.ps.markdown
# (we'll slightly modify this for each preview)
$transpiledText = [IO.File]::ReadAllText($transpiledPreview.FullName)

# Also, get the preview template.
$previewSvg    = (Get-ChildItem -Path docs -Filter 4bitpreviewtemplate.svg | Get-Content -raw)

# The ./docs directory is our destination for most file.

$docsPath = Join-Path $PSScriptRoot docs

$allColorSchemes    = @()
$brightColorSchemes = @()
$darkColorSchemes   = @()

# Walk thru each json file of a color scheme
foreach ($jsonFile in $jsonFiles) {
    # convert the contents from JSON
    $jsonObject = [IO.File]::ReadAllText($jsonFile.FullName) | ConvertFrom-Json
    # and determine the name of the scheme and it's files.
    $colorSchemeName = $jsonObject.Name
    $colorSchemeFileName =
        $jsonObject.Name -replace '\s','_' -replace '\p{P}','-' -replace '-+','-' -replace '-$'
    # If the name wasn't there, continue.
    if (-not $jsonObject.Name) { continue }
    # If it wasn't legal, continue.
    if ($jsonObject.Name -match '^\{') { continue }
    $cssPath = (Join-Path $PSScriptRoot css)
    # Export the theme to /css (so that repo-based CDNs have a logical link)
    $jsonObject | Export-4BitCSS -OutputPath $cssPath -OutVariable colorSchemeCssFile
    
    $ColorSchemePath = Join-Path $docsPath $colorSchemeFileName
    if (-not (Test-Path $ColorSchemePath)) {
        $null = New-Item -ItemType Directory -Path $ColorSchemePath
    }
    # Then export it again to /docs (so the GitHub page works)
    $jsonObject | Export-4BitCSS -OutputPath $ColorSchemePath
    
    $allColorSchemes += $colorSchemeName

    $wasBright = $colorSchemeCssFile | Select-String "IsBright: 1"
    if ($wasBright) {
        $brightColorSchemes += $colorSchemeName
    }
    $wasDark   = $colorSchemeCssFile | Select-String "IsDark: 1"
    if ($wasDark) {
        $darkColorSchemes += $colorSchemeName
    }

    # Create a preview file.  All we need to change is the stylesheet.
    $previewFilePath = Join-Path $ColorSchemePath "$colorSchemeFileName.md"
@"
---
stylesheet: $colorSchemeFileName.css
colorSchemeName: $colorSchemeName
colorSchemeFileName: $colorSchemeFileName
image: $colorSchemeFileName.png
description: $colorSchemeName color scheme
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

$allSchemesPath = Join-Path $docsPath "allColorSchemes.json"
$allColorSchemes |
    ConvertTo-Json |
    Set-Content -Path $allSchemesPath

Get-Item -Path $allSchemesPath

$allBrightSchemesPath = Join-Path $docsPath "allBrightColorSchemes.json"
$brightColorSchemes |
    ConvertTo-Json |
    Set-Content -Path $allBrightSchemesPath

Get-Item -Path $allBrightSchemesPath

$allDarkSchemesPath = Join-Path $docsPath "allDarkColorSchemes.json"
$darkColorSchemes |
    ConvertTo-Json |
    Set-Content -Path $allDarkSchemesPath

Get-Item -Path $allSchemesPath