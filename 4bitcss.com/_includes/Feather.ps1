<#
.SYNOPSIS
    Includes Feather Icons
.DESCRIPTION
    Includes a feather icon in the site.
.NOTES
    Icons will be cached in memory to avoid repeated CDN requests.
.EXAMPLE
    . $site.Includes.Feather "clipboard"
.LINK
    https://feathericons.com/
#>
param(
[string]
$Icon = 'chevron-right',

[uri]
$FeatherCDN = "https://cdn.jsdelivr.net/gh/feathericons/feather@latest/icons/"
)

if (-not $script:FeatherIconCache) {
    $script:FeatherIconCache = [Ordered]@{}
}
$icon = $icon.ToLower() -replace '\.svg$'

if (-not $script:FeatherIconCache[$icon]) {
    $script:FeatherIconCache[$icon] = Invoke-RestMethod "$FeatherCDN/$Icon.svg"
}

$script:FeatherIconCache[$icon].OuterXml

 
