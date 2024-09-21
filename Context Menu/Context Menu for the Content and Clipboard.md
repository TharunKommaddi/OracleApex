
# APPROACH 1

<h1>Context Menu for the Content and Clipboard</h1>

<h2>JavaScript</h2>
<h3>File URLs</h3>
<pre data-line="1" class="language-js line-numbers"><code class="language-js">https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.js
</code></pre>

<h2>Function and Global Variable Declaration</h2>

<pre data-line="1" class="language-js line-numbers"><code class="language-js">function initInteractiveGridContextMenu(gridId) {
    var grid = apex.region(gridId).widget();
    var gridView = grid.interactiveGrid("getViews", "grid");
    
    gridView.view$.contextMenu({
        selector: 'td',
        build: function($trigger, e) {
            var $cell = $trigger;
            var cellData = $cell.text().trim();
            
            return {
                callback: function(key, options) {
                    switch(key) {
                        case "copy":
                            navigator.clipboard.writeText(cellData);
                            apex.message.showPageSuccess("Text copied to clipboard");
                            break;
                        case "close":
                            // Close the context menu by triggering the hide event
                            $(document).trigger('contextmenu:hide'); 
                            break;
                        // Add more cases here for additional actions
                    }
                },
                /*items: {
                    "content": {name: "Cell content: " + cellData, disabled: true},
                    "copy": {name: "Copy to clipboard", icon: "copy"},
                    "sep1": "---------",  // separator
                    "close": {name: "Close", icon: function() {
                        return 'context-menu-icon context-menu-close-icon';
                    }},
                    // Add more menu items here as needed
                },
                */

                items: {
                    "close": {name: "Close", icon: function() {
                        return 'context-menu-icon context-menu-close-icon';
                    }},
                    "sep1": "---------",  // separator
                    "content": {name: "Cell content: " + cellData, disabled: true},
                    "copy": {name: "Copy to clipboard", icon: "copy"},
                    // Add more menu items here as needed
                },
                position: function(opt, x, y) {
                    var $menu = opt.$menu;
                    var menuHeight = $menu.outerHeight();
                    var menuWidth = $menu.outerWidth();
                    var windowHeight = $(window).height();
                    var windowWidth = $(window).width();
                    
                    if (x + menuWidth > windowWidth) {
                        x -= menuWidth;
                    }
                    
                    if (y + menuHeight > windowHeight) {
                        y -= menuHeight;
                    }
                    
                    opt.$menu.css({top: y, left: x});
                }
            };
        }
    });
}

</code></pre>


<h2>Execute when Page Loads</h2>

<pre data-line="1" class="language-js line-numbers"><code class="language-js">apex.jQuery(document).ready(function() {
    // Replace 'YOUR_INTERACTIVE_GRID_ID' with the actual static ID of your Interactive Grid
    initInteractiveGridContextMenu('ig-status');
});


/*
apex.jQuery(document).ready(function() {
    if (typeof apex.jQuery.fn.contextMenu === 'function') {
        console.log('jQuery contextMenu plugin is loaded');
    } else {
        console.error('jQuery contextMenu plugin is not loaded');
    }
});
*/
</code></pre>

<h2>CSS</h2>
<h3>File URLs</h3>
<pre data-line="1" class="language-css line-numbers"><code class="language-css">https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.css
-- keep in comment <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.css">
</code></pre>


<h2>Inline CSS</h2>

<pre data-line="1" class="language-css line-numbers"><code class="language-css">.context-menu-list {
    z-index: 9999 !important;
}


.context-menu-icon.context-menu-close-icon::before {
    content: "\2716";  /* Unicode for multiplication sign (×) which can act as a close icon */
    font-size: 14px;
    color: red;
    margin-right: 5px;
}
</code></pre>

# APPROACH 2

<h1>Context Menu for the Content and Clipboard and REDIRECT_TO_PAGE_46</h1>

<h2>JavaScript</h2>
<h3>File URLs</h3>
<pre data-line="1" class="language-js line-numbers"><code class="language-js">https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.js
</code></pre>

