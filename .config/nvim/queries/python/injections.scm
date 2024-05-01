;;extends

((string
   (string_content) @injection.content) @_outer
 (#set! injection.language "regex")
 (#match? @_outer "^r"))

(function_definition body:
                     (block
                       (expression_statement
                         (string
                           (string_content) @injection.content)
                         (#set! injection.language "markdown"))))
