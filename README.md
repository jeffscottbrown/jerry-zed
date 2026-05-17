# jerry-zed

[Zed](https://zed.dev) extension for the [Jerry language](https://github.com/jeffscottbrown/jerry-lang).

## Features

| Feature | Status |
|---|---|
| Syntax highlighting | ✅ Tree-sitter grammar |
| Bracket matching | ✅ |
| Auto-close brackets/quotes | ✅ |
| Smart indentation | ✅ |
| Document outline / Go to Symbol | ✅ |
| Snippets | ✅ |
| Diagnostics / type errors | Requires LSP (see below) |
| Go to definition | Requires LSP |
| Hover documentation | Requires LSP |
| Full autocompletion | Requires LSP |

## Installation

### From the Zed extension registry (once published)

Open Zed → `⌘⇧X` → search **Jerry** → Install.

### From source

```bash
git clone https://github.com/jeffscottbrown/jerry-zed
```

Open Zed → `⌘⇧X` → **Install Dev Extension** → select the cloned directory.

### Building the Tree-sitter grammar (required for source installs)

```bash
cd grammars/jerry
npm install
npx tree-sitter generate
```

This produces `grammars/jerry/src/parser.c` (and related files) which Zed compiles on first use.

> **Note:** When publishing a release to the Zed extension registry you must update the `commit` field in `extension.toml` to the exact commit SHA after pushing the generated `src/parser.c`.

## Implementing a Language Server (Jerry LSP)

The current extension provides editor ergonomics (highlighting, snippets, indentation) but **no semantic intelligence**. All of that — diagnostics, go-to-definition, completions, hover docs — requires a Language Server Protocol (LSP) implementation.

### Why Jerry is well-suited for an LSP

Jerry's compiler (`github.com/jeffscottbrown/jerry-lang`) already has:

- A complete **lexer + parser** (`internal/parser/`) — produces a full AST
- A **type checker** (`internal/checker/`) — resolves symbols, infers types, reports errors
- A structured **AST** (`internal/ast/`) — every node carries position information

An LSP can be built on top of these existing packages with relatively little new logic.

---

### Recommended approach: `jerry lsp` sub-command in Go

Add an `lsp` sub-command to the existing `jerry` CLI binary. This keeps everything in one binary and avoids distributing a second tool.

```
jerry lsp          # starts the LSP server on stdio (Zed default)
jerry lsp --port 7777  # optional TCP mode for debugging
```

#### Step 1 — add an LSP library dependency

[`gopls`'s protocol package](https://pkg.go.dev/golang.org/x/tools/gopls) is heavy. A lighter alternative is:

```
go get github.com/tliron/glsp
```

[`glsp`](https://github.com/tliron/glsp) is a minimal Go LSP framework that handles JSON-RPC transport and LSP message routing. You implement handler functions; `glsp` handles the wire protocol.

Alternatively, roll your own using `golang.org/x/tools/internal/jsonrpc2` or the `protocol` types from `github.com/sourcegraph/go-lsp`.

#### Step 2 — implement the core handlers

```
internal/lsp/
  server.go       // LSP server setup, capability declaration
  documents.go    // in-memory document store (open/change/close)
  diagnostics.go  // run type-checker, convert errors → LSP Diagnostics
  completion.go   // keyword + builtin + in-scope symbol completions
  hover.go        // type annotation on hover
  definition.go   // go-to-definition via symbol table
```

**Capabilities to declare on initialize:**

```json
{
  "textDocumentSync": 1,
  "completionProvider": { "triggerCharacters": ["."] },
  "hoverProvider": true,
  "definitionProvider": true,
  "diagnosticProvider": { "interFileDependencies": false }
}
```

#### Step 3 — diagnostics (highest value, least effort)

Reuse the existing checker:

```go
func diagnose(uri string, src []byte) []protocol.Diagnostic {
    stmts, parseErr := parser.Parse(string(src))
    // ... convert parser/checker errors to LSP Diagnostic structs
}
```

Call this on every `textDocument/didChange` (debounced ~300 ms).

#### Step 4 — completions

At minimum, seed the completion list with:

- All **keywords**: `let`, `fn`, `class`, `extends`, `if`, `else`, `while`, `for`, `return`, `new`, `this`, `null`, `break`, `continue`, `include`
- All **primitive types**: `int`, `float`, `bool`, `string`, `void`
- All **builtin functions** (from `checker.go`'s `registerBuiltins`): `print`, `println`, `write`, `len`, `push`, `exit`, `panic`, `args`, `read_stdin`, `print_err`, `read_file`, `write_file`, `each_line`, `char_at`, `string_slice`, `char_to_string`, `int_to_string`, `float_to_string`
- All **core stdlib functions**: `int_abs`, `int_max`, `int_min`, `float_abs`, `float_max`, `float_min`, `bool_to_string`

For `.`-triggered completions, look up the type of the receiver in the checker's symbol table and return its fields and methods.

#### Step 5 — hover

Walk the AST to find the node under the cursor position, look it up in the type-checker's scope, and return the type as a hover string.

#### Step 6 — wire it into Zed

In `extension.toml` (once the LSP exists):

```toml
[language_servers.jerry-lsp]
language = "Jerry"

[language_servers.jerry-lsp.binary]
command = "jerry"
args = ["lsp"]
```

Zed will spawn `jerry lsp` and communicate over stdio. No separate install step is needed as long as `jerry` is on `$PATH`.

---

### Alternative: reuse an existing generic LSP

If you want diagnostics quickly without building a full LSP, consider wiring in a generic language server such as [efm-langserver](https://github.com/mattn/efm-langserver) configured to run `jerry compile` on save and parse its error output. This gives you diagnostics only, but it works today.

---

## File Structure

```
jerry-zed/
├── extension.toml              # Zed extension manifest
├── grammars/
│   └── jerry/
│       ├── grammar.js          # Tree-sitter grammar source
│       └── package.json        # tree-sitter-cli dev dependency
└── languages/
    └── jerry/
        ├── config.toml         # Language config (comments, brackets)
        ├── highlights.scm      # Syntax highlight queries
        ├── indents.scm         # Indentation queries
        ├── brackets.scm        # Bracket-matching pairs
        ├── outline.scm         # Document outline queries
        └── snippets.json       # Code snippets
```

## Contributing

Bug reports and pull requests welcome at <https://github.com/jeffscottbrown/jerry-zed>.
