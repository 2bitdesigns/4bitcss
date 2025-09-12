if ($PSScriptRoot) { Push-Location $PSScriptRoot }
$sparseClone = 
    git.sparse https://github.com/mbadolato/iTerm2-Color-Schemes.git ../iTerm2-Color-Schemes -Pattern @(
        '/windowsterminal/**/**.json'
        '/CREDITS.md'    
    )

$creditLines = Get-Content ../iTerm2-Color-Schemes/CREDITS.md

filter GetCredits {
    $colorSchemeName = $_
    $colorSchemePattern = [Regex]::Escape($colorSchemeName) -replace '\\ ', '[\s_]'
    $markdownLinkPattern = '\[(?<text>.+?)\]\((?<link>.+?)\)'
    foreach ($line in $creditLines) {
        if (-not $line ) { continue }
        if ($line -notmatch $colorSchemePattern) {
            continue            
        }
        if ($line -notmatch $markdownLinkPattern) {
            continue
        }        
        [PSCustomObject][Ordered]@{credit=$Matches.text; link=$Matches.link}
    }
}

$jsonOutputRoot = Join-Path $PSScriptRoot json
if (-not (Test-Path $jsonOutputRoot)) {
    $null = New-Item -ItemType Directory -Path $jsonOutputRoot
}

filter GetLuma {
    $colorString = $_
    # Convert the background color to a uint32
    $rgb = ($colorString -replace "#", "0x" -replace ';') -as [UInt32]
    # then make it into a percentage red, green, and blue.
    $r, $g, $b = ([float][byte](($rgb -band 0xff0000) -shr 16)/255),
        ([float][byte](($rgb -band 0x00ff00) -shr 8)/255),
        ([float][byte]($rgb -band 0x0000ff)/255)

    # Calculate the luma of the background color
    0.2126 * $R + 0.7152 * $G + 0.0722 * $B    
}

filter GetHSL {
    $colorString = $_
    # Convert the background color to a uint32
    $rgb = ($colorString -replace "#", "0x" -replace ';') -as [UInt32]
    # then make it into a percentage red, green, and blue.
    $r, $g, $b = ([float][byte](($rgb -band 0xff0000) -shr 16)/255),
        ([float][byte](($rgb -band 0x00ff00) -shr 8)/255),
        ([float][byte]($rgb -band 0x0000ff)/255)

    [float]$PercentRed = $R
    [float]$PercentGreen = $G
    [float]$PercentBlue = $B

    $min = $max = $PercentRed
    foreach ($_ in $PercentGreen, $PercentBlue) {
        if ($_ -lt $min) { $min = $_ }
        if ($_ -ge $max) { $max = $_ }
    }

    $Luminance = ($min + $max)  / 2
    $delta = $max - $min
    
    if (-not $delta) {
        $hue = $saturation = 0                 
    } else {
        $saturation = $delta
        $saturation /= (1 - [Math]::Abs(((2 * $Luminance) -1)))
        
        $hue =  
            if ($Max -eq $PercentRed){
                ($PercentGreen - $PercentBlue)/$delta % 6      
            } elseif ($max -eq $PercentGreen) {
                (($PercentBlue - $PercentRed)/ $delta) + 2
            } else {                
                (($PercentRed - $PercentGreen)/ $delta) + 4
            }
    }
    $hue*=60
    if ($hue -gt 360) { $hue -= 360 } 
    if ($hue -lt 0) { $hue = 360 + $hue } 
    [PSCustomObject][Ordered]@{
        PSTypeName = 'Color'
        R = $R
        G = $G
        B = $B
        RGB = $colorString
        Hue = $hue
        Saturation = $saturation
        Luminance = $Luminance
    }
}

$paletteJsonFiles = $sparseClone | Where-Object Extension -eq '.json'
$allPalettes = [Ordered]@{}

$createdFiles = foreach ($paletteJsonFile in $paletteJsonFiles) {
    $paletteContent = [IO.File]::ReadAllText($paletteJsonFile.FullName)
    $paletteObject = $paletteContent | ConvertFrom-Json
    $paletteObject.pstypenames.insert(0, 'Palette')
    # and determine the name of the scheme and it's files.
    $paletteName = $colorSchemeName = $paletteObject.Name
    $colorSchemeFileName =
        $paletteObject.Name | Convert-4BitName
        
    $creditInfo = @($colorSchemeName | GetCredits)[0]
    $paletteObject | 
        Add-Member NoteProperty creditTo -Force -PassThru -Value $creditInfo.credit |
        Add-Member NoteProperty creditToLink -Force -Value $creditInfo.link
    
    if ($paletteObject.background) {
        $paletteObject | 
            Add-Member NoteProperty luma -Force -Value $($paletteObject.Background | GetLuma)
    }

    if ($paletteObject.background) {
        $paletteObject | 
            Add-Member NoteProperty hue -Force -Value $($paletteObject.Background | GetHSL | Select-Object -ExpandProperty Hue)
    }

    $IsBright = $paletteObject.luma -ge .4

    $paletteObject | Add-Member NoteProperty IsBright $IsBright -Force
    $paletteObject | Add-Member NoteProperty IsDark (-not $IsBright) -Force

    if ($paletteObject.foreground) {
        $paletteObject | 
            Add-Member NoteProperty foregroundLuma -Force -Value $($paletteObject.foreground | GetLuma)
    }

    if ($paletteObject.background) {
        $paletteObject | 
            Add-Member NoteProperty foregroundHue -Force -Value $($paletteObject.foreground | GetHSL | Select-Object -ExpandProperty Hue)
    }

    if ($paletteObject.foreground -and $paletteObject.background) {
        $contrastLevel = [Math]::Abs(
            ($paletteObject.background | GetLuma) - ($paletteObject.foreground | GetLuma)
        )
        $paletteObject | 
            Add-Member NoteProperty contrast -Force -Value $contrastLevel
    }    

    if (-not $colorSchemeFileName) { continue }
    $paletteObject | Add-Member NoteProperty FileName $colorSchemeFileName -Force
    $jsonOutputPath = Join-Path $jsonOutputRoot "$colorSchemeFileName.json"
    $paletteObject | ConvertTo-Json -Depth 4 | Set-Content -Path $jsonOutputPath
    Get-Item $jsonOutputPath
    

    $allPalettes[$colorSchemeFileName] = $paletteObject    
}

if ($site.FilesProcessed) {
    foreach ($file in $createdFiles) {
        $site.FilesProcessed[$file.FullName] = $true
    }
}


# $allPalettes | ConvertTo-Json -Depth 10 | Set-Content -Path "./Palettes.json"
# Get-Item -Path ./Palettes.json
$allPalettes

if ($PSScriptRoot) { Pop-Location}