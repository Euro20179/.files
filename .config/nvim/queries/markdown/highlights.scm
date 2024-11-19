;;extends

;list item importance{{{
((inline) @comment.error
          (#has-ancestor? @comment.error list_item)
          (#match? @comment.error "^!\\s"))

((inline) @comment.note
          (#has-ancestor? @comment.note list_item)
          (#match? @comment.note "^\\=\\s"))

((inline) @comment.todo
          (#has-ancestor? @comment.todo list_item)
          (#match? @comment.todo "^\\@\\s"))
;}}}

;checkboxes {{{
((task_list_marker_checked) @markup.list.checked
                            (#has-ancestor? @markup.list.checked list_item)
                            (#set! @markup.list.checked conceal ""))
((task_list_marker_unchecked) @markup.list.unchecked
                            (#has-ancestor? @markup.list.unchecked list_item)
                            (#set! @markup.list.unchecked conceal ""))
((task_list_marker_checked) @_box
                            (#has-ancestor? @_box list_item)
                            (paragraph) @markup.list.checked)
;}}}

((language) @label.markdown (#set! @label.markdown conceal ""))
