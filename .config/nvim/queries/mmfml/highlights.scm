((header1) @markup.heading )
((header2) @markup.heading )
((header3) @markup.heading )
((header4) @markup.heading )
((header5) @markup.heading )
((header6) @markup.heading )

((pre_sample) @markup.raw)
((code_block) @markup.raw)

; ((code_block_end_arrow) @conceal (#set! conceal ""))
((code_block_start_arrow) @conceal (#set! conceal ""))

((higlight) @markup.mmfml.highlight)
((strikethrough) @markup.strikethrough)
((bold) @markup.strong)
((italic) @markup.italic)
((underline) @markup.underline)

((anchor) @label)

((list_indicator) @markup.list)

((link
   (simple_marked_text (plain) @markup.link)))

((link (link_url)  @markup.link.url))

((footnote_ref (plain) @markup.link.url))


((footnote_block) @attribute)

((backslash) @conceal (#set! conceal ""))

(code_block (language) @label)

((escaped_char) @operator)

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
