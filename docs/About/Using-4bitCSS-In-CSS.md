---
layout: default
---

<h3 style='text-align:center'>CSS</h3>

At the heart of any of the palettes are CSS variable definitions that mimic a console color palette.

You can use these CSS variables wherever you'd like.

~~~css
.MyCustomClass {
    color: var(--red);
    border: 1px solid var(--green);
}    
~~~

<div style='text-align:center'>
<style>
.MyCustomClass {
    color: var(--red);
    border: 1px solid var(--green);
}
</style>
<div class='MyCustomClass'>red text, green border</div>

You can also refer to colors using a CSS class by name, for example:

<div style='display:grid'>
    <div class='Red'>
Red
    </div>
    <div class='Green'>
Green
    </div>
    <div class='Blue'>
Blue
    </div>
</div>
<script>hljs.highlightAll();</script>