# 📊 APEX Interactive Report Context Menu - Complete Implementation Guide

## 📑 Table of Contents
1. [Approach 1: Dynamic Column Names](#approach-1-dynamic-column-names)
2. [Approach 2: Static Column Names](#approach-2-static-column-names)
3. [Approach 3: Name Column Only](#approach-3-name-column-only)

# 🔄 Approach 1: Dynamic Column Names
> Context Menu for ALL COLUMNS with dynamic column names

## Required Files
### 📜 JavaScript File URL
```javascript
https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.js
```

### 🎨 CSS File URL
```css
https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.css
-- keep in comment <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.css">
```

## Implementation
### 💻 Function and Global Variable Declaration
```javascript
function initInteractiveReportContextMenu(reportId) {
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
```

### ▶️ Execute when Page Loads
```javascript
apex.jQuery(document).ready(function() {
    initInteractiveReportContextMenu('IR_1');
});
```

### 🎯 Inline CSS
```css
.context-menu-list {
    z-index: 9999 !important;
}

.context-menu-icon.context-menu-close-icon::before {
    content: "\2716";  /* Unicode for multiplication sign (×) which can act as a close icon */
    font-size: 14px;
    color: red;
    margin-right: 5px;
}
```

# 📋 Approach 2: Static Column Names
> Context Menu for ALL COLUMNS without dynamic column names

## Required Files
### 📜 JavaScript File URL
```javascript
https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.js
```

### 🎨 CSS File URL
```css
https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.css
-- keep in comment <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.css">
```

## Implementation
### 💻 Function and Global Variable Declaration
```javascript
function initInteractiveReportContextMenu(reportId) {
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

```

### ▶️ Execute when Page Loads
```javascript
apex.jQuery(document).ready(function() {
    initInteractiveReportContextMenu('IR_1');
});
```

### 🎯 Inline CSS
```css
.context-menu-list {
    z-index: 9999 !important;
}

.context-menu-icon.context-menu-close-icon::before {
    content: "\2716";  /* Unicode for multiplication sign (×) which can act as a close icon */
    font-size: 14px;
    color: red;
    margin-right: 5px;
}
```

# 👤 Approach 3: Name Column Only
> Context Menu for the Content and Clipboard and REDIRECT_TO_PAGE_46

## Required Files
### 📜 JavaScript File URL
```javascript
https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.js
```

### 🎨 CSS File URL
```css
https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.css
-- keep in comment <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.css">
```

## Implementation
### 💻 Function and Global Variable Declaration
```javascript
function initInteractiveReportContextMenu(reportId) {
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



```

### ▶️ Execute when Page Loads
```javascript
apex.jQuery(document).ready(function() {
    initInteractiveReportContextMenu('IR_1');
});
```

### 🎯 Inline CSS
```css
.context-menu-list {
    z-index: 9999 !important;
}

.context-menu-icon.context-menu-close-icon::before {
    content: "\2716";  /*Unicode for multiplication sign (×) which can act as a close icon */
    font-size: 14px;
    color: red;
    margin-right: 5px;
}
```

### 🔄 AJAX Callback
```sql
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
```

## 🔍 Key Differences Between Approaches
1. **Approach 1**: 
   - ✨ Shows dynamic column names
   - 📊 Works for all columns
   - 🏷️ Display includes column name in menu

2. **Approach 2**:
   - 📋 Generic implementation for all columns
   - 🔤 Fixed "Cell content" label
   - 🌐 Works across all columns

3. **Approach 3**:
   - 👤 Name column specific
   - ⚡ Includes specialized messaging
   - 🚫 Blocks other columns
   - 🔄 Includes AJAX redirect functionality
