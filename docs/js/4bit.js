var defaultTheme = "Konsolas";
function GetColorSchemeList() {
    return ['3024Day','3024Night','Abernathy','Adventure','AdventureTime','Afterglow','Alabaster','AlienBlood','Andromeda','AppleClassic','arcoiris','Argonaut','Arthur','AtelierSulphurpool','Atom','AtomOneLight','Aurora','ayu_light','ayu','AyuMirage','BananaBlueberry','Batman','BelafonteDay','BelafonteNight','BirdsOfParadise','Blazer','BlueBerryPie','BlueDolphin','BlueMatrix','BlulocoDark','BlulocoLight','Borland','Breeze','BrightLights','Broadcast','Brogrammer','BuiltinDark','BuiltinLight','BuiltinPastelDark','BuiltinSolarizedDark','BuiltinSolarizedLight','BuiltinTangoDark','BuiltinTangoLight','C64','Calamity','catppuccin-frappe','catppuccin-latte','catppuccin-macchiato','catppuccin-mocha','CGA','Chalk','Chalkboard','ChallengerDeep','Chester','Ciapre','CLRS','Cobalt2','CobaltNeon','coffee_theme','CrayonPonyFish','Cyberdyne','cyberpunk','Dark+','darkermatrix','darkmatrix','DarkPastel','Darkside','deep','Desert','DimmedMonokai','Django','DjangoRebornAgain','DjangoSmooth','DoomOne','DoomPeacock','DotGov','Dracula','Dracula+','duckbones','DuotoneDark','Earthsong','Elemental','Elementary','ENCOM','Espresso','EspressoLibre','Everblush','Fahrenheit','Fairyfloss','Fideloper','FirefoxDev','Firewatch','FishTank','Flat','Flatland','Floraverse','ForestBlue','Framer','FrontEndDelight','FunForrest','Galaxy','Galizur','Github','GitHubDark','Glacier','Grape','Grass','Grey-green','GruvboxDark','GruvboxDarkHard','GruvboxLight','Guezwhoz','Hacktober','Hardcore','Harper','HaX0R_BLUE','HaX0R_GR33N','HaX0R_R3D','Highway','HipsterGreen','Hivacruz','Homebrew','Hopscotch.256','Hopscotch','Hurtado','Hybrid','IC_Green_PPL','IC_Orange_PPL','iceberg-dark','iceberg-light','idea','idleToes','IR_Black','iTerm2DarkBackground','iTerm2Default','iTerm2LightBackground','iTerm2PastelDarkBackground','iTerm2Smoooooth','iTerm2SolarizedDark','iTerm2SolarizedLight','iTerm2TangoDark','iTerm2TangoLight','JackieBrown','Japanesque','Jellybeans','JetBrainsDarcula','jubi','kanagawabones','Kibble','Kolorit','Konsolas','LabFox','Laser','LaterThisEvening','Lavandula','LiquidCarbon','LiquidCarbonTransparent','LiquidCarbonTransparentInverse','lovelace','ManPage','Mariana','Material','MaterialDark','MaterialDarker','MaterialDesignColors','MaterialOcean','Mathias','matrix','Medallion','midnight-in-mojave','Mirage','Misterioso','Molokai','MonaLisa','MonokaiRemastered','MonokaiSoda','MonokaiVivid','N0tch2k','neobones_dark','neobones_light','Neon','Neopolitan','Neutron','NightLionv1','NightLionv2','NightOwlishLight','niji','NocturnalWinter','nord-light','nord','Novel','Obsidian','Ocean','Oceanic-Next','OceanicMaterial','Ollie','OneHalfDark','OneHalfLight','OperatorMonoDark','OvernightSlumber','PaleNightHC','Pandora','ParaisoDark','PaulMillr','PencilDark','PencilLight','Peppermint','PiattoLight','Pnevma','PoppingandLocking','primary','Pro','ProLight','purplepeter','PurpleRain','Rapture','Raycast_Dark','Raycast_Light','rebecca','RedAlert','RedPlanet','RedSands','Relaxed','Retro','Rippedcasts','rose-pine-dawn','rose-pine-moon','rose-pine','Rouge2','Royal','Ryuuko','Sakura','ScarletProtocol','SeafoamPastel','SeaShells','seoulbones_dark','seoulbones_light','Seti','shades-of-purple','Shaman','Slate','SleepyHollow','Smyck','Snazzy','SoftServer','SolarizedDarcula','SolarizedDark-Patched','SolarizedDarkHigherContrast','Spacedust','SpaceGray','SpaceGrayEighties','SpaceGrayEightiesDull','Spiderman','Spring','Square','Sublette','Subliminal','Sundried','Symfonic','synthwave-everything','synthwave','SynthwaveAlpha','TangoAdapted','TangoHalfAdapted','Teerb','TerminalBasic','ThayerBright','TheHulk','TinaciousDesign(Dark)','TinaciousDesign(Light)','tokyonight-day','tokyonight-storm','tokyonight','Tomorrow','TomorrowNight','TomorrowNightBlue','TomorrowNightBright','TomorrowNightBurns','TomorrowNightEighties','ToyChest','Treehouse','Twilight','Ubuntu','UltraDark','UltraViolent','UnderTheSea','Unikitty','Urple','Vaughn','VibrantInk','vimbones','VioletDark','VioletLight','WarmNeon','Wez','Whimsy','WildCherry','wilmersdorf','Wombat','Wryan','zenbones_dark','zenbones_light','zenbones','Zenburn','zenburned','zenwritten_dark','zenwritten_light']
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
