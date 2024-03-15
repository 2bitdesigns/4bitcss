~~~PipeScript{
$colors = 'Black', 'Red', 'Green', 'Yellow', 'Blue', 'Purple', 'Cyan', 'White',
    'BrightBlack', 'BrightRed', 'BrightGreen', 'BrightYellow', 'BrightBlue', 'BrightPurple', 'BrightCyan', 'BrightWhite'
[PSCustomObject]@{    
    Table = @(foreach ($n in 0..15) {
        [PSCustomObject]@{
            "CSS Class"  = "ANSI$n or $($colors[$n])"            
            Color        = $colors[$n]
            Sample       = "<span class='ANSI$n'>*</span>"
        }
    })
}

}
~~~

