<h2 style='text-align:center'>
    <a id='colorSchemeNameLink' href='#'>
        <span class='ColorSchemeFileName' />
    </a>
</h2>

<div class='centeredText'>
~~~PipeScript{
Get-Content .\4bitpreview.svg |
    Select-Object -Skip 1
}
~~~
</div>

<div class='centeredText'>
    <a id='downloadSchemeLink' class='padded'>
{% include download-icon.svg %}
    </a>
    <a id='cdnSchemeLink' class='padded'>
{% include download-cloud-icon.svg %}
    </a>
    <a id='feelingLucky' href="javascript:feelingLucky(document.getElementById('themeSelector'))" class='padded'>
{% include shuffle-icon.svg %}
    </a>

</div>

~~~PipeScript{
$colors = 'Black', 'Red', 'Green', 'Yellow', 'Blue', 'Purple', 'Cyan', 'White',
    'BrightBlack', 'BrightRed', 'BrightGreen', 'BrightYellow', 'BrightBlue', 'BrightPurple', 'BrightCyan', 'BrightWhite'
[PSCustomObject]@{    
    Table = @(foreach ($n in 0..15) {
        [PSCustomObject]@{
            "CSS Class"  = "ANSI$n"
            Color        = $colors[$n]
            Sample       = "<span class='ANSI$n'>*</span>"
        }
    })
}

}
~~~
