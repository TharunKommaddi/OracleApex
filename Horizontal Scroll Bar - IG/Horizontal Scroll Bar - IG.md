<h1>Horizontal Scroll Bar</h1>


<h2>Function and Global Variable Declaration</h2>

<pre data-line="1" class="language-js line-numbers"><code class="language-js">/*** Für Horizontalen Scrollbalken ***/
function resizeMainContent() {
    var height = $(window).height(); // start with the window height
    // subtract off all the fixed height regions and header
        
    height -= $(".t-Header").outerHeight(); // Kopfzeile und Menüleiste

    height -= 65 // Abzug für Header da  $(".t-Region-header").outerHeight kein Ergebnis liefert
    
    height -= $('.t-Footer').height(); // Fußzeile 
    
    height -= 65; // Zusätzlicher Abzug
    
    
    // if the screen is very small then the responsive features of UT kick in
    // and the height set on the notes region for example gets ignored.
    // So just incase set a minimum height for the report
    if ( height < 200 ) {
        height = 200;
    }
    console.log(height);
    // then set the height of the regions that will stretch
    // setOuterHeight takes into consideration the borders etc. on the grid itself.
    apex.util.setOuterHeight(apex.region("ig-status").widget(), height);
    
}
</code></pre>


<h2>Execute when Page Loads</h2>

<pre data-line="1" class="language-js line-numbers"><code class="language-js">/* Für Horizontalen Scrollbalken */
$(window).on("apexwindowresized", resizeMainContent);
resizeMainContent();
// Bugfix für APEX 18.1
$( "#ig-status" ).on( "interactivegridreportsettingschange interactivegridreportchange", function( event, data ) {
    apex.region("ig-status").widget().interactiveGrid("resize");
} );
</code></pre>


<h2>Inline CSS</h2>

<pre data-line="1" class="language-css line-numbers"><code class="language-css">
/* Für Horizontalen Scrollbalken */
/* If trying to maximize the screen space available for the wide grid region
 * you may not want much or any padding on the main body.
 */

 /* please comment only the .t-Body-contentInner if it disturbs the page layout
/* .t-Body-contentInner {
    padding: 0;
} */
/* The region heights will be set in JavaScript so don't want the body to
 * have an explicit height
   TsTh: Geändert von initial nach inherit als Bugix für den IE 11
*/
.t-Body-content {
    min-height: inherit !important;
}
/* If the main page never scrolls then there is little point in a back to top button
 * You could hide the while footer (.t-Footer) but at that point you may want
 * to look at creating a custom page template such as 'Fit to Window' that doesn't have a footer.
 */
.t-Footer-top {
    display: none;
}
 
/* Bugfix IE 11 */
div.t-Body {
    margin-bottom: 0px !important;
}
</code></pre>



