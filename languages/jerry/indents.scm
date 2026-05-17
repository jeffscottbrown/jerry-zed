; ============================================================
; Jerry — Indentation rules for Zed
; ============================================================
; Nodes that introduce a new indentation level (their opening
; brace triggers an indent, their closing brace de-indents).

[
  (block)
  (class_declaration)
  (function_declaration)
  (method_declaration)
  (if_statement)
  (else_clause)
  (while_statement)
  (for_statement)
] @indent

; Closing braces de-dent
(block "}" @outdent)
