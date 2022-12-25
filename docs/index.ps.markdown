<h2 style='text-align:center'>
    <span class='ColorSchemeName' />
</h2>

~~~PipeScript{
$colors = 'Black', 'Red', 'Green', 'Yellow', 'Blue', 'Purple', 'Cyan', 'White',
    'BrightBlack', 'BrightRed', 'BrightGreen', 'BrightYellow', 'BrightBlue', 'BrightPurple', 'BrightCyan', 'BrightWhite'
[PSCustomObject]@{    
    Table = @(foreach ($n in 0..15) {
        [PSCustomObject]@{
            "ANSI Code"  = $n
            Color      = $colors[$n]
            Sample     = "<span class='ANSI$n'>*</span>"
        }
    })
}

}
~~~

<div class='centeredText'>
~~~PipeScript{
Get-Content .\4bitpreview.svg |
    Select-Object -Skip 1
}
~~~
</div>
