# Global Page - Context Menu - IG - Context Menu Implementation Documentation

## 1. Required Files Location
The necessary files need to keep in Universal Theme under Shared Components > Themes:
- `jquery.contextMenu.js` - Reference: `#THEME_DB_FILES#jquery.contextMenu.js`
- `jquery.ui.position.js` - Reference: `#THEME_DB_FILES#jquery.ui.position.js`
- `jquery.contextMenu.css` - Reference: `#THEME_DB_FILES#jquery.contextMenu.css`


## 2. File References Configuration
Configure these files in **Shared Components > User Interface Attributes**:
1. Navigate to: Application > User Interfaces
2. Under the JavaScript section:
   - Add file URLs for the JavaScript files
      -  `jquery.contextMenu.js` - Reference: `#THEME_DB_FILES#jquery.contextMenu.js`
      - `jquery.ui.position.js` - Reference: `#THEME_DB_FILES#jquery.ui.position.js`          
3. Under the CSS section:
   - Add file URL for the CSS file
      - `jquery.contextMenu.css` - Reference: `#THEME_DB_FILES#jquery.contextMenu.css`

## 3. Implementation Code
Place this code in the Global Page:

### JavaScript Implementation
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

### CSS Styling
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
- Right-click context menu for table cells
- Excludes empty cells and cells with dash ('-')
- Menu options:
  1. Close button (red X)
  2. Cell content display
  3. Copy to clipboard function with success message

## 5. Usage Notes
- To exclude cells from having context menu:
  - Add class `nocm` or `no-context-menu` to the cell
- Menu appears on right-click on valid table cells
- Automatic copy-to-clipboard functionality
- German language interface messages

## 6. Dependencies
- Universal Theme
- jQuery
- Font Awesome (for icons)
- APEX version 18.x or higher
- jQuery Migrate (ensure it's enabled in User Interface attributes)


