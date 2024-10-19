---
stylesheet: /Desert/Desert.css
colorSchemeName: Desert
colorSchemeFileName: Desert
image: /Desert/Desert.png
description: Desert color scheme
permalink: /Desert/
---

<h2 style='text-align:center'>
    <a id='colorSchemeNameLink' href='#'>
        <span class='ColorSchemeFileName'></span>
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

