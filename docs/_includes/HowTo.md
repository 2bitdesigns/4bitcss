### CDN 

> https://cdn.jsdelivr.net/gh/2bitdesigns/4bitcss@latest/css/<span class='ColorSchemeFileName' />

* Background and foreground should be set automatically
* Most HTML elements should match!

### HTML

* Either ANSI`$Number` or `ColorName` work (for the sake of sanity)
* Every color comes with a `-background` class (for brighter backgrounds)

---

~~~html
<div style='text-align:center'>
    <span class='ANSI9 ANSI0-background'>BrightRed on Black</span>
    <br/>
    <span class='black white-background'>Black on White</span>
</div>
~~~

---

<div style='text-align:center'>
    <span class='ANSI9 ANSI0-background'>BrightRed on Black</span>
    <br/>
    <span class='black white-background'>Black on White</span>
</div>

---

### SVG

* Use `-fill` classes to fill a shape
* Use `-stroke` classes to color lines and borders

---

~~~svg
<svg viewBox="0 0 100 100" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg" height="15%" width="15%" >
    <rect width="50%" height="50%" x="25%" y="25%" class="blue-fill" />
    <circle r="25%" cx="50%" cy="50%" class="red-stroke green-fill" />
    <line x1="0%" x2="100%" y1="50%" y2="50%" class="purple-stroke" />
</svg>
~~~

---

<div style='text-align:center'>
    <svg viewBox="0 0 100 100" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg" height="15%" width="15%" >        
        <rect width="50%" height="50%" x="25%" y="25%" class="blue-fill" />
        <circle r="25%" cx="50%" cy="50%" class="red-stroke green-fill" />
        <line x1="0%" x2="100%" y1="50%" y2="50%" class="purple-stroke" />
    </svg>
</div>

---