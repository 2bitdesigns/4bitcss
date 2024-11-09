---
layout: none
---

<h3 style='text-align:center'>SVG</h3>

4bitcss classes can also be used within SVG.

Use `-stroke` classes to control the color for lines, and `-fill` classes to define the color used to fill in shapes.

You can refer to colors by name or ANSI number (0-15).

~~~svg
    <svg
        xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 100 100"
        height="20%" width="20%">
        <circle 
            r="48%" cx="50%" cy="50%"
            class="brightRed-stroke red-fill" />
        <circle 
            r="42%" cx="50%" cy="50%"
            class="brightYellow-stroke yellow-fill" />
        <circle 
            r="36%" cx="50%" cy="50%"
            class="brightGreen-stroke green-fill" />
        <circle 
            r="30%" cx="50%" cy="50%"
            class="brightBlue-stroke blue-fill" />
        <circle 
            r="24%" cx="50%" cy="50%"
            class="brightCyan-stroke cyan-fill" />
        <circle 
            r="18%" cx="50%" cy="50%"
            class="brightPurple-stroke purple-fill" />
        <circle 
            r="12%" cx="50%" cy="50%"
            class="brightBlack-stroke black-fill" />
        <circle 
            r="6%" cx="50%" cy="50%"
            class="brightWhite-stroke white-fill" />
    </svg>    
~~~

<div style='text-align:center'>
<svg
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 100 100"
    height="20%" width="20%">
    <circle 
        r="48%" cx="50%" cy="50%"
        class="brightRed-stroke red-fill" />
    <circle 
        r="42%" cx="50%" cy="50%"
        class="brightYellow-stroke yellow-fill" />
    <circle 
        r="36%" cx="50%" cy="50%"
        class="brightGreen-stroke green-fill" />
    <circle 
        r="30%" cx="50%" cy="50%"
        class="brightBlue-stroke blue-fill" />
    <circle 
        r="24%" cx="50%" cy="50%"
        class="brightCyan-stroke cyan-fill" />
    <circle 
        r="18%" cx="50%" cy="50%"
        class="brightPurple-stroke purple-fill" />
    <circle 
        r="12%" cx="50%" cy="50%"
        class="brightBlack-stroke black-fill" />
    <circle 
        r="6%" cx="50%" cy="50%"
        class="brightWhite-stroke white-fill" />
</svg>

</div>
<script>hljs.highlightAll();</script>