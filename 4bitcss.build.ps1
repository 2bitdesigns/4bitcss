
# If running in a github workflow
if ($env:GITHUB_WORKSPACE) {
    # clone the iTermColorSchemes repo
    git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git | Out-Host

    # and get all of the JSON files from it
    $jsonFiles = Get-ChildItem -Path iTerm2-Color-Schemes -Recurse -Filter *.json  |
        Where-Object Fullname -like '*terminal*' | 
        Select-Object -Skip 2    
} else {
    # Otherwise get them locally
    $jsonFiles = Get-ChildItem $home\documents\git\iTerm2-Color-Schemes -Recurse -Filter *.json  |
        Where-Object Fullname -like '*terminal*' | 
        Select-Object -Skip 2
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

# Walk thru each json file of a color scheme
foreach ($jsonFile in $jsonFiles) {
    # convert the contents from JSON
    $jsonObject = [IO.File]::ReadAllText($jsonFile.FullName) | ConvertFrom-Json
    # and determine the name of the scheme and it's files.
    $colorSchemeName = $jsonObject.Name
    $colorSchemeFileName = $jsonObject.Name -replace '\s'
    # If the name wasn't there, continue.
    if (-not $jsonObject.Name) { continue }
    # If it wasn't legal, continue.
    if ($jsonObject.Name -match '^\{') { continue }
    # Export the theme to /css (so that repo-based CDNs have a logical link)
    $jsonObject | Export-4BitCSS -OutputPath (Join-Path $PSScriptRoot css)
    # Then export it again to /docs (so the GitHub page works)
    $jsonObject | Export-4BitCSS -OutputPath $docsPath

    # Create a preview file.  All we need to change is the stylesheet.
    $previewFilePath = Join-Path $docsPath "$colorSchemeFileName.md"
@"
---
stylesheet: $colorSchemeFileName.css
image: $colorSchemeFileName.png
---
$transpiledText
"@ |
    Set-Content $previewFilePath -Encoding utf8
    # output the file so that PipeScript will check it in.
    Get-Item -Path $previewFilePath

    # Now create a preview SVG
    $previewSvgPath = Join-Path $docsPath "$colorSchemeFileName.svg"

    # by expanding the string we have in $previewSVG (this will replace $ColorSchemeName)
    $executionContext.SessionState.InvokeCommand.ExpandString($previewSvg) |
        Set-Content -Path $previewSvgPath
    
    # output the file so that PipeScript will check it in.
    Get-Item -Path $previewSvgPath
}