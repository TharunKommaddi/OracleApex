```javascript
var search = $v("P1_SEARCH_COLUMN");
var oldColumn = $v("P1_SELECTED_COLUMN");

// alert("Search Column: " + search); // Alert to check the search column value
// alert("Old Selected Column: " + oldColumn); // Alert to check the old selected column value

if (search) {
    var column = $(".a-GV-header." + search);
    // alert("Column found: " + column.length); // Alert to check if the column is found

    if (column.length > 0) {
        var pos = column[0].offsetLeft;
        // alert("Column position: " + pos); // Alert to check the column position

        // Set the scroll position and highlight the column header
        if ((pos && pos > 0) || (pos == 0)) {
            $('.a-GV-w-scroll').prop('scrollLeft', pos - 80);
            column.css({"backgroundColor": "#c5f0ff"}); 
            // alert("Scroll position set and column header color changed"); // Alert after setting scroll and color
        }
    }
}

// Reset the previously highlighted column and save the currently selected column for later
if (oldColumn != search) {
    if (oldColumn) {
        $(".a-GV-header." + oldColumn).css({"backgroundColor": "inherit"});
        // alert("Old column color reset"); // Alert after resetting old column color
    }
    $s("P1_SELECTED_COLUMN", search);
    // alert("New selected column saved: " + search); // Alert after saving new selected column
};
```
