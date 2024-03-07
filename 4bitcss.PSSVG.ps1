#requires -Module PSSVG
Push-Location $PSScriptRoot


$assetsRoot = Join-Path $PSScriptRoot "Assets"
if (-not (Test-Path $assetsRoot)) {
    $null = New-Item -ItemType Directory -Path $assetsRoot
}

$docsRoot = Join-Path $PSScriptRoot "docs"
if (-not (Test-Path $docsRoot)) {
    $null = New-Item -ItemType Directory -Path $docsRoot
}

$includesRoot = Join-Path $docsRoot "_includes"
if (-not (Test-Path $includesRoot)) {
    $null = New-Item -ItemType Directory -Path $includesRoot
}

$fontSettings = [Ordered]@{
    TextAnchor        = 'middle'
    AlignmentBaseline = 'middle'
    Style             = "font-family: 'Abel';"        
}

$assetFile = 
=<svg> -ViewBox 400,400 @(
    =<svg.defs> @(
        SVG.GoogleFont -FontName Abel
    )
        
    =<svg.ellipse> -StrokeWidth 1.25 -Fill transparent -Cx 50% -Cy 50% -Stroke '#4488ff' -Ry 75 -Rx 50 -Class foreground-stroke
    =<svg.text> -FontSize 28 -Content 4bit -X 50% -Y 45% @fontSettings -Class foreground-fill -Fill '#4488ff'
    $xPercent = 47.5,48.75,51.25,52.55
    foreach ($n in 0..3) {
        $x = $xPercent[$n]
        =<svg.circle> -Class "ansi$($n+1)-fill" -Fill '#4488ff' -Cx "$x%" -Cy 50% -R 0.5%
    }    
    =<svg.text> -FontSize 28 -Content 'css' -X 50% -Y 55% @fontSettings -Class foreground-fill -Fill '#4488ff'
) -OutputPath (Join-Path $assetsRoot .\4bitcss.svg)

$assetFile
$assetFile | Copy-Item -Destination (Join-Path $docsRoot .\4bitcss.svg) -PassThru

=<svg> -ViewBox 640, 640 @(
    foreach ($n in 16..1) {
        =<svg.rect> -X (
            ((16 - $n - 1 ) * 20)
        ) -Y (
            ((16 - $n - 1 ) * 20)            
        ) -Class "ansi$($n - 1)-fill" -Width (
            640 - ((16 - $n - 1 ) * 40)
        ) -Height (
            640 - ((16 - $n - 1 ) * 40)
        )
    }    
) -OutputPath (Join-Path $docsRoot .\4bitpreview.svg) -Width 320 

$boxSize = [Ordered]@{Width = 80; Height = 80}
svg -ViewBox 640, 160 @(
    foreach ($n in 0..7) {
        svg.rect -X ($boxSize.Width * $n) -Y 0 -Class "ansi$n-fill" @boxSize
    }
    foreach ($n in 8..15) {
        svg.rect -X ($boxSize.Width * ($n - 8)) -Y 79 -Class "ansi$n-fill" @boxSize
    }
) -OutputPath (Join-Path $docsRoot .\4bitpreview.svg) -Width 320

Copy-Item -Path (Join-Path $docsRoot .\4bitpreview.svg) -Destination (Join-Path $assetsRoot .\4bitpreview.svg) -Force -PassThru
Copy-Item -Path (Join-Path $docsRoot .\4bitpreview.svg) -Destination (Join-Path $includesRoot .\4bitpreview.svg) -Force -PassThru

$colors = 'Black', 'Red', 'Green', 'Yellow', 'Blue', 'Purple', 'Cyan', 'White',
    'BrightBlack', 'BrightRed', 'BrightGreen', 'BrightYellow', 'BrightBlue', 'BrightPurple', 'BrightCyan', 'BrightWhite'

svg -ViewBox 640, 240 @(
    svg.defs @(
        svg.style -Type 'text/css' @'
@import url('/$ColorSchemeFileName/$ColorSchemeFileName.css')
'@
        svg.style -Type 'text/css' @'
@import url('https://fonts.googleapis.com/css?family=Abel')
'@    
    )
    svg.rect -Width 640 -Height 80 -X 0 -Y 0 -Class 'background-fill'
    svg.text -X 50% -Y 16.5% -Class 'foreground-fill' -Content @(
        '$ColorSchemeName'
    ) @fontSettings 
    foreach ($n in 0..7) {
        svg.rect -X ($boxSize.Width * $n) -Y 79 -Class "ansi$n-fill" @boxSize -Fill $($colors[$n])
    }
    foreach ($n in 8..15) {
        svg.rect -X ($boxSize.Width * ($n - 8)) -Y 159 -Class "ansi$n-fill" @boxSize -Fill $($colors[$n])
    }
) -OutputPath (Join-Path $docsRoot .\4bitpreviewtemplate.svg) -Class background-fill

Copy-Item -Path (Join-Path $docsRoot .\4bitpreviewtemplate.svg) -Destination (Join-Path $assetsRoot ..\4bitpreviewtemplate.svg) -Force -PassThru
Copy-Item -Path (Join-Path $docsRoot .\4bitpreviewtemplate.svg) -Destination (Join-Path $includesRoot .\4bitpreviewtemplate.svg) -Force -PassThru

Pop-Location
