[
 (header)
    ; (header1)
    ; (header2)
    ; (header3)
    ; (header4)
    ; (header5)
    ; (header6)
] @markup.heading

((metadata_key) @tag)
((metadata_value) @string)
; ((metadata_open) @conceal (#set! conceal ">"))
; ((metadata_close) @conceal (#set! conceal ""))

[
 (pre_sample)
] @markup.raw

((divider) @punctuation)

((code_block_start) @conceal (#set! conceal ""))
((code_block_end) @conceal (#set! conceal ""))

; ((code_block_end_arrow) @conceal (#set! conceal ""))
; ((code_block_start_arrow) @conceal (#set! conceal ""))

((higlight) @markup.mmfml.highlight)
((strikethrough) @markup.strikethrough)
((bold) @markup.strong)
((italic) @markup.italic)
((underline) @markup.underline)

((anchor) @label)

((list) @markup.list)

((list)
 .
 ((simple_marked_text
    (box) @markup.list.checked.markdown (#eq? @markup.list.checked.markdown "[x]") (#set! conceal "✅︎"))))

((list)
 .
 ((simple_marked_text
    (box) @conceal (#eq? @conceal "[ ]") (#set! conceal ""))))

((simple_marked_text
   (box
     (simple_marked_text) @markup.link))
 .
 ((simple_marked_text) @_spacer (#match? @_spacer "^\\s*$"))?
 .
 (simple_marked_text (link)))

; ((simple_marked_text
;    (box
;      (simple_marked_text) @_text (#eq? @_text "date")))
;  .
;  ((simple_marked_text) @_spacer (#match? @_spacer "^\\s*$"))?
;  .
;  (simple_marked_text (plain . (word) @number (#match? @number "^[[:digit:]\\-]+$"))))


; ((link
;    (simple_marked_text (plain) @markup.link)))

((link (link_url) @markup.link.url))

((footnote_ref (footnote_name_text) @markup.link.url))


((footnote_start) @attribute)
((footnote_end) @attribute)

((backslash) @conceal (#set! conceal ""))

; (code_block (language) @label)

; ((escaped_char) @operator)

((pre_sample_start) @conceal (#set! conceal ""))
((bold_start) @conceal (#set! conceal ""))
((italic_start) @conceal (#set! conceal ""))
((strikethrough_start) @conceal (#set! conceal ""))
((underline_start) @conceal (#set! conceal ""))
((higlight_start) @conceal (#set! conceal ""))
((pre_sample_start) @conceal (#set! conceal ""))
((anchor_start) @conceal (#set! conceal ""))

((pre_sample_end) @conceal (#set! conceal ""))
((bold_end) @conceal (#set! conceal ""))
((italic_end) @conceal (#set! conceal ""))
((strikethrough_end) @conceal (#set! conceal ""))
((underline_end) @conceal (#set! conceal ""))
((higlight_end) @conceal (#set! conceal ""))
((pre_sample_end) @conceal (#set! conceal ""))
((anchor_end) @conceal (#set! conceal ""))

((word) @_w (#eq? @_w "NOTE:")) @comment.note
((word) @_w (#eq? @_w "TODO:")) @comment.todo
[
 ((word) @_w1 (#eq? @_w1 "WARN:"))
 ((word) @_w2 (#eq? @_w2 "WARNING:"))
] @comment.warning
