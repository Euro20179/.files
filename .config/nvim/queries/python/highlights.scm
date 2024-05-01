;;extends
((call
   arguments: (argument_list
                (string
                  (string_content) @number)
                (#match? @number "^\\c[+-]?(nan|inf|\\d*(\\.\\d+)?(e\\d)?)$"))) @_fname
 (#match? @_fname "^float\\("))
((call
   arguments: (argument_list
                (string
                  (string_content) @number)
                (#match? @number "^\\d+$"))) @_fname
 (#match? @_fname "^int\\("))
