---
layout: none
---

<h3 style='text-align:center'>JavaScript</h3>

~~~javascript
var body = document.querySelector("body");
var fourBitCssLink = document.getElementById("4bitcss");
var foregroundValue = getComputedStyle(body).getPropertyValue('--foreground');
var colorHexPreview = document.getElementById('ColorHexPreview');
colorHexPreview.value = fourBitCssLink.style.getPropertyValue('--foreground');
var colorHexPreviewText = document.getElementById('ColorHexPreviewText')
colorHexPreviewText.value = foregroundValue;
~~~

<div style='text-align:center'>
<script>

var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutationRecord) {
        console.log('style changed!');
    });
});

var colorHexPreview = document.getElementById('ColorHexPreview');
var fourBitCssLink = document.getElementById("4bitcss");
observer.observe(fourBitCssLink, { attributes : true, attributeFilter : ['href'] });

fourBitCssLink.addEventListener('change', (event)=>{
    colorHexPreview.value = getComputedStyle(fourBitCssLink).getPropertyValue('--foreground');
    colorHexPreviewText.value = colorHexPreview.value;
});
colorHexPreview.value = getComputedStyle(fourBitCssLink).getPropertyValue('--foreground');
colorHexPreview.addEventListener('change', (event)=>{
    var styleSheet = fourBitCssLink.sheet;
    styleSheet.cssRules[0].style.setProperty("--foreground",event.target.value);
});
var colorHexPreviewText = document.getElementById('ColorHexPreviewText')
colorHexPreviewText.value = colorHexPreview.value;

</script>
<input type='color' id='ColorHexPreview' />
<input type='text' id='ColorHexPreviewText' />
</div>
<script>hljs.highlightAll();</script>