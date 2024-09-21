
# APPROACH 1 FOR ALL COLUMNS with dynamic column names

<h1>Context Menu for the Content and Clipboard</h1>

<h2>JavaScript</h2>
<h3>File URLs</h3>
<pre data-line="1" class="language-js line-numbers"><code class="language-js">https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.js
</code></pre>

<h2>Function and Global Variable Declaration</h2>

<pre data-line="1" class="language-js line-numbers"><code class="language-js">function initInteractiveReportContextMenu(reportId) {
    var report = apex.region(reportId);
    
    $('#' + reportId).contextMenu({
        selector: 'td',
        build: function($trigger, e) {
        var $cell = $trigger;
        var cellData = $cell.text().trim();
        var columnIndex = $cell.index();
        var $headerCell = $('#' + reportId + ' th').eq(columnIndex);
        var columnName = $headerCell.text().trim();
            
            return {
                callback: function(key, options) {
                    switch(key) {
                        case "copy":
                            navigator.clipboard.writeText(cellData);
                            apex.message.showPageSuccess("Text copied to clipboard");
                            break;
                        case "close":
                            $.contextMenu('hide');
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
            "content": {name: columnName + ": " + cellData, disabled: true},
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
    initInteractiveReportContextMenu('IR_1');
});
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



# APPROACH 2 FOR ALL COLUMNS with not dynamic column names

<h1>Context Menu for the Content and Clipboard</h1>

<h2>JavaScript</h2>
<h3>File URLs</h3>
<pre data-line="1" class="language-js line-numbers"><code class="language-js">https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.js
</code></pre>

<h2>Function and Global Variable Declaration</h2>

<pre data-line="1" class="language-js line-numbers"><code class="language-js">function initInteractiveReportContextMenu(reportId) {
    var report = apex.region(reportId);
    
    $('#' + reportId).contextMenu({
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
                            $.contextMenu('hide');
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
    initInteractiveReportContextMenu('IR_1');
});
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

# APPROACH 3 FOR NAME COLUMN

<h1>Context Menu for the Content and Clipboard and REDIRECT_TO_PAGE_46</h1>

<h2>JavaScript</h2>
<h3>File URLs</h3>
<pre data-line="1" class="language-js line-numbers"><code class="language-js">https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.js
</code></pre>

<h2>Function and Global Variable Declaration</h2>

<pre data-line="1" class="language-js line-numbers"><code class="language-js">function initInteractiveReportContextMenu(reportId) {
    var report = apex.region(reportId);
    
    $('#' + reportId).contextMenu({
        selector: 'td',
        build: function($trigger, e) {
            var $cell = $trigger;
            var cellData = $cell.text().trim();
            var columnIndex = $cell.index();
            var $headerCell = $cell.closest('table').find('th').eq(columnIndex);
            var columnName = $headerCell.text().trim();
            
            // Only show context menu for the "Name" column
            if (columnName !== "Name") {
                return false;
            }
            
            return {
                callback: function(key, options) {
                    switch(key) {
                        case "copy":
                            navigator.clipboard.writeText(cellData);
                            apex.message.showPageSuccess("Name copied to clipboard");
                            break;
                        case "close":
                            $.contextMenu('hide');
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
                    "content": {name: "Name: " + cellData, disabled: true},
                    "copy": {name: "Copy name to clipboard", icon: "copy"},
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
    initInteractiveReportContextMenu('IR_1');
});
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





