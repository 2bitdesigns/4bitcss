function Export-4BitCSS
{
    <#
    .SYNOPSIS
        Exports 4bitCSS
    .DESCRIPTION        
        Converts a color scheme into 4bitCSS and outputs a .CSS file.
    #>
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
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [ComponentModel.DefaultBindingProperty("cursorColor")]
    [string]
    $CursorColor,

    # The selection background.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [ComponentModel.DefaultBindingProperty("selectionBackground")]
    [string]
    $SelectionBackground,

    # The output path.  If not specified, will output to the current directory.
    [string]
    $OutputPath
    )

    process {
        if (-not $OutputPath) {
            $OutputPath = $PSScriptRoot
        }

        # get a reference to this command
        $myCmd = $MyInvocation.MyCommand

        $jsonObject = [Ordered]@{}

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

        $cssFile    = (Join-Path $OutputPath "$($name -replace '\s').css")
        $className  = $Name -replace '\s' -replace '^\d', '_$0'
        $cssContent = 
    @"
:root {
    $(@(
    foreach ($prop in $jsonObject.psobject.properties) {
    "--$($prop.Name): $($prop.Value)"
    }) -join (';' + [Environment]::NewLine + '  '))
}

.foreground, .Foreground { color: var(--foreground);            }
.background, .Background { background-color: var(--background); }

.output   , .Output      { color: var(--foreground)   }
.success  , .Success     { color: var(--brightGreen)  }
.failure  , .Failure     { color: var(--red)          }
.error    , .Error       { color: var(--brightRed)    }
.warning  , .Warning     { color: var(--brightYellow) }
.debug    , .Debug       { color: var(--yellow)       }
.verbose  , .Verbose     { color: var(--brightCyan)   }
.progress , .Progress    { color: var(--cyan)         }
.link     , .Link        { color: var(--cyan)         }

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

.foreground-border , .Foreground-Border   { border-color: var(--foreground)  }
.foreground-fill   , .Foreground-Fill     { fill: var(--foreground)          }
.foreground-stroke , .Foreground-Stroke   { stroke: var(--foreground)        }

.background-border , .Background-Border  { border-color: var(--background)   }
.background-fill   , .Background-Fill    { fill: var(--background)           }
.background-stroke , .Background-Stroke  { stroke: var(--background)         }

.error-border      , .Error-Border       { border-color: var(--brightRed)    }
.error-fill        , .Error-Fill         { fill: var(--brightRed)            }
.error-stroke      , .Error-Stroke       { stroke: var(--brightRed)          }

.success-border    , .Success-Border     { border-color: var(--brightGreen)  }
.success-fill      , .Sucesss-Fill       { fill: var(--brightGreen)          } 
.sucesss-stroke    , .Success-Stroke     { stroke: var(--brightGreen)        }

.warning-border    , .Warning-Border     { border-color: var(--brightYellow) }
.warning-fill      , .Warning-Fill       { fill: var(--brightYellow)         }
.warning-stroke    , .Warning-Stroke     { stroke: var(--brightYellow)       }

a, a:visited, a:hover  { color: var(--cyan); }
::selection, ::-moz-selection {
    color: var(--cursorColor);
    background-color: var(--selectionBackground);
}
    
form input[type="text"], form input[type="checkbox"], input[type="button"], textarea, select, option {
    color: var(--foreground);
    background-color: var(--background);
}

form input[type="text"], textarea, select {
    border : 1px solid var(--foreground);
    outline: 1px solid var(--foreground);
}

hr {
    color: var(--foreground)
}
"@

        $cssContent | Set-Content -Path $cssFile
        Get-Item -Path $cssFile
    }
}
