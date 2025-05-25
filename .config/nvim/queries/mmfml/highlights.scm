
; quotes {{{

; highlights the `>` before a quote {{{
((simple_marked_text
  (plain
    ((non_word) @_indicator (#eq? @_indicator ">")) @punctuation .
    )
  )
 .
 (simple_marked_text
   .
   (quote)))
;}}}

(quote_author_indicator) @punctuation
(quote_author) @markup.italic

; }}}

;code {{{
((code_block_start) @conceal (#set! conceal ""))
((code_block_end) @conceal (#set! conceal ""))

;For when a language is specified
(code_block (language) @comment)
;For when no language is specified
((code_block_start) . (code_text) @markup.raw)

((inline_code_start) @conceal (#set! conceal ""))
((inline_code_start) (language) @conceal (#set! conceal ""))
((inline_code_end) @conceal (#set! conceal ""))
;}}}

; Simple highlights {{{
((higlight) @markup.mmfml.highlight)

((strikethrough) @markup.strikethrough)

((bold) @markup.strong)

((italic) @markup.italic)

((underline) @markup.underline)

((anchor) @keyword.directive)

((divider) @punctuation)
((non_word) @punctuation (#match? @punctuation "^[\\u2500-\\u257f\\u2580-\\u259f]+$"))

((list) @markup.list)

[
 (header)
] @markup.heading

;text following a divider is a heading
((simple_marked_text (divider) @_d (#match? @_d "^\\=+$")) . (line_break) . (simple_marked_text) @markup.heading)

;Text surrounded by dividers is a header
;(the header must be 5+ chars on each side)
((simple_marked_text (divider) @_d (#match? @_d ".{5,}"))
 .
 (simple_marked_text (plain (word)) @markup.heading)
 .
 (simple_marked_text (divider) @_d))

[
 (pre_sample_text)
 (quote)
] @markup.raw

;}}}

; Checkboxes {{{
((list)
 .
 ((simple_marked_text
    (box) @markup.list.checked (#eq? @markup.list.checked "[x]") (#set! conceal ""))))

((list)
 .
 ((simple_marked_text
    (box) @boolean (#eq? @boolean "[?]") (#set! conceal ""))))

((list)
 .
 ((simple_marked_text
    (box) @conceal (#eq? @conceal "[ ]") (#set! conceal ""))))
;}}}

; urls {{{
((simple_marked_text
   (box
     "[" @_boxb (#set! @_boxb conceal "")
     (simple_marked_text) @markup.link.label
     "]" @_boxb
    ))
 .
 ([(simple_marked_text) (line_break)] @_spacer (#vim-match? @_spacer "^[[:space:]\\n]*$"))?
 .
 (simple_marked_text (link  (link_url) @markup.link)  @_full (#set! @_full conceal "") )
 (#set! @markup.link.label url @markup.link))


((link (link_url) @markup.link.url))
;}}}

;footnotes {{{
((footnote_ref (footnote_name_text) @markup.link.url))

((footnote_start) @attribute)
((footnote_end) @attribute)
;}}}

;simple conceals {{{
((pre_sample_start) @punctuation (#set! conceal ""))
((quote_start) @punctuation (#set! conceal ""))
((bold_start) @punctuation (#set! conceal ""))
((italic_start) @punctuation (#set! conceal ""))
((strikethrough_start) @punctuation (#set! conceal ""))
((underline_start) @punctuation (#set! conceal ""))
((higlight_start) @punctuation (#set! conceal ""))
((anchor_start) @punctuation (#set! conceal ""))

((pre_sample_end) @punctuation (#set! conceal ""))
((quote_end) @punctuation (#set! conceal ""))
((bold_end) @punctuation (#set! conceal ""))
((italic_end) @punctuation (#set! conceal ""))
((strikethrough_end) @punctuation (#set! conceal ""))
((underline_end) @punctuation (#set! conceal ""))
((higlight_end) @punctuation (#set! conceal ""))
((anchor_end) @punctuation (#set! conceal ""))

(([
 (hidden_start)
 (hidden_end)
]) @punctuation (#set! conceal "⚠️"))

((hidden_start) . (simple_marked_text) @conceal (#set! conceal "⚠️"))
; }}}

;highlighted words {{{
((word) @_w (#eq? @_w "NOTE") . (non_word) @_n (#eq? @_n ":")) @comment.note
((word) @_w (#eq? @_w "TODO") . (non_word) @_n (#eq? @_n ":")) @comment.todo
[
 ((word) @_w1 (#vim-match? @_w1 "^WARN\%[ING]$") . (non_word) @_n (#eq? @_n ":"))
] @comment.warning
;}}}
