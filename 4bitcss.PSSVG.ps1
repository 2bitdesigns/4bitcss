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

$assetFile = 

=<svg> -ViewBox 400,400 @(
    =<svg.defs> @(
        =<svg.style> -Type 'text/css' @'
@import url('https://fonts.googleapis.com/css?family=Abel')
'@
            
    )

    $fontSettings = [Ordered]@{
        TextAnchor        = 'middle'
        AlignmentBaseline = 'middle'
        Style             = "font-family: 'Abel';"        
    }
    =<svg.ellipse> -StrokeWidth 1.25 -Fill transparent -Cx 50% -Cy 50% -Stroke '#4488ff' -Ry 75 -Rx 50 -Class foreground-stroke
    =<svg.text> -FontSize 28 -Content 4bit -X 50% -Y 45% @fontSettings -Class foreground-fill -Fill '#4488ff'
    =<svg.text> -FontSize 28 -Content '⋅⋅⋅⋅'  -X 50% -Y 50% @fontSettings -Class foreground-fill -Fill '#4488ff'
    =<svg.text> -FontSize 28 -Content 'css' -X 50% -Y 55% @fontSettings -Class foreground-fill -Fill '#4488ff'
) -OutputPath (Join-Path $assetsRoot .\4bitcss.svg)



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
=<svg> -ViewBox 640, 160 @(
    foreach ($n in 0..7) {
        =<svg.rect> -X ($boxSize.Width * $n) -Y 0 -Class "ansi$n-fill" @boxSize
    }
    foreach ($n in 8..15) {
        =<svg.rect> -X ($boxSize.Width * ($n - 8)) -Y 80 -Class "ansi$n-fill" @boxSize
    }
) -OutputPath (Join-Path $docsRoot .\4bitpreview.svg) -Width 320

$assetFile
$assetFile | Copy-Item -Destination (Join-Path $docsRoot .\4bitcss.svg) -PassThru

Pop-Location