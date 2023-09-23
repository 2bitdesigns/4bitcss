var defaultTheme = "Konsolas";
function GetColorSchemeList() {
    return [/*{
"'$(
  @($pwd |
    Split-Path |
    Get-ChildItem -Filter *.css |    
    % { $_.Name -replace '\.css$' }
  ) -join "','"
)'"
    }*/]
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