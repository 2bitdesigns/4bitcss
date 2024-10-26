---
layout: none
---

<h3 style='text-align:center'>JavaScript</h3>

~~~javascript
const body = window.getQuerySelector("body");
var foregroundValue = getComputedStyle(body).getPropertyValue('--foreground');
console.log(foregroundValue);
const colorHexPreview = document.getElementById('ColorHexPreview') 
colorHexPreview.value = foregroundValue;
~~~

<div style='text-align:center'>
<script>
var body = document.querySelector("body");
var foregroundValue = getComputedStyle(body).getPropertyValue('--foreground');
console.log(foregroundValue);
var colorHexPreview = document.getElementById('ColorHexPreview');
colorHexPreview.value = foregroundValue;
var colorHexPreviewText = document.getElementById('ColorHexPreviewText')
colorHexPreviewText.value = foregroundValue;
</script>
<input type='color' id='ColorHexPreview' />
<input type='text' id='ColorHexPreviewText' />
</div>