function Export-4BitSVG
{
    <#
    .SYNOPSIS
        Exports an SVG that uses a 4 bit palette 
    .DESCRIPTION
        Exports an SVG with a slight modifications that make it use a specific color palette.
    .NOTES
        SVGs can use CSS styles to dynamically change color.
    #>
    param(
    # The SVG content, or a URL to the SVG
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $SVG,

    # The color used for strokes within the SVG.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Stroke,

    # The color used for fill within the SVG.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Fill,

    # If provided, will output the SVG to a file
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $OutputPath
    )

    process {
        $svgXML = $null
        if ($svg -match "^https?://") {
            $svgRest = Invoke-RestMethod -Uri $svg
            if ($svgRest -isnot [xml]) {
                Write-Error "$Svg was not XML"
                return
            }
            $svgXML = $svgRest
            $svg = $svgXML.OuterXML
        } elseif ($svg -notmatch '[\n\r]' -and (Test-path $svg)) {
            $svg = Get-Content -Path $svg -Raw
        }
        
        
        if (-not ($svg -as [xml])) {
            try {
                $svgXML = [xml]$svg
            } catch {
                $ex = $_
                Write-Error -Exception $ex.Exception -Message "Could not convert to SVG: $($ex.Exception)" -TargetObject $svg
            }
        }

        if (-not $svgXML) { return }

        $svgClass = @(
            if ($stroke) {
                $stroke -replace "(?:-stroke)?$", '-stroke'
            }
            if ($Fill) {
                $fill -replace "(?:-fill)?$", '-fill'
            }
        ) -join ' '
        
        if ($svgClass) {
            $svgXML.svg.SetAttribute("class", "$svgClass")
        }

        if ($OutputPath) {
            $svgXML.svg.OuterXML | Set-Content -Path $OutputPath
            if ($?) {
                Get-Item -Path $OutputPath
            }
        } else {
            $svgXML.svg.OuterXML
        }
        
    }
}