<h2>Function and Global Variable Declaration</h2>

<pre data-line="1" class="language-js line-numbers"><code class="language-js">
function initInteractiveGridContextMenu(gridId) {
    var grid = apex.region(gridId).widget();
    var gridView = grid.interactiveGrid("getViews", "grid");
    
    gridView.view$.contextMenu({
        selector: 'td',
        build: function($trigger, e) {
            var $cell = $trigger;
            var cellData = $cell.text().trim();
            
            return {
                callback: function(key, options) {
                    switch(key) {
                        case "copy":
                            navigator.clipboard.writeText(cellData);
                            apex.message.showPageSuccess("Text copied to clipboard");
                            break;
                        case "close":
                            $(document).trigger('contextmenu:hide'); 
                            break;
                        case "redirect":
                            apex.server.process(
                                'REDIRECT_TO_PAGE_46',
                                {x01: cellData},
                                {
                                    success: function(pData) {
                                        if (pData.url) {
                                            window.open(pData.url, '_blank');
                                        }
                                    },
                                    error: function(jqXHR, textStatus, errorThrown) {
                                        apex.message.showErrors([{
                                            type: "error",
                                            location: ["page"],
                                            message: "Error occurred: " + errorThrown,
                                            unsafe: false
                                        }]);
                                    }
                                }
                            );
                            break;
                    }
                },
                items: {
                    "close": {name: "Close", icon: function() {
                        return 'context-menu-icon context-menu-close-icon';
                    }},
                    "sep1": "---------",
                    "content": {name: "Cell content: " + cellData, disabled: true},
                    "copy": {name: "Copy to clipboard", icon: "copy"},
                    "redirect": {name: "Go to Page 46 (New Tab)", icon: "fa-external-link"}
                },
                position: function(opt, x, y) {
                    var $menu = opt.$menu;
                    var menuHeight = $menu.outerHeight();
                    var menuWidth = $menu.outerWidth();
                    var windowHeight = $(window).height();
                    var windowWidth = $(window).width();
                    
                    if (x + menuWidth > windowWidth) {
                        x -= menuWidth;
                    }
                    
                    if (y + menuHeight > windowHeight) {
                        y -= menuHeight;
                    }
                    
                    opt.$menu.css({top: y, left: x});
                }
            };
        }
    });
}



</code></pre>


<h2>Execute when Page Loads</h2>

<pre data-line="1" class="language-js line-numbers"><code class="language-js">apex.jQuery(document).ready(function() {
    
    initInteractiveGridContextMenu('ig-status');
});


/*
apex.jQuery(document).ready(function() {
    if (typeof apex.jQuery.fn.contextMenu === 'function') {
        console.log('jQuery contextMenu plugin is loaded');
    } else {
        console.error('jQuery contextMenu plugin is not loaded');
    }
});
*/
</code></pre>

<h2>CSS</h2>
<h3>File URLs</h3>
<pre data-line="1" class="language-css line-numbers"><code class="language-css">https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.css
-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.css">

</code></pre>


<h2>Inline CSS</h2>

<pre data-line="1" class="language-css line-numbers"><code class="language-css">.context-menu-list {
    z-index: 9999 !important;
}


.context-menu-icon.context-menu-close-icon::before {
    content: "\2716";  /*Unicode for multiplication sign (×) which can act as a close icon */
    font-size: 14px;
    color: red;
    margin-right: 5px;
}


</code></pre>

<h2>AJAX Call back</h2>


<pre data-line="1" class="language-sql line-numbers"><code class="language-sql">
declare

lURL VARCHAR2(4000);
lID  VARCHAR2(100);
BEGIN
    -- Assuming lID should be set to the cell data passed from JavaScript
    lID := apex_application.g_x01;
    apex_json.open_object;
    lURL := apex_page.get_url(p_page => 46, p_clear_cache => 46);
    
    apex_json.write('url', lURL);
    apex_json.close_object;


    
    
END;
</code></pre>





