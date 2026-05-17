; Show a "Run ▶" button next to fn main()
((function_declaration
  name: (identifier) @name
  (#eq? @name "main")) @run
  (#set! tag jerry-main))
