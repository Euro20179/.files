((code_block
   (language) @injection.language
   (code_text) @injection.content
   ))

((inline_code_start)
         .
       (code) @injection.content
 (#set! injection.language "amml"))

(
 (inline_code_start) @injection.language
     (#match? @injection.language "[^$]")
     (#offset! @injection.language 0 1 0 -1)
         . (code) @injection.content)
