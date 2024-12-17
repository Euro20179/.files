((code_block
   (language) @injection.language
   (code_text) @injection.content
   ))

((inline_code_start)
         .
       (code) @injection.content
 (#set! injection.language "amml"))
((inline_code
   (language) @injection.language
   (code) @injection.content))
