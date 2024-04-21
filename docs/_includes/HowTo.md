---

~~~html
<span class='Black White-Background'>
    Black / White
</span>
~~~

<div style='text-align:center'>
    <span class='Black White-Background'>Black/White</span>
</div>

---

~~~svg
<svg viewBox="0 0 1 1" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg" width="50%">
    <rect width="100%" height="100%" class="purple-stroke blue-fill" />
    <circle r="1" class="red-stroke green-fill"/>
</svg>
~~~

<svg viewBox="0 0 1 1" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg">
    <rect width="100%" height="100%" class="purple-stroke blue-fill" />
    <circle r="1" class="red-stroke green-fill"/>
</svg>

---

## Instructions:

1. Link to the CDN
2. Add CSS Classes
3. Enjoy

https://cdn.jsdelivr.net/gh/2bitdesigns/4bitcss@latest/css/<span class='ColorSchemeFileName' />

### Notes:

* Either ANSI`$Number` or `ColorName` work (for the sake of sanity)
* Every color comes with a `-fill` and `-stroke` class (for SVGs and Canvases)
* Every color comes with a `-background` class (for brighter backgrounds)
* Background and foreground should be set automatically