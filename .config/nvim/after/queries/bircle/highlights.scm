(header) @operator

(string) @string
(prefix) @character.special

(command_name) @function

(command
    (command_name) @_word
    (#eq? @_word "var")
    (parameter_list
      (argument
        (string
          (punctuation) @_p
          (#eq? @_p "=")
          )
      ) @operator
    )
) @keyword

"stackl" @function
(command_modifier) @preproc

[
 ; "var"
 "timeit"
 "if"
 "if-cmd"
 "else"
 "elif"
 ";end"
 "else;"
] @keyword

(format) @macro
(format
  (string) @parameter
)

(conditional) @conditional

(do_first) @preproc
(calculate_interpolation) @preproc
[
"$["
"]"
] @preproc

(escape_sequence) @string.escape

(variable) @identifier
(variable_scope) @field
(variable_name) @property

(pipe_operator) @operator

(if_cmd_operator) @operator

(EOL) @punctuation

[
 "\\b{"
 "\\i{"
 "\\S{"
 "}"
 "*"
] @punctuation


(mention) @character.special
(bold) @text.strong
(italic) @text.emphasis
(strike) @text.strike
(emoji) @character.special

(stackl_start) @keyword

(stackl_string) @string
(stackl_operation) @function
(stackl_identifier) @property
(stackl_operator) @operator
(stackl_number) @number
(stackl_constant) @constant
