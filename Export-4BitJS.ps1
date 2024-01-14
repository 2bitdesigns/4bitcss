function Export-4BitJS {
    <#
    .SYNOPSIS
        Exports 4bitJS
    .DESCRIPTION        
        Exports JavaScript to change 4bitCSS themes.
    #>
    [Alias('Template.4bit.js','Template.JavaScript.4bit')]
    param(
    # The names of all color schemes
    [Alias('ColorSchemeNames')]
    [string[]]
    $ColorSchemeName,

    # The names of all dark color schemes
    [Alias('DarkColorSchemeNames')]
    [string[]]
    $DarkColorSchemeName,

    # The names of all light color schemes
    [Alias('LightColorSchemeNames')]
    [string[]]
    $LightColorSchemeName,

    # The default color scheme to use.
    [string]    
    $DefaultColorScheme = 'Konsolas'
    )

@"
var defaultTheme = "$DefaultColorScheme";
function GetColorSchemeList() {
    return [
"'$($ColorSchemeName -join "','")'"
    ]
}

function GetDarkColorSchemes() {
    return [
"'$($DarkColorSchemeName -join "','")'"
]
}

function GetLightColorSchemes() {
    return [
"'$($LightColorSchemeName -join "','")'"
]
}

function feelingLucky() {
    var colorSchemes = GetColorSchemeList();
    var randomNumber = Math.floor(Math.random() * colorSchemes.length);
    var fourBitCssLink = document.getElementById("4bitcss");
    if (! fourBitCssLink) {
        throw "Must have a stylesheet link with the id '4bitcss'"
    }
    SetColorScheme(colorSchemes[randomNumber])

    for (arg in arguments) {
        if (arguments[arg].value) {
            arguments[arg].value = colorSchemes[randomNumber];
        }
    }
}

function SetColorScheme(colorSchemeName) {
    var fourBitCssLink = document.getElementById("4bitcss");
    if (! fourBitCssLink) {
        throw "Must have a stylesheet link with the id '4bitcss'"
    }
    var foundScheme = GetColorSchemeList().find(element => element == colorSchemeName);
    if (! foundScheme) {
        throw ("Color Scheme '" + colorSchemeName + "' does not exist");
    }
    fourBitCssLink.href = "/" + foundScheme + ".css";
    fourBitCssLink.themeName = foundScheme;
    var downloadLink = document.getElementById("downloadSchemeLink");
    if (downloadLink) {
        downloadLink.href = "/" + foundScheme + ".css";
    }
    var cdnLink = document.getElementById("cdnSchemeLink")
    if (cdnLink) {
        cdnLink.href = "https://cdn.jsdelivr.net/gh/2bitdesigns/4bitcss@latest/css/" + foundScheme + ".css";
    }

    var colorSchemeNameLink = document.getElementById("colorSchemeNameLink")
    if (colorSchemeNameLink) {
        colorSchemeNameLink.href = "https://4bitcss.com/" + foundScheme;
    }

    var schemeSelector = document.getElementById("schemeSelector");
    if (schemeSelector) {
        schemeSelector.value = foundScheme;
    }
}

function GetCSSVariable(name) {
    var root = document.querySelector(":root");
    var rootStyle = getComputedStyle(root);
    return rootStyle.getPropertyValue(name);
}

function saveTheme() {
    var fourBitCssLink = document.getElementById("4bitcss");
    if (! fourBitCssLink) {
        throw "Must have a stylesheet link with the id '4bitcss'"
    }
    if (typeof(Storage) == "undefined") {
        throw "Cannot save themes without HTML5 Local Storage"
    }

    localStorage.setItem("savedThemeLink", fourBitCssLink.themeName);
}

function loadTheme() {
    if (typeof(Storage) == "undefined") {
        throw "Cannot save themes without HTML5 Local Storage"
    }
    var previouslySaved = localStorage.getItem("savedThemeLink");
    if (previouslySaved) {
        SetColorScheme(previouslySaved);
    }
    for (arg in arguments) {
        if (arguments[arg].value) {
            arguments[arg].value = previouslySaved;
        }
    }
}
"@    
}
