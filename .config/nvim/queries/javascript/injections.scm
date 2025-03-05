(lexical_declaration (
    variable_declarator
        name: (identifier) @i (#match? @i "html")
        value: (template_string (_) @injection.content (#set! injection.language "html"))
))

(augmented_assignment_expression
  left: (identifier) @i (#match? @i "html")
  right: (template_string (_) @injection.content (#set! injection.language "html"))
    )
