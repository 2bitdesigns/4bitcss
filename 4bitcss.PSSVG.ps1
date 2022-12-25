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

    $fontSettings = @{
        TextAnchor        = 'middle'
        AlignmentBaseline = 'middle'
        Style             = "font-family: 'Abel';"        
    }
    =<svg.ellipse> -StrokeWidth 1.25 -Fill transparent -Cx 50% -Cy 50% -Stroke '#4488ff' -Ry 75 -Rx 50 -Class foreground-stroke
    =<svg.text> -FontSize 28 -Content 4bit -X 50% -Y 50% @fontSettings -Class foreground-fill -Fill '#4488ff'
    =<svg.text> -FontSize 28 -Content '⋅⋅⋅⋅'  -X 50% -Y 53% @fontSettings -Class foreground-fill -Fill '#4488ff'
    =<svg.text> -FontSize 24 -Content 'css' -X 50% -Y 55% @fontSettings -Class foreground-fill -Fill '#4488ff'
) -OutputPath (Join-Path $assetsRoot .\4bitcss.svg)



=<svg> -ViewBox 640, 640 @(
    foreach ($n in 16..1) {
        =<svg.rect> -X (
            320 - ((16 - $n +1 ) * 20)
        ) -Y (
            320 - ((16 - $n +1 ) * 20)            
        ) -Class "ansi$($n - 1)-fill" -Width ($n * 20) -Height ($n * 20)
    }    
) -OutputPath (Join-Path $docsRoot .\4bitpreview.svg)

$assetFile
$assetFile | Copy-Item -Destination (Join-Path $docsRoot .\4bitcss.svg) -PassThru

Pop-Location