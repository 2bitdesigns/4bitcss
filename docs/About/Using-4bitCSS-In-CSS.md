---
layout: none
---

<h3 style='text-align:center'>CSS</h3>

~~~css
.MyCustomClass {
    color: var(--cyan);
    border-color: var(--blue)
}    
~~~

<div style='text-align:center'>
<style>
.MyCustomClass {
    color: var(--cyan);
    border: 1px solid var(--blue);
}
</style>
<div class='MyCustomClass'>cyan with blue border</div>
</div>
<script>hljs.highlightAll();</script>