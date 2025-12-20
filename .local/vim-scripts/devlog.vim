cd $WIKI/server/rpinet-doc/
e HISTORY.mmfml

let year = strftime("%Y")
let m = strftime("%m")
let d = strftime("%d")

"go to the current year
call search("^= " . year)
"find todays date as an entry (and move the mouse if it exists)
let has_date = search('\%>.l== ' . m . '/' . d, "p")
"if we found the date then add another list item to it
if has_date > 0
    "use feedkeys instead of norm so that the cursor stays AFTER the space
    call feedkeys("}ko+ ")
else
    "otherwise go to the bottom as indicated by ===========
    call search('\%>.l================')
    "then create a new date entry and add a list item to it
    call feedkeys("{O\t==" . m . "/" . d . "\r\t+ ")
endif

