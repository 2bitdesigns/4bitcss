if ($env:GITHUB_WORKSPACE) {
    git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git | Out-Host

    $jsonFiles = Get-ChildItem -Path iTerm2-Color-Schemes -Recurse -Filter *.json  |
        Where-Object Fullname -like '*terminal*' | 
        Select-Object -Skip 2    
} else {
    $jsonFiles = Get-ChildItem $home\documents\git\iTerm2-Color-Schemes -Recurse -Filter *.json  |
        Where-Object Fullname -like '*terminal*' | 
        Select-Object -Skip 2
}


Import-Module .\4bitcss.psd1 -Global

foreach ($jsonFile in $jsonFiles) {
    $jsonObject = [IO.File]::ReadAllText($jsonFile.FullName) | ConvertFrom-Json

    if (-not $jsonObject.Name) { continue }
    if ($jsonObject.Name -match '^\{') { continue }
    $jsonObject | Export-4BitCSS -OutputPath (Join-Path $PSScriptRoot css)
    $jsonObject | Export-4BitCSS -OutputPath (Join-Path $PSScriptRoot docs)
}