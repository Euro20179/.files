
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

((list) @markup.list)

[
 (header)
] @markup.heading

[
 (pre_sample)
 (quote)
] @markup.raw

((backslash) @conceal (#set! conceal ""))

;}}}

; Checkboxes {{{
((list)
 .
 ((simple_marked_text
    (box) @markup.list.checked.markdown (#eq? @markup.list.checked.markdown "[x]") (#set! conceal "✅︎"))))

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
 ((simple_marked_text) @_spacer (#vim-match? @_spacer "^[[:space:]\\n]*$"))?
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
((pre_sample_start) @conceal (#set! conceal ""))
((quote_start) @conceal (#set! conceal ""))
((bold_start) @conceal (#set! conceal ""))
((italic_start) @conceal (#set! conceal ""))
((strikethrough_start) @conceal (#set! conceal ""))
((underline_start) @conceal (#set! conceal ""))
((higlight_start) @conceal (#set! conceal ""))
((anchor_start) @conceal (#set! conceal ""))

((pre_sample_end) @conceal (#set! conceal ""))
((quote_end) @conceal (#set! conceal ""))
((bold_end) @conceal (#set! conceal ""))
((italic_end) @conceal (#set! conceal ""))
((strikethrough_end) @conceal (#set! conceal ""))
((underline_end) @conceal (#set! conceal ""))
((higlight_end) @conceal (#set! conceal ""))
((anchor_end) @conceal (#set! conceal ""))
; }}}

;highlighted words {{{
((word) @_w (#eq? @_w "NOTE") . (non_word) @_n (#eq? @_n ":")) @comment.note
((word) @_w (#eq? @_w "TODO") . (non_word) @_n (#eq? @_n ":")) @comment.todo
[
 ((word) @_w1 (#vim-match? @_w1 "^WARN\%[ING]$") . (non_word) @_n (#eq? @_n ":"))
] @comment.warning
;}}}
