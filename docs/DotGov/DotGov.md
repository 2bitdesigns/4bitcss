---
stylesheet: /DotGov/DotGov.css
colorSchemeName: DotGov
colorSchemeFileName: DotGov
image: /DotGov/DotGov.png
description: DotGov color scheme
permalink: /DotGov/
---

<h2 style='text-align:center'>
    <a id='colorSchemeNameLink' href='#'>
        <span class='ColorSchemeFileName' />
    </a>
</h2>

<div class='centeredText' style='margin-bottom:1%'>
{% include PaletteSelector.html %}
</div>

<div class='centeredText'>
{% include 4bitpreview.svg %}
</div>

<div class='centeredText'>
    <a id='downloadSchemeLink' class='padded'>
{% include download-icon.svg %}
    </a>
    <a id='cdnSchemeLink' class='padded'>
{% include download-cloud-icon.svg %}
    </a>
    <a id='feelingLucky' href="javascript:feelingLucky(document.getElementById('themeSelector'))" class='padded'>
{% include shuffle-icon.svg %}
    </a>    
</div>

{% include ColorTable.md %}

{% include HowTo.md %}

