<style>
    menu {
      display: flex;
      flex: 1 1 0;
      justify-content: center;
    }
    menu button {
        font-size: 1.1em;
    }
</style>

<menu class='centeredText' hx-target='#HowToContent' hx-select='#PageContent'>
    <button hx-get='/About/4bitCSS'>About</button>
    <button hx-get='/About/4bitCSS-Animated-Palette' hx-trigger="load,click">Animation</button>
    <button hx-get='/About/Using-4bitCSS-In-CSS'>CSS</button>
    <button hx-get='/About/Using-4bitCSS-In-HTML'>HTML</button>
    <button hx-get='/About/Using-4bitCSS-In-JavaScript'>JavaScript</button>
    <button hx-get='/About/Using-4bitCSS-In-SVG'>SVG</button>
    <button hx-get='/About/4bitCSS-Color-Table'>Table</button>
</menu>

<br/>
<style>
.smooth {
  transition: all 1s ease-in;
}
</style>
<div id='HowToContent' class='smooth'>

</div>