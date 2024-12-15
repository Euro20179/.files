((code_block
   (language) @injection.language
   (code_text) @injection.content
   ))

((inline_code . (code) @injection.content) (#set! injection.language "amml"))
((inline_code
   (language) @injection.language
   (code) @injection.content))
