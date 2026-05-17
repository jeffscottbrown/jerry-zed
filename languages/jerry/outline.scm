; ============================================================
; Jerry — Document outline / symbol queries for Zed
; ============================================================
; These queries power the "Go to Symbol" panel and the file
; outline sidebar in Zed.

; Top-level and nested function declarations
(function_declaration
  name: (identifier) @name
) @item

; Class declarations
(class_declaration
  name: (identifier) @name
) @item

; Methods inside a class
(method_declaration
  name: (identifier) @name
) @item
