(operator) @operator
(keyword) @keyword
(number) @number
(variable) @variable
((func_call funcname: (variable) @function))
((func_call "of" @keyword))

((variable) @function . (func_names (variable) @variable.parameter))
((operator) . (func_names (variable) @variable.parameter))
(variable_subscript) @number

(adhock_operator) @operator

(create_var [
             leftName: (variable) @variable.parameter
             rightName: (variable) @variable.parameter
        ])

; ((i) @character.special)
((constant) @character.special)

(comment) @comment

(string) @string

[
 "("
 ")"
]@operator

(note [ "/*(" ")" "*/" ] @comment )
