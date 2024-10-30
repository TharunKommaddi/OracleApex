# Interactive Grid Context Menu - Basic Implementation
> Approach 1: Basic Content and Clipboard Functionality

## Table of Contents
1. [Required Dependencies](#1-required-dependencies)
2. [Implementation Steps](#2-implementation-steps)
3. [Code Implementation](#3-code-implementation)
4. [Styling](#4-styling)
5. [Usage Notes](#5-usage-notes)

## 1. Required Dependencies
### CDN Files
#### JavaScript
```javascript
https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.js
```

#### CSS
```css
https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.css
```

## 2. Implementation Steps
1. Add CDN references to your application
2. Implement the JavaScript functions
3. Add required CSS
4. Initialize on page load

## 3. Code Implementation
### Core Function
```javascript
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
                    }
                },
                items: {
                    "close": {
                        name: "Close", 
                        icon: function() {
                            return 'context-menu-icon context-menu-close-icon';
                        }
                    },
                    "sep1": "---------",
                    "content": {
                        name: "Cell content: " + cellData, 
                        disabled: true
                    },
                    "copy": {
                        name: "Copy to clipboard", 
                        icon: "copy"
                    }
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

### Page Load Initialization
```javascript
apex.jQuery(document).ready(function() {
    initInteractiveGridContextMenu('ig-status');
});
```

## 4. Styling
### Required CSS
```css
.context-menu-list {
    z-index: 9999 !important;
}

.context-menu-icon.context-menu-close-icon::before {
    content: "\2716";  /* Unicode for multiplication sign (×) */
    font-size: 14px;
    color: red;
    margin-right: 5px;
}
```

## 5. Usage Notes
- 🎯 Features:
  - Copy to clipboard
  - Display cell content
  - Close menu option
- 📱 Responsive positioning
- ⚡ Dynamic menu building
- 🔍 Debug mode available (commented code provided)





# Interactive Grid Context Menu - Advanced Implementation
> Approach 2: Extended Functionality with Page Redirect

## Table of Contents
1. [Required Dependencies](#1-required-dependencies)
2. [Implementation Components](#2-implementation-components)
3. [Code Implementation](#3-code-implementation)
4. [Styling](#4-styling)
5. [AJAX Configuration](#5-ajax-configuration)
6. [Features](#6-features)

## 1. Required Dependencies
### CDN Files
#### JavaScript
```javascript
https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.js
```

#### CSS
```css
https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.9.2/jquery.contextMenu.min.css
```

## 2. Implementation Components
- 📋 Context Menu Implementation
- 🔄 AJAX Callback Process
- 🔗 Page Redirection Logic
- 🎨 Custom Styling

## 3. Code Implementation
### Core Function
```javascript
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
                    // Position calculation logic
                    // [Previous position code remains the same]
                }
            };
        }
    });
}
```

### Page Load Initialization
```javascript
apex.jQuery(document).ready(function() {
    initInteractiveGridContextMenu('ig-status');
});
```

## 4. Styling
### Required CSS
```css
.context-menu-list {
    z-index: 9999 !important;
}

.context-menu-icon.context-menu-close-icon::before {
    content: "\2716";
    font-size: 14px;
    color: red;
    margin-right: 5px;
}
```

## 5. AJAX Configuration
### Server-Side Process (PL/SQL)
```sql
declare
    lURL VARCHAR2(4000);
    lID  VARCHAR2(100);
BEGIN
    -- Get cell data from JavaScript
    lID := apex_application.g_x01;
    
    -- Generate JSON response
    apex_json.open_object;
    lURL := apex_page.get_url(p_page => 46, p_clear_cache => 46);
    apex_json.write('url', lURL);
    apex_json.close_object;
END;
```

## 6. Features
- 📋 Basic Features:
  - Copy to clipboard
  - Display cell content
  - Close menu option
- 🔗 Advanced Features:
  - Page redirection (to Page 46)
  - New tab opening
  - AJAX error handling
- 🎯 Additional Features:
  - Responsive positioning
  - Custom icons
  - Error messaging
  - Success notifications

## 7. Error Handling
- ✅ AJAX error catching
- 📝 User-friendly error messages
- 🔄 Process validation
- 🚫 Fallback mechanisms





