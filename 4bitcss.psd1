@{
    ModuleVersion = '0.1.3'
    RootModule = '4bitcss.psm1'
    Description = 'CSS3 Color Schemes'
    Guid = '93e1d6ab-ce88-4751-bb14-b21fbb9f66f3'
    CompanyName = 'Start-Automating'
    Author = 'James Brundage'
    Copyright = '2022-2023 Start-Automating'
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/2bitdesigns'
            LicenseURI = 'https://github.com/2bitdesigns/4bitcss/blob/main/LICENSE'
            ReleaseNotes = @'
## 0.1.3:

* Renaming Theme to ColorScheme (#24)
* Adding IsBright/IsDark to color scheme (#25)
* Exporting Color Scheme Names (#26)

---

## 0.1.2:

Updating the Site:

* 4bitcss logo updates:
  * Now multicolor (Fixes #17)
  * Lacks bullet points (Fixes #16)
* Theme is now automatically selected
* Links are now all iocns
  * Download / Cloud Download (Fixes #20)
  * FeelingLucky (Fixes #21)
* Removing Save/Load theme (for now) (Fixes #22)

## 0.1.1:

* Adding preview urls (e.g. https://4bitcss.com/Konsolas ) (Fixes #10)
* Export-4BitCss:
  * Fixing ansi13-fill (Fixes #12)
  * Quoting color scheme name (Fixes #11)
* Refactoring preview image (Fixes #9)
* Adding /using (Fixes #8)
* Site now supports OpenGraph (Fixes #13)
* Adding analytics (Fixes #7)

---

## 0.1: 

* Initial Release of 4bitcss
* 295 Glorious 16 Color Schemes!
'@
        }
    }
}
