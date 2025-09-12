
<#
#>
param(
[PSObject]
$Palette
)

if ($palette -is [string] -and $site.Palettes[$palette]) {
    $palette = $site.Palettes[$palette]
}
if (-not $palette) { return }
if ($palette -is [string]) { return $palette }

if ($page -isnot [Collections.IDictionary]) {
    $page = [Ordered]@{}
}

$page.PaletteName = "/css/$($palette.FileName)"

@"
<style>
h1, h2, h3 { text-align: center }
.paletteName { text-align: center }
.paletteFileName { text-align: center }
.palettePreview  { text-align: center }
.imageContainer { max-height: 33.3%; }
.example-output { 
    text-align: center;
    margin-left: auto;
    margin-right: auto;
    width: 66vw;
}
.colorGrid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2.5em; margin: 2.5em}
.colorLabel  {text-align:center; }
</style>
"@

"<h1>
    <a class='paletteLink' href='#'>    
        <span class='paletteName'></span>
    </a>
</h1>"

@"
<h2>
    <a class='paletteFileLink' href='#'>    
        <span class='paletteFileName'></span>
    </a>
</h2>
"@

@"
<h3>
$($site.Palettes.Count) CSS color palettes for web or terminal 
</h3>
"@

@"
<script>
    function UpdatePaletteLinks() {
        document.
            querySelectorAll('.paletteLink').
            forEach(
                (link) => {
                    var paletteName = getComputedStyle(link).getPropertyValue('--PaletteFileName');
                    link.href = '/' + paletteName
                }
            )
                
        document.
            querySelectorAll('.paletteFileLink').
            forEach(
                (link) => {
                    var paletteName = getComputedStyle(link).getPropertyValue('--PaletteFileName');
                    link.href = '/css/' + paletteName + '.css'
                }
            )        
    }

    UpdatePaletteLinks()    
</script>
"@

$colorOrder = 
    'Black','Red','Green','Yellow','Blue','Purple','Cyan','White',
    'BrightBlack','BrightRed','BrightGreen','BrightYellow','BrightBlue','BrightPurple','BrightCyan','BrightWhite'
<#
if (-not $script:MulticolorTurtles) {
    $script:MulticolorTurtles = [Ordered]@{
        triangle = turtle SierpinskiTriangle 42 5
    }
}
#>

"<div class='example-output'>"
    $site.includes.'4bitpreview.svg'.OuterXml
"</div>"
"<div class='example-output'>"
    $site.includes.'Animated-Palette.svg'.OuterXml
"</div>"

"<div class='colorGrid'>"
    
    foreach ($color in $colorOrder) {
        "<div>"    
            "<svg>"
                "<rect width='100%' height='100%' class='$($color)Fill' />"
            "</svg>"
            "<div class='colorLabel'>$color</div>"
            "<div class='colorHex'></div>"
        "</div>"
    }        
"</div>"

<#
foreach ($shapeName in $script:MulticolorTurtles.Keys) {
    $shape = $script:MulticolorTurtles[$shapeName]
    foreach ($color in $colorOrder) {
        $shape.PathClass = "$color-stroke"
        $shape.Id = "$shapeName-$color"
        "<div class='imageContainer example-output'>"
        "$shape"
        "</div>"
    }
}
"</div>"

 


#>