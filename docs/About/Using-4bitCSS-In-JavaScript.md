---
---

<h3 style='text-align:center'>JavaScript</h3>

Because 4bitCSS sets CSS root variables, you can _get_ a value by using [getPropertyValue](https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleDeclaration/getPropertyValue)

~~~javascript
var body = document.querySelector("body");
var foregroundValue = getComputedStyle(body).getPropertyValue('--foreground');
~~~

To set a value, we will want to be a little more clever.

We can set use [setProperty](https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleDeclaration/setProperty) to change the value.

In order to ensure that it can still be modified when the stylesheet changes, we'll want to find the stylesheet first.

~~~javascript
// Get our stylesheet
var FourBitCssLink = document.getElementById("4bitcss");
// change the property in the first CSS rule.
FourBitCssLink.sheet.cssRules[0].style.setProperty("--foreground","#ffffff")
~~~

If we want to know when the property changes, we'll need to use a [MutationObserver](https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver)

~~~javascript
var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutationRecord) {
        console.log('style changed!');
        ForegroundPreview.value = getComputedStyle(FourBitCssLink).getPropertyValue('--foreground');
        ForegroundPreviewText.innerText = "Foreground " + ForegroundPreview.value;
    });
});
~~~

<div style='text-align:center'>
<script>

var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutationRecord) {
        console.log('style changed!');
        ForegroundPreview.value = getComputedStyle(FourBitCssLink).getPropertyValue('--foreground');        
        ForegroundPreviewText.innerText = "Foreground " + ForegroundPreview.value;
        BackgroundPreview.value = getComputedStyle(FourBitCssLink).getPropertyValue('--background');
        BackgroundPreviewText.innerText = "Background " + BackgroundPreview.value;
    });
});

var FourBitCssLink = document.getElementById("4bitcss");
var ForegroundPreview = document.getElementById('ForegroundPreview');
var ForegroundPreviewText = document.getElementById('ForegroundPreviewText')
var BackgroundPreview = document.getElementById('BackgroundPreview');
var BackgroundPreviewText = document.getElementById('BackgroundPreviewText');

observer.observe(FourBitCssLink, { attributes : true, attributeFilter : ['href'] });

var foregroundValue = getComputedStyle(FourBitCssLink).getPropertyValue('--foreground');
ForegroundPreview.value = foregroundValue
ForegroundPreviewText.innerText = "Foreground " + foregroundValue;
ForegroundPreview.addEventListener('change', (event)=>{
    var styleSheet = FourBitCssLink.sheet;
    styleSheet.cssRules[0].style.setProperty("--foreground",event.target.value);
    ForegroundPreviewText.innerText = "Foreground" + ForegroundPreview.value;
});

var backgroundValue = getComputedStyle(FourBitCssLink).getPropertyValue('--background')
BackgroundPreview.value = backgroundValue;
BackgroundPreviewText.innerText = "Background" + backgroundValue;
BackgroundPreview.addEventListener('change', (event)=>{
    var styleSheet = FourBitCssLink.sheet;
    styleSheet.cssRules[0].style.setProperty("--background",event.target.value);
    BackgroundPreviewText.innerText = "Background" + BackgroundPreview.value;
});

</script>
<table>
<tr>
<td>
<input type='color' id='ForegroundPreview' />
</td>
<td>
<label for='ForegroundPreview' id='ForegroundPreviewText'>Foreground</label>
</td>
</tr>
<tr>
<td>
<input type='color' id='BackgroundPreview' />
</td>
<td>
<label for='BackgroundPreview' id='BackgroundPreviewText'>Background</label>
</td>
</tr>
</table>
<script>hljs.highlightAll();</script>