# Colors

A simple, powerful terminal coloring and styling library for Nim.

## Features

- Easy-to-use text coloring and styling for terminal output
- Support for 16 different colors (standard and bright variants)
- Multiple text styling options (bold, italic, underline, etc.)
- Flexible API with both function calls and method chaining
- Background color support
- Programmatic color selection by name

## Installation

```
nimble install colors
```

## Usage

This library's API is inspired by the popular npm 'colors' package for JavaScript, providing a similar intuitive experience for Nim developers.

### Basic Colors

```nim
import colors

echo red("This is red text")
echo green("This is green text")
echo blue("This is blue text")
echo yellow("This is yellow text")
echo magenta("This is magenta text")
echo cyan("This is cyan text")
echo white("This is white text")
echo grey("This is grey text")  # gray() also works
```

### Method Chaining

Just like the npm 'colors' package, you can chain multiple methods together to apply different styles:

```nim
echo "This is blue".blue
echo "This is green".green
echo "This is blue underlined".blue.underline
echo "This is bold red text".red.bold
echo "Custom styled text".color(Color.BrightGreen)
```

### Text Styling

```nim
echo bold("This is bold text")
echo italic("This is italic text")
echo underline("This is underlined text")
echo strikethrough("This is strikethrough text")
```

### Background Colors

```nim
echo bgRed("This has a red background")
echo "This has a green background".bgGreen
echo bgBlue("This has a blue background")
```

### Combining Styles

```nim
echo red("This is ") & "a ".italic.green & bold("colorful ") & underline("string!").yellow
echo "Red on green".red.bgGreen & " and " & "Blue on yellow".blue.bgYellow
```

### Custom Styling

```nim
echo colorize("Custom styled text", Color.BrightGreen, styles = [TextStyle.Bold, TextStyle.Underline])
echo colorize("Text with background", Color.White, Color.Blue, hasBg = true)
```

### Programmatic Color Selection

```nim
let userColor = "grey"
echo colorize("This text is colored programmatically", userColor)
echo "This text is also colored programmatically".color(userColor)
echo "This has a programmatic background".onColor(userColor)
```

## Available Colors

- Black
- Red
- Green
- Yellow
- Blue
- Magenta
- Cyan
- White
- Grey/Gray
- BrightRed
- BrightGreen
- BrightYellow
- BrightBlue
- BrightMagenta
- BrightCyan
- BrightWhite

## Available Text Styles

- Bold
- Dim
- Italic
- Underline
- Blink
- RapidBlink
- Reverse
- Hidden
- Strikethrough