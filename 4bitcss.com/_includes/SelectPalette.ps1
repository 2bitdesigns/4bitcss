<#
.SYNOPSIS
    Includes a palette selector
.DESCRIPTION
    Includes a palette selector in a page.  This allows the page to use multiple color palettes. 
#>
param(
[uri]
$PaletteListSource = 'https://4bitcss.com/Palette-List.json',

# The Palette CDN.  This is the root URL of all palettes.
[uri]
$PaletteCDN = 'https://cdn.jsdelivr.net/gh/2bitdesigns/4bitcss@latest/css/',

# The identifier for the palette `<select>`.
[string]
$SelectPaletteId = 'SelectPalette',

# The identifier for the stylesheet.  By default, palette.
[string]
$PaletteId = 'palette'
)


$SetPaletteFunction = @"
function SetPalette() {
    var palette = document.getElementById('$PaletteId')
    if (! palette) {
        palette = document.createElement('link')
        palette.rel = 'stylesheet'
        palette.id = 'palette'
        document.head.appendChild(palette)
    }
    var selectedPalette = document.getElementById('$SelectPaletteId').value
    palette.href = '$PaletteCDN' + selectedPalette + '.css'        
}
"@

if ($palleteList) {

}

$paletteSelector = @"
<select id='$SelectPaletteId' onchange='SetPalette()'>
$(
    if (-not $script:PaletteList) {
        if ($site.Palettes.Count) {
            $script:PaletteList = $site.Palettes.Keys | Sort-Object
        } else {
            $script:PaletteList = Invoke-RestMethod $PaletteListSource
        }        
    }
    foreach ($paletteName in $script:PaletteList) {
        "<option value='$([Web.HttpUtility]::HtmlAttributeEncode($paletteName))'>$([Web.HttpUtility]::HtmlEncode($paletteName))</option>"
    }
)
</select>
"@


$HTML = @"
<script>
$SetPaletteFunction
</script>
$PaletteSelector
<script>
var currentPaletteName = getComputedStyle(document.querySelector("body")).getPropertyValue('--PaletteName');
var paletteSelector = document.getElementById('$SelectPaletteId')
if (paletteSelector && currentPaletteName) {
    for (var paletteIndex = 0; paletteIndex < paletteSelector.options.length; paletteIndex++) {
        if (paletteSelector.options[paletteIndex].value == currentPaletteName) {
            paletteSelector.selectedIndex = paletteIndex
            break    
        }
    }    
}
</script>
"@

$HTML

