; ============================================================
; Jerry — Bracket-matching pairs for Zed
; ============================================================

(block "{" @open "}" @close)
(class_declaration "{" @open "}" @close)

(call_expression "(" @open ")" @close)
(new_expression "(" @open ")" @close)
(function_declaration "(" @open ")" @close)
(function_expression "(" @open ")" @close)
(for_statement "(" @open ")" @close)
(parenthesized_expression "(" @open ")" @close)

(array_expression "[" @open "]" @close)
(index_expression "[" @open "]" @close)
