; ============================================================
; Jerry — Tree-sitter highlight queries for Zed
; ============================================================

; ------------------------------------------------------------
; Keywords
; ------------------------------------------------------------

[
  "include"
  "class"
  "extends"
  "new"
  "let"
] @keyword

"fn" @keyword.function

[
  "return"
  "break"
  "continue"
] @keyword.control.return

[
  "if"
  "else"
] @keyword.control.conditional

[
  "while"
  "for"
] @keyword.control.repeat

; ------------------------------------------------------------
; Built-in types
; ------------------------------------------------------------

(primitive_type) @type.builtin

; User-defined class names at declaration site
(class_declaration name: (identifier) @type)
(new_expression class: (identifier) @type)

; Type identifiers in type-annotation positions
(type_identifier) @type
(array_type element: (type_identifier) @type)

; ------------------------------------------------------------
; Functions
; ------------------------------------------------------------

; Declaration names
(function_declaration name: (identifier) @function)
(method_declaration   name: (identifier) @function.method)

; Call sites — generic
(call_expression function: (identifier) @function.call)
(call_expression function: (member_expression property: (identifier) @function.method.call))

; Built-in functions (always available, from @core and compiler builtins)
(call_expression
  function: (identifier) @function.builtin
  (#match? @function.builtin
    "^(print|println|write|len|push|exit|panic|args|read_stdin|print_err|read_file|write_file|each_line|char_at|string_slice|char_to_string|int_to_string|float_to_string|int_abs|int_max|int_min|float_abs|float_max|float_min|bool_to_string)$"))

; ------------------------------------------------------------
; Variables & parameters
; ------------------------------------------------------------

(variable_declaration name: (identifier) @variable)
(parameter           name: (identifier) @variable.parameter)

; this keyword
(this) @variable.builtin

; ------------------------------------------------------------
; Fields / properties
; ------------------------------------------------------------

(field_declaration name: (identifier) @property)
(member_expression property: (identifier) @property)

; ------------------------------------------------------------
; Literals
; ------------------------------------------------------------

(string_literal)  @string
(integer_literal) @number
(float_literal)   @number.float

(true)  @boolean
(false) @boolean
(null)  @constant.builtin

; ------------------------------------------------------------
; Operators
; ------------------------------------------------------------

[
  "="
  "=="
  "!="
  "<"
  ">"
  "<="
  ">="
  "+"
  "-"
  "*"
  "/"
  "%"
  "&&"
  "||"
  "!"
  "++"
  "--"
] @operator

; ------------------------------------------------------------
; Punctuation
; ------------------------------------------------------------

[ "{" "}" ] @punctuation.bracket
[ "[" "]" ] @punctuation.bracket
[ "(" ")" ] @punctuation.bracket

[ ";" "," "." ":" ] @punctuation.delimiter

; Array type suffix brackets are still brackets
(array_type "[]" @punctuation.bracket)

; include @ sigil
(include_declaration "@" @punctuation.special)

; ------------------------------------------------------------
; Comments
; ------------------------------------------------------------

(line_comment)  @comment
(block_comment) @comment
