;;extends

(string
  (string_start) @_outer
  .
  (string_content) @injection.content
  (#match? @_outer "^r")
  (#set! injection.language "regex"))

(function_definition body:
                     (block
                       .
                       (expression_statement
                         (string
                           (string_content) @injection.content)
                         (#set! injection.language "markdown"))))
