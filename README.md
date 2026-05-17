# Jerry for Zed

[Zed](https://zed.dev) extension for the [Jerry language](https://github.com/jeffscottbrown/jerry-lang).

## Features

| Feature | Status |
|---|---|
| Syntax highlighting | ✅ |
| Bracket matching & auto-close | ✅ |
| Smart indentation | ✅ |
| Document outline / Go to Symbol | ✅ |
| Run button on `fn main()` | ✅ |
| Code snippets | ✅ |
| Diagnostics & type errors | Requires `jerry lsp` on `$PATH` |
| Go to definition | Requires `jerry lsp` on `$PATH` |
| Hover documentation | Requires `jerry lsp` on `$PATH` |
| Completions | Requires `jerry lsp` on `$PATH` |

## Installation

**From the Zed extension registry:** open Zed → `⌘⇧X` → search **Jerry** → Install.

**From source:**

```bash
git clone https://github.com/jeffscottbrown/jerry-zed
```

Open Zed → `⌘⇧X` → **Install Dev Extension** → select the cloned directory.

## Language Server (jerry-lsp)

Full semantic features — diagnostics, completions, hover, go-to-definition — require the Jerry language server. Once `jerry lsp` is available on your `$PATH`, Zed will start it automatically when you open a `.jer` file. No further configuration is needed.

## Snippets

Type a prefix and press `Tab` to expand.

| Prefix | Expands to |
|---|---|
| `fn` | Function declaration |
| `fnx` | Anonymous function / closure |
| `class` | Class declaration with constructor |
| `classe` | Class declaration with inheritance |
| `let` | Typed variable declaration |
| `leti` | Variable declaration with inferred type |
| `if` | If statement |
| `ife` | If-else statement |
| `while` | While loop |
| `for` | Numeric for loop |
| `inc` | Include a stdlib module (`include @module`) |
| `incr` | Include a remote module |
| `print` | `print(value)` |
| `ret` | Return statement |
| `new` | New class instance |

## Language Basics

Jerry files use the `.jer` extension.

```jerry
// Single-line comment

/* Block comment */

include @string   // stdlib module

class Animal {
    name: string;

    fn new(name: string) {
        this.name = name;
    }

    fn speak(): void {
        println("...");
    }
}

class Dog extends Animal {
    fn new(name: string) {
        this.name = name;
    }

    fn speak(): void {
        println("Woof! I am " + this.name);
    }
}

fn main(): void {
    let d = new Dog("Rex");
    d.speak();
}
```

### Types

| Keyword | Description |
|---|---|
| `int` | Integer |
| `float` | Floating-point number |
| `bool` | Boolean (`true` / `false`) |
| `string` | String |
| `void` | No return value |

### Built-in Functions

`print` · `println` · `write` · `len` · `push` · `exit` · `panic` · `args` · `read_stdin` · `print_err` · `read_file` · `write_file` · `each_line` · `char_at` · `string_slice` · `char_to_string` · `int_to_string` · `float_to_string`

### Core stdlib (`include @core`)

`int_abs` · `int_max` · `int_min` · `float_abs` · `float_max` · `float_min` · `bool_to_string`

## Contributing

Bug reports and pull requests welcome at <https://github.com/jeffscottbrown/jerry-zed>.
