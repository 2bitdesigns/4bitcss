@{
    ModuleVersion = '0.1.4'
    RootModule = '4bitcss.psm1'
    Description = 'CSS3 Color Schemes'
    Guid = '93e1d6ab-ce88-4751-bb14-b21fbb9f66f3'
    CompanyName = 'Start-Automating'
    Author = 'James Brundage'
    Copyright = '2022-2024 Start-Automating'
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/2bitdesigns'
            LicenseURI = 'https://github.com/2bitdesigns/4bitcss/blob/main/LICENSE'
            ReleaseNotes = @'
> Like It? [Star It](https://github.com/2bitdesigns/4bitcss)
> Love It? [Support It](https://github.com/sponsors/StartAutomating)

## 0.1.4:

* So many more new palettes!
* `-background` classes (#42)
* `$psStyle` compatibility (#43, #52, #53, #54, #55, #56, #57, #58)
* Producing additional files:
  * A .txt file per palette (#61)
  * Palettes.json (#60)
  * Palette-List.json, Dark-Palette-List.json, Bright-Palette-List.json
* `<select>` support (#39)
* Fixing strokes (#59)
* Adding Docker Image (#49, #50, #51)
* Module Improvements
  * Mounting 4bitcss (#48)
  * Exporting `$4bitcss` (#47)
  * Repository Cleanup (#44, #45, #46)
* New Commands   
  * Convert-4bitName (#33)
  * Export-4bitJS (#32)
  * Export-4bitSVG (#34)
* Allowing color palettes without `selectioncolor` or `cursorcolor` (#31)
* Putting Palettes into directories (#30)

---

Additional History in [Changelog](https://github.com/2bitdesigns/4bitcss/blob/main/CHANGELOG.md)
'@
            WebSite = @{  
                Url  = 'https://4bitcss.com/'
                Tech = 'Jekyll'
                Root = '/docs'
            }
        }
    }
}
