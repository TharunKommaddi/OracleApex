# Oracle APEX Context Menu Implementation Guide
> Interactive Grid (IG) Context Menu Implementation Documentation for Global Page

## Table of Contents
1. [Required Files Location](#1-required-files-location)
2. [Configuration Steps](#2-configuration-steps)
3. [Implementation Code](#3-implementation-code)
4. [Features](#4-features)
5. [Usage Notes](#5-usage-notes)
6. [Dependencies](#6-dependencies)
7. [Troubleshooting](#7-troubleshooting)

## 1. Required Files Location
### Theme Files (Universal Theme)
Navigate to: **Shared Components > Themes**
- `jquery.contextMenu.js` → `#THEME_DB_FILES#jquery.contextMenu.js`
- `jquery.ui.position.js` → `#THEME_DB_FILES#jquery.ui.position.js`
- `jquery.contextMenu.css` → `#THEME_DB_FILES#jquery.contextMenu.css`

## 2. Configuration Steps
### Step 1: JavaScript Configuration
Navigate to: **Shared Components > User Interface Attributes > JavaScript**

Add these File URLs:
```
#THEME_DB_IMAGES#jquery.contextMenu#MIN#.js
#THEME_DB_IMAGES#jquery.ui.position#MIN#.js
```

### Step 2: Required Settings
Under "Include Deprecated or Desupported Javascript Functions":
- ✅ Enable **18.x**
- ✅ Enable **Include jQuery Migrate**
- ❌ Do NOT enable "Pre 18.1"

### Step 3: CSS Configuration
Navigate to: **User Interface Attributes > CSS**

Add this File URL:
```
#THEME_DB_IMAGES#jquery.contextMenu.css
```

⚠️ **IMPORTANT**: Use exact file references as shown above. Any variation may cause functionality issues.

## 3. Implementation Code
### Global Page JavaScript
```javascript
document.addEventListener("DOMContentLoaded", function(event) { 
    function isEmptyOrDash(text) {
        return !text || text.trim() === '' || text.trim() === '-';
    }

    $.contextMenu({
        // Applies to table cells with class a-GV-cell, excluding cells with classes nocm or no-context-menu
        selector: 'td.a-GV-cell:not(.nocm):not(.no-context-menu)',
        build: function ($trigger, e) {
            var text = $trigger.text().trim();
            
            // Don't show menu for empty cells
            if (isEmptyOrDash(text)) {
                return false;
            }
            
            // Menu items configuration
            var items = {
                close: { 
                    icon: "fa-close",
                    name: "&nbsp;", 
                    isHtmlName: true, 
                    className: "nohover context-menu-icon-red",
                    callback: function() { return true; }
                },
                text: { 
                    icon: "fa-file-text-o",
                    name: "<b>Zelleninhalt:</b> " + text, 
                    isHtmlName: true
                },
                copy: { 
                    icon: "fa-clipboard",
                    name: "In die Zwischenablage kopieren", 
                    callback: function(){ 
                        navigator.clipboard.writeText(text);
                        apex.message.showPageSuccess( "Text in die Zwischenablage kopiert" );
                    } 
                }
            };
            
            return {items: items};
        }
    });
});
```

### Global Page CSS
```css
/* Context Menu Styles */
.context-menu-list {
    z-index: 9999 !important;
}

.context-menu-icon-red:before {
    font-size: 14px;
    color: red !important;
    margin-right: 5px;
}

.context-menu-item {
    font-size: 14px !important;
    line-height: 1.5 !important;
}

.context-menu-icon::before {
    font-size: inherit !important;
}
```

## 4. Features
- ✨ Right-click context menu for table cells
- 🚫 Auto-excludes empty cells and cells with dash ('-')
- 📋 Menu options:
  1. Close button (red X)
  2. Cell content display
  3. Copy to clipboard with success message

## 5. Usage Notes
- 🔒 To exclude specific cells from context menu:
  - Add class `nocm` or `no-context-menu`
- 🖱️ Activation: Right-click on valid table cells
- 📋 Automatic clipboard copying
- 🌍 Interface language: German

## 6. Dependencies
- 🎨 Universal Theme
- 📚 jQuery
- 🎯 Font Awesome (for icons)
- 📦 APEX version 18.x or higher
- 🔄 jQuery Migrate

## 7. Troubleshooting
If context menu doesn't appear:
- ✅ Verify all file references exactly match documentation
- 🔍 Check browser console for JavaScript errors
- ✅ Confirm jQuery Migrate is enabled
- 🔍 Verify cell doesn't have `nocm` or `no-context-menu` classes
- ✅ Check cell content isn't empty or just '-'
