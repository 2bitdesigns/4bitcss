function Export-4BitCSS
{
    <#
    .SYNOPSIS
        Exports 4bitCSS
    .DESCRIPTION        
        Converts a color scheme into 4bitCSS and outputs a .CSS file.
    #>
    [Alias('Template.CSS.4Bit','Template.4bit.css')]
    param(
    # The name of the color scheme.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [ComponentModel.DefaultBindingProperty("name")]
    [string]
    $Name,

    # The color for Black (ANSI0).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ANSI0')]
    [ComponentModel.DefaultBindingProperty("black")]
    [string]
    $Black,

    # The color for Red (ANSI 1).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ANSI1')]
    [ComponentModel.DefaultBindingProperty("red")]
    [string]
    $Red,

    # The color for Green (ANSI 2).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ANSI2')]
    [ComponentModel.DefaultBindingProperty("green")]
    [string]
    $Green,
    
    # The color for Yellow (ANSI 3).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ANSI3')]
    [ComponentModel.DefaultBindingProperty("yellow")]
    [string]
    $Yellow,
    
    # The color for Blue (ANSI 4).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ANSI4')]
    [ComponentModel.DefaultBindingProperty("blue")]
    [string]
    $Blue,

    # The color for Purple/Magneta (ANSI 5).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ANSI5')]
    [Alias('Magenta')]
    [ComponentModel.DefaultBindingProperty("purple")]
    [string]
    $Purple,

    # The color for Cyan (ANSI 6).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ANSI6')]
    [ComponentModel.DefaultBindingProperty("cyan")]
    [string]
    $Cyan,

    # The color for White (ANSI 7).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ANSI7')]
    [ComponentModel.DefaultBindingProperty("white")]
    [string]
    $White,

    # The color for Bright Black (ANSI 8).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ANSI8')]
    [ComponentModel.DefaultBindingProperty("brightBlack")]
    [string]
    $BrightBlack,

    # The color for Bright Red (ANSI 9).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ANSI9')]
    [ComponentModel.DefaultBindingProperty("brightRed")]
    [string]
    $BrightRed,

    # The color for Bright Green (ANSI 10).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ANSI10')]
    [ComponentModel.DefaultBindingProperty("brightGreen")]
    [string]
    $BrightGreen,

    # The color for Bright Yellow (ANSI 11).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ANSI11')]
    [ComponentModel.DefaultBindingProperty("brightYellow")]
    [string]
    $BrightYellow,

    # The color for Bright Blue (ANSI 12).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ANSI12')]
    [ComponentModel.DefaultBindingProperty("brightBlue")]
    [string]
    $BrightBlue,

    # The color for Bright Purple / Magneta (ANSI 13).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('BrightMagenta')]
    [Alias('ANSI13')]
    [ComponentModel.DefaultBindingProperty("brightPurple")]
    [string]
    $BrightPurple,

    # The color for Bright Cyan (ANSI 14).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ANSI14')]
    [ComponentModel.DefaultBindingProperty("brightCyan")]
    [string]
    $BrightCyan,

    # The color for Bright White (ANSI 15).
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ANSI15')]
    [ComponentModel.DefaultBindingProperty("brightWhite")]
    [string]
    $BrightWhite,

    # The background color. (Should be the value for Black)
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [ComponentModel.DefaultBindingProperty("background")]
    [string]
    $Background,

    # The foreground color. (Should be the value for White)
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [ComponentModel.DefaultBindingProperty("foreground")]
    [string]
    $Foreground,

    # The cursor color.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ComponentModel.DefaultBindingProperty("cursorColor")]
    [string]
    $CursorColor,

    # The selection background.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ComponentModel.DefaultBindingProperty("selectionBackground")]
    [string]
    $SelectionBackground,

    # The output path.  If not specified, will output to the current directory.
    [string]
    $OutputPath,

    # If set, will not generate css classes for well-known streams
    [Alias('NoStreams','NoStreamColors')]
    [switch]
    $NoStream,

    # If set, will not generate css classes for each color.
    [Alias('NoColorNames', 'NoNamedColors')]
    [switch]
    $NoColorName,

    # If set, will not generate css classes for each potential fill
    [Alias('NoFills','NoNamedColorFill')]
    [switch]
    $NoFill,

    # If set, will not generate css classes for each potential stroke.
    [Alias('NoStrokes','NoNamedColorStroke')]
    [switch]
    $NoStroke,

    # If set, will not generate css classes for each background-color stroke.
    [Alias('NoBackgrounColors')]
    [switch]
    $NoBackgroundColor,

    # If set, will not generate css classes that correspond to `$psStyle`.
    [Alias('NoStyles','NoPSStyle','NoPSStyles')]
    [switch]
    $NoStyle,

    # If set, will not include CSS for common page elements
    [Alias('NoElements')]
    [switch]
    $NoElement,    

    # If set, will generate minimal css (not minimized) 
    # Implies all other -No* switches
    [Alias('VariablesOnly')]
    [switch]
    $Minimal    
    )

    process {
        if (-not $OutputPath) {
            $OutputPath = 
                if ($MyInvocation.MyCommand.ScriptBlock.Module) {
                    $MyInvocation.MyCommand.ScriptBlock.Module
                } else {
                    $PSScriptRoot | Split-Path
                }
        }

        if (-not (Test-Path $OutputPath)) {
            $null = New-Item -ItemType Directory -Force -Path $OutputPath
        }

        # get a reference to this command
        $myCmd = $MyInvocation.MyCommand

        $jsonObject = [Ordered]@{}
        
        $ColorOrder = @(
            'Black', 'Red', 'Green', 'Yellow', 'Blue', 'Purple', 'Cyan', 'White'
        )

        # Walk over each parameter
        :nextParam foreach ($keyValue in $PSBoundParameters.GetEnumerator()) {
            # and walk over each of it's attributes to see if it part of the payload
            foreach ($attr in $myCmd.Parameters[$keyValue.Key].Attributes) {
                # If the parameter is bound to part of the payload
                if ($attr -is [ComponentModel.DefaultBindingPropertyAttribute]) {
                    # copy it into our payload dicitionary.
                    $jsonObject[$attr.Name] = $keyValue.Value
                    # (don't forget to turn switches into booleans)
                    if ($jsonObject[$attr.Name] -is [switch]) {
                        $jsonObject[$attr.Name] = [bool]$jsonObject[$attr.Name]
                    }
                    continue nextParam
                }
            }
        }

        $jsonObject = [PSCustomObject]$jsonObject

        if ($Minimal) {
            $NoStream = $true
            $NoColorName = $true
            $NoFill = $true
            $NoElement = $true
            $NoStroke = $true
            $NoBackgroundColor = $true
            $NoStyle = $true
        }
    
        $rgb = ($Background -replace "#", "0x" -replace ';') -as [UInt32]
        $r, $g, $b = ([float][byte](($rgb -band 0xff0000) -shr 16)/255),
            ([float][byte](($rgb -band 0x00ff00) -shr 8)/255),
            ([float][byte]($rgb -band 0x0000ff)/255)

        $Luma = 0.2126 * $R + 0.7152 * $G + 0.0722 * $B
        $IsBright = $luma -gt .5
        
        $cssFile    = (Join-Path $OutputPath "$($name | Convert-4BitName).css")
        $className  = $Name -replace '\s' -replace '^\d', '_$0'

        $cssContent = @(
            @"
:root {
  $(@(
    foreach ($prop in $jsonObject.psobject.properties) {
        if ($prop.Name -eq 'Name') {
            "--$($prop.Name): '$($prop.Value)'"            
        } else {
            "--$($prop.Name): $($prop.Value)"
        }    
    }) -join (';' + [Environment]::NewLine + '  '));
  --IsBright: $($IsBright -as [int]);
  --IsDark: $((-not $IsBright) -as [int]);
}

.colorSchemeName::before, .ColorSchemeName::before { content: '$($name)'; }
.colorSchemeFileName::before, .ColorSchemeFileName::before { content: '$($name | Convert-4BitName).css'; }

"@

# Foreground and background colors

@"
.foreground, .Foreground { color: var(--foreground); }
.background, .Background { background-color: var(--background); }

.foreground-border , .Foreground-Border   { border-color: var(--foreground)  }
.foreground-fill   , .Foreground-Fill     { fill: var(--foreground)          }
.foreground-stroke , .Foreground-Stroke   { stroke: var(--foreground)        }

.background-border , .Background-Border  { border-color: var(--background)   }
.background-fill   , .Background-Fill    { fill: var(--background)           }
.background-stroke , .Background-Stroke  { stroke: var(--background)         }
"@

# Colors for well-known "Streams" of data.
if (-not $NoStream) {
@"
.output   , .Output      { color: var(--foreground)   }
.success  , .Success     { color: var(--brightGreen)  }
.failure  , .Failure     { color: var(--red)          }
.error    , .Error       { color: var(--brightRed)    }
.warning  , .Warning     { color: var(--brightYellow) }
.debug    , .Debug       { color: var(--yellow)       }
.verbose  , .Verbose     { color: var(--brightCyan)   }
.progress , .Progress    { color: var(--cyan)         }
.link     , .Link        { color: var(--cyan)         }

.error-border      , .Error-Border       { border-color: var(--brightRed)    }
.error-fill        , .Error-Fill         { fill: var(--brightRed)            }
.error-stroke      , .Error-Stroke       { stroke: var(--brightRed)          }

.success-border    , .Success-Border     { border-color: var(--brightGreen)  }
.success-fill      , .Sucesss-Fill       { fill: var(--brightGreen)          } 
.sucesss-stroke    , .Success-Stroke     { stroke: var(--brightGreen)        }

.warning-border    , .Warning-Border     { border-color: var(--brightYellow) }
.warning-fill      , .Warning-Fill       { fill: var(--brightYellow)         }
.warning-stroke    , .Warning-Stroke     { stroke: var(--brightYellow)       }
"@
}

if (-not $NoColorName) {
@"
.black   ,  .Black   , .ANSI0  { color: var(--black)  }
.red     ,  .Red     , .ANSI1  { color: var(--red)    }
.green   ,  .Green   , .ANSI2  { color: var(--green)  }
.yellow  ,  .Yellow  , .ANSI3  { color: var(--yellow) }
.blue    ,  .Blue    , .ANSI4  { color: var(--blue)   }
.magenta ,  .Magenta , .ANSI5  { color: var(--purple) }
.cyan    ,  .Cyan    , .ANSI6  { color: var(--cyan)   }
.white   ,  .White   , .ANSI7  { color: var(--white)  }

.brightblack   ,  .bright-black   , .BrightBlack   , .ANSI8   { color: var(--brightBlack)  }
.brightred     ,  .bright-red     , .BrightRed     , .ANSI9   { color: var(--brightRed)    }
.brightgreen   ,  .bright-green   , .BrightGreen   , .ANSI10  { color: var(--brightGreen)  }
.brightyellow  ,  .bright-yellow  , .BrightYellow  , .ANSI11  { color: var(--brightYellow) }
.brightblue    ,  .bright-blue    , .BrightBlue    , .ANSI12  { color: var(--brightBlue)   }
.brightmagenta ,  .bright-magenta , .BrightMagenta , .ANSI13  { color: var(--brightPurple) }
.brightcyan    ,  .bright-cyan    , .BrightCyan    , .ANSI14  { color: var(--brightCyan)   }
.brightwhite   ,  .bright-white   , .BrightWhite   , .ANSI15  { color: var(--brightWhite)  }

.purple       ,  .Purple  { color: var(--purple) }

.brightpurple ,  .bright-purple , .BrightPurple  { color: var(--brightPurple) }
"@
}

if (-not $NoBackgroundColor) {
@"
.black-background, .BlackBackground, .ANSI0-Background, .ansi0-background { background-color: var(--black)  }
.red-background, .RedBackground, .ANSI1-Background, .ansi1-background { background-color: var(--red)  }
.green-background, .GreenBackground, .ANSI2-Background, .ansi2-background { background-color: var(--green)  }
.yellow-background, .YellowBackground, .ANSI3-Background, .ansi3-background { background-color: var(--yellow)  }
.blue-background, .BlueBackground, .ANSI4-Background, .ansi4-background { background-color: var(--blue)  }
.magenta-background, .MagentaBackground, .ANSI5-Background, .ansi5-background { background-color: var(--purple)  }
.cyan-background, .CyanBackground, .ANSI6-Background, .ansi6-background { background-color: var(--cyan)  }
.white-background, .WhiteBackground, .ANSI7-Background, .ansi7-background { background-color: var(--white)  }
.brightblack-background, .bright-black-background, .BrightBlackBackground, .ANSI8-Background, .ansi8-background { background-color: var(--brightBlack)  }
.brightred-background, .bright-red-background, .BrightRedBackground, .ANSI9-Background, .ansi9-background { background-color: var(--brightRed)  }
.brightgreen-background, .bright-green-background, .BrightGreenBackground, .ANSI10-Background, .ansi10-background { background-color: var(--brightGreen)  }
.brightyellow-background, .bright-yellow-background, .BrightYellowBackground, .ANSI11-Background, .ansi11-background { background-color: var(--brightYellow)  }
.brightblue-background, .bright-blue-background, .BrightBlueBackground, .ANSI12-Background, .ansi12-background { background-color: var(--brightBlue)  }
.brightmagenta-background, .bright-magenta-background, .BrightMagentaBackground, .ANSI13-Background, .ansi13-background { background-color: var(--brightPurple)  }
.brightcyan-background, .bright-cyan-background, .BrightCyanBackground, .ANSI14-Background, .ansi14-background { background-color: var(--brightCyan)  }
.brightwhite-background, .bright-white-background, .BrightWhiteBackground, .ANSI15-Background, .ansi15-background { background-color: var(--brightWhite)  }
"@
}

if (-not $NoFill) {
@"
.black-fill   ,  .BlackFill   , .ANSI0-Fill,   .ansi0-fill   { fill: var(--black)  }
.red-fill   ,  .RedFill   , .ANSI1-Fill,   .ansi1-fill   { fill: var(--red)  }
.green-fill   ,  .GreenFill   , .ANSI2-Fill,   .ansi2-fill   { fill: var(--green)  }
.yellow-fill   ,  .YellowFill   , .ANSI3-Fill,   .ansi3-fill   { fill: var(--yellow)  }
.blue-fill   ,  .BlueFill   , .ANSI4-Fill,   .ansi4-fill   { fill: var(--blue)  }
.magenta-fill   ,  .MagentaFill   , .ANSI5-Fill,   .ansi5-fill   { fill: var(--purple)  }
.purple-fill, .PurpleFill     { fill: var(--purple) }
.cyan-fill   ,  .CyanFill   , .ANSI6-Fill,   .ansi6-fill   { fill: var(--cyan)  }
.white-fill   ,  .WhiteFill   , .ANSI7-Fill,   .ansi7-fill   { fill: var(--white)  }
.brightblack-fill   ,  .bright-black-fill   , .BrightBlackFill   , .ANSI8-Fill, .ansi8-fill   { fill: var(--brightBlack)         }
.brightred-fill   ,  .bright-red-fill   , .BrightRedFill   , .ANSI9-Fill, .ansi9-fill   { fill: var(--brightRed)                 }
.brightgreen-fill   ,  .bright-green-fill   , .BrightGreenFill   , .ANSI10-Fill, .ansi10-fill   { fill: var(--brightGreen)       }
.brightyellow-fill   ,  .bright-yellow-fill   , .BrightYellowFill   , .ANSI11-Fill, .ansi11-fill   { fill: var(--brightYellow)   }
.brightblue-fill   ,  .bright-blue-fill   , .BrightBlueFill   , .ANSI12-Fill, .ansi12-fill   { fill: var(--brightBlue)           }
.brightmagneta-fill   ,  .bright-magneta-fill   , .BrightMagnetaFill   , .ANSI13-Fill, .ansi13-fill   { fill: var(--brightPurple) }
.brightpurple-fill      , .bright-purple-fill, .BrightPurpleFill { fill: var(--brightPuple)                                      }
.brightcyan-fill   ,  .bright-cyan-fill   , .BrightCyanFill   , .ANSI14-Fill, .ansi14-fill   { fill: var(--brightCyan)           }
.brightwhite-fill   ,  .bright-white-fill   , .BrightWhiteFill   , .ANSI15-Fill, .ansi15-fill   { fill: var(--brightWhite)       }
"@
}

if (-not $NoStroke) {
@"
.black-stroke ,  .BlackStroke , .ANSI0-Stroke, .ansi0-stroke { stroke: var(--black)  }
.red-stroke ,  .RedStroke , .ANSI1-Stroke, .ansi1-stroke { stroke: var(--red)  }
.green-stroke ,  .GreenStroke , .ANSI2-Stroke, .ansi2-stroke { stroke: var(--green)  }
.yellow-stroke ,  .YellowStroke , .ANSI3-Stroke, .ansi3-stroke { stroke: var(--yellow)  }
.blue-stroke ,  .BlueStroke , .ANSI4-Stroke, .ansi4-stroke { stroke: var(--blue)  }
.magenta-stroke ,  .MagentaStroke , .ANSI5-Stroke, .ansi5-stroke { stroke: var(--purple)  }
.purple-stroke, .PurpleStroke { stroke: var(--purple) }
.cyan-stroke ,  .CyanStroke , .ANSI6-Stroke, .ansi6-stroke { stroke: var(--cyan)  }
.white-stroke ,  .WhiteStroke , .ANSI7-Stroke, .ansi7-stroke { stroke: var(--white)  }
.brightblack-stroke ,  .bright-black-stroke , .BrightBlackStroke   , .ANSI8-Stroke, .ansi8-stroke   { stroke: var(--brightBlack)  }
.brightred-stroke ,  .bright-red-stroke , .BrightRedStroke   , .ANSI9-stroke, .ansi9-stroke   { stroke: var(--brightRed)  }
.brightgreen-stroke ,  .bright-green-stroke , .BrightGreenStroke   , .ANSI10-Stroke, .ansi10-stroke   { stroke: var(--brightGreen)     }
.brightyellow-stroke ,  .bright-yellow-stroke , .BrightYellowStroke, .ANSI11-Stroke, .ansi11-stroke   { stroke: var(--brightYellow) }
.brightblue-stroke ,  .bright-blue-stroke , .BrightBlueStroke   , .ANSI12-Stroke, .ansi12-stroke   { stroke: var(--brightBlue)  }
.brightmagneta-stroke ,  .bright-magneta-stroke , .BrightMagnetaStroke   , .ANSI13-Stroke, .ansi13-stroke   { stroke: var(--brightPuple)  }
.brightpurple-stroke    , .bright-purple-stroke, .BrightPurpleStroke { stroke: var(--brightPuple)  }
.brightcyan-stroke ,  .bright-cyan-stroke , .BrightCyanStroke   , .ANSI14-Stroke, .ansi14-stroke   { stroke: var(--brightCyan)  }
.brightwhite-stroke ,  .bright-white-stroke , .BrightWhiteStroke   , .ANSI15-Stroke, .ansi15-stroke   { stroke: var(--brightWhite)     }
"@
}

if (-not $NoStyle) {
@"
.dim, .Dim { opacity: .5; }
.hidden, .Hidden { opacity: 0; }
b, bold, .bold, .Bold { font-weight: bold; }
.boldOff, .BoldOff { font-weight: normal; }
i, italic, .italic, .Italic { font-style: italic; }
.italicOff, .ItalicOff { font-style: normal; }
u, underline, .underline, .Underline { text-decoration: underline; }
.underlineOff, .UnderlineOff { text-decoration: none; }
s, strike, .strike, .Strike, .strikethrough, .Strikethrough { text-decoration: line-through; }
.strikeOff, .StrikeOff, .strikethroughOff, .StrikethroughOff { text-decoration: none; }
"@

foreach ($subproperty in 'Formatting', 'Progress') {
    :nextStyleProperty foreach ($styleProperty in $PSStyle.$subproperty.psobject.properties) {
        if ($styleProperty.Value -notmatch '\e') { continue }
        $null = $styleProperty.Value -match '\e\[(?<n>[\d;]+)m'
        $styleBytes = $matches.n -split ';' -as [byte[]]
        $cssProperties = @(
            switch ($styleBytes) {
                1 { 'font-weight: bold' }
                3 { 'font-style: italic' }
                4 { 'text-decoration: underline' }
                9 { 'text-decoration: line-through' }
                22 { 'font-weight: normal' }
                23 { 'font-style: normal' }
                24 { 'text-decoration: none' }
                default {
                    if ($_ -in 30..37) {
                        $colorName = $ColorOrder[$_ - 30]
                        if (-not $colorName) {
                            Write-Warning "Could not translate `$psStyle.$($subproperty).$($styleProperty.Name) to a color."
                            continue nextStyleProperty
                        }
                        $colorName = $colorName.Substring(0, 1).ToLower() + $colorName.Substring(1)
                        "color: var(--$colorName)"
                    } elseif ($_ -in 40..47) {
                        $colorName = $ColorOrder[$_ - 40]
                        if (-not $colorName) {
                            Write-Warning "Could not translate `$psStyle.$($subproperty).$($styleProperty.Name) to a color."
                            continue nextStyleProperty
                        }
                        $colorName = $colorName.Substring(0, 1).ToLower() + $colorName.Substring(1)
                        "background-color: var(--$colorName)"
                    } elseif ($_ -eq 38) {                
                        "color: var(--foreground)"
                    } elseif ($_ -eq 48) {                
                        "background-color: var(--background)"
                    }
                    elseif ($_ -in 90..97) {
                        $colorName = "bright$($ColorOrder[$_ - 90])"
                        if (-not $colorName) {
                            Write-Warning "Could not translate `$psStyle.$($subproperty).$($styleProperty.Name) to a color."
                            continue nextStyleProperty
                        }
                        "color: var(--$colorName)"
                    } elseif ($_ -in 100..107) {
                        $colorName = "bright$($ColorOrder[$_ - 100])"
                        if (-not $colorName) {
                            Write-Warning "Could not translate `$psStyle.$($subproperty).$($styleProperty.Name) to a color."
                            continue nextStyleProperty
                        }
                        "background-color: var(--$colorName)"
                    }
                }
            }
        )

        $className = ".$subproperty-$($styleProperty.Name)"
        "$className { $($cssProperties -ne '' -join ';') }"
    }
}
}

if (-not $NoElement) {
@"

body {
    color: var(--foreground);
    background-color: var(--background);
}

a, a:visited, a:hover  { color: var(--cyan); }

::selection, ::-moz-selection {
    color: var(--cursorColor);
    background-color: var(--selectionBackground);
}
    
form input[type="text"], form input[type="checkbox"], input[type="button"], textarea, select, option {
    color: var(--foreground);
    background-color: var(--background);
}

option {
    color: var(--foreground);
    background: var(--background);
}

form input[type="text"], textarea, select {
    border : 1px solid var(--foreground);
    outline: 1px solid var(--foreground);
}

hr {
    color: var(--foreground)
}
"@
}

        ) -join [Environment]::NewLine
        $cssContent | Set-Content -Path $cssFile
        Get-Item -Path $cssFile
    }
}
