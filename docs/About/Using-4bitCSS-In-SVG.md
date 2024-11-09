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
        <rect
            width="50%" height="50%"
            x="25%" y="25%"
            class="purple-stroke blue-fill" />
        <circle 
            r="25%" cx="50%" cy="50%" 
            class="red-stroke green-fill" />
        <line 
            x1="0%" x2="100%" y1="50%" y2="50%"
            class="purple-stroke" />
    </svg>
~~~

<div style='text-align:center'>
<svg
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 100 100"
    height="20%" width="20%">    
    <rect
        width="50%" height="50%"
        x="25%" y="25%"
        class="purple-stroke blue-fill" />
    <circle 
        r="25%" cx="50%" cy="50%" 
        class="red-stroke green-fill" />
    <line 
        x1="0%" x2="100%" y1="50%" y2="50%"
        class="purple-stroke" />
</svg>
</div>
<script>hljs.highlightAll();</script>