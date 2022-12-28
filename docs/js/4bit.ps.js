var defaultTheme = "Konsolas";
function themeList() {
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
    var themes = themeList();
    var randomNumber = Math.floor(Math.random() * themes.length);
    var fourBitCssLink = document.getElementById("4bitcss");
    if (! fourBitCssLink) {
        throw "Must have a stylesheet link with the id '4bitcss'"
    }
    fourBitCssLink.href = "/" + themes[randomNumber] + ".css";

    for (arg in arguments) {
        if (arguments[arg].value) {
            arguments[arg].value = themes[randomNumber];
        }
    }
}

function switchTheme(themeName) {
    var fourBitCssLink = document.getElementById("4bitcss");
    if (! fourBitCssLink) {
        throw "Must have a stylesheet link with the id '4bitcss'"
    }
    var foundTheme = themeList().find(element => element == themeName);
    if (! foundTheme) {
        throw ("Theme '" + themeName + "' does not exist");
    }
    fourBitCssLink.href = "/" + foundTheme + ".css";
    fourBitCssLink.themeName = foundTheme;
    var downloadLink = document.getElementById("downloadSchemeLink");
    if (downloadLink) {
        downloadLink.href = "/" + foundTheme + ".css";
    }
    var cdnLink = document.getElementById("cdnSchemeLink")
    if (cdnLink) {
        cdnLink.href = "https://cdn.jsdelivr.net/gh/2bitdesigns/4bitcss@latest/css/" + foundTheme + ".css";
    }

    var colorSchemeNameLink = document.getElementById("colorSchemeNameLink")
    if (colorSchemeNameLink) {
        colorSchemeNameLink.href = "https://4bitcss.com/" + foundTheme;
    }
}

function getCSSVariable(name) {
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
        switchTheme(previouslySaved);
    }
    else {
        switchTheme(getCSSVariable("--name").trim("'"));
    }
    for (arg in arguments) {
        if (arguments[arg].value) {
            arguments[arg].value = previouslySaved;
        }
    }
}