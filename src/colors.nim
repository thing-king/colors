# util/colors.nim
import strutils

type
  Color* = enum
    Black = 30, Red, Green, Yellow, Blue, Magenta, Cyan, White,
    Grey = 90, BrightRed, BrightGreen, BrightYellow, BrightBlue, BrightMagenta, BrightCyan, BrightWhite

  TextStyle* = enum
    Bold = 1, Dim = 2, Italic = 3, Underline = 4, Blink = 5, RapidBlink = 6, Reverse = 7, Hidden = 8, Strikethrough = 9

proc colorize*(text: string, fg: Color, bg: Color = Color.Black, styles: varargs[TextStyle], hasBg: bool = false): string =
  var styleStr = ""
  for style in styles:
    styleStr.add($ord(style) & ";")
  
  result = "\e[" & styleStr & $ord(fg)
  if hasBg:
    result &= ";" & $ord(bg.int + 10)
  result &= "m" & text & "\e[0m"

proc stylize*(text: string, styles: varargs[TextStyle]): string =
  var styleStr = ""
  for style in styles:
    styleStr.add($ord(style) & ";")
  
  result = "\e[" & styleStr[0..^2] & "m" & text & "\e[0m"

# Function to get Color from string
proc getColorFromString*(colorName: string): Color =
  case colorName.toLower()
  of "black": Black
  of "red": Red
  of "green": Green
  of "yellow": Yellow
  of "blue": Blue
  of "magenta": Magenta
  of "cyan": Cyan
  of "white": White
  of "grey", "gray": Grey
  of "brightred": BrightRed
  of "brightgreen": BrightGreen
  of "brightyellow": BrightYellow
  of "brightblue": BrightBlue
  of "brightmagenta": BrightMagenta
  of "brightcyan": BrightCyan
  of "brightwhite": BrightWhite
  of "brightgrey", "brightgray": Grey
  else: White  # Default to white if color not found

# Function to colorize text with a string color name
proc colorize*(text: string, colorName: string): string =
  let color = getColorFromString(colorName)
  colorize(text, color)

# Extension methods for string (foreground colors)
proc color*(s: string, fg: Color): string = colorize(s, fg)
proc color*(s: string, colorName: string): string = colorize(s, colorName)
proc onColor*(s: string, bg: Color): string = colorize(s, Color.White, bg, hasBg = true)
proc onColor*(s: string, colorName: string): string = 
  let bgColor = getColorFromString(colorName)
  colorize(s, Color.White, bgColor, hasBg = true)

# Foreground color procs
proc black*(s: string): string = s.color(Color.Black)
proc red*(s: string): string = s.color(Color.Red)
proc green*(s: string): string = s.color(Color.Green)
proc yellow*(s: string): string = s.color(Color.Yellow)
proc blue*(s: string): string = s.color(Color.Blue)
proc magenta*(s: string): string = s.color(Color.Magenta)
proc cyan*(s: string): string = s.color(Color.Cyan)
proc white*(s: string): string = s.color(Color.White)
proc grey*(s: string): string = s.color(Color.Grey)
proc gray*(s: string): string = s.color(Color.Grey)

# Background color procs
proc bgBlack*(s: string): string = colorize(s, Color.White, Color.Black, hasBg = true)
proc bgRed*(s: string): string = colorize(s, Color.White, Color.Red, hasBg = true)
proc bgGreen*(s: string): string = colorize(s, Color.White, Color.Green, hasBg = true)
proc bgYellow*(s: string): string = colorize(s, Color.White, Color.Yellow, hasBg = true)
proc bgBlue*(s: string): string = colorize(s, Color.White, Color.Blue, hasBg = true)
proc bgMagenta*(s: string): string = colorize(s, Color.White, Color.Magenta, hasBg = true)
proc bgCyan*(s: string): string = colorize(s, Color.White, Color.Cyan, hasBg = true)
proc bgWhite*(s: string): string = colorize(s, Color.Black, Color.White, hasBg = true)
proc bgGrey*(s: string): string = colorize(s, Color.White, Color.Grey, hasBg = true)
proc bgGray*(s: string): string = colorize(s, Color.White, Color.Grey, hasBg = true)

# Style procs
proc bold*(s: string): string = stylize(s, TextStyle.Bold)
proc dim*(s: string): string = stylize(s, TextStyle.Dim)
proc italic*(s: string): string = stylize(s, TextStyle.Italic)
proc underline*(s: string): string =
  let trimmed = s.strip()
  if trimmed.len == 0:
    return s
  let leftSpaces = s.len - s.strip(leading = true, trailing = false).len
  let rightSpaces = s.len - s.strip(leading = false, trailing = true).len
  result = s[0..<leftSpaces] & stylize(trimmed, TextStyle.Underline) & s[^rightSpaces..^1]

proc blink*(s: string): string = stylize(s, TextStyle.Blink)
proc rapidBlink*(s: string): string = stylize(s, TextStyle.RapidBlink)
proc reverse*(s: string): string = stylize(s, TextStyle.Reverse)
proc hidden*(s: string): string = stylize(s, TextStyle.Hidden)
proc strikethrough*(s: string): string = stylize(s, TextStyle.Strikethrough)

when isMainModule:
  echo "--- Regular proc usage ---"
  echo red("This is red text")
  echo green("This is green text")
  echo blue("This is blue text")
  echo yellow("This is yellow text")
  echo magenta("This is magenta text")
  echo cyan("This is cyan text")
  echo white("This is white text")
  echo grey("This is grey text")
  echo bold("This is bold text")
  echo italic("This is italic text")
  echo underline("This is underlined text")
  echo underline("  Underline with spaces  ")
  echo strikethrough("This is strikethrough text")
  echo colorize("Custom styled text", Color.BrightGreen, styles = [TextStyle.Bold, TextStyle.Underline])
  echo colorize("Text with background", Color.White, Color.Blue, hasBg = true)

  echo "\n--- Method chaining usage ---"
  echo "This is red".red
  echo "This is green".green
  echo "This is blue".blue
  echo "This is yellow".yellow
  echo "This is magenta".magenta
  echo "This is cyan".cyan
  echo "This is white".white
  echo "This is grey".grey
  echo "This is gray".gray
  echo "This is bold".bold
  echo "This is italic".italic
  echo "This is underlined".underline
  echo "  Underline with spaces  ".underline
  echo "This is strikethrough".strikethrough
  echo "Custom styled text".color(Color.BrightGreen).bold.underline
  echo "Text with background".onColor(Color.Blue).white

  echo "\n--- Background color usage ---"
  echo bgRed("This has a red background")
  echo "This has a green background".bgGreen
  echo bgBlue("This has a blue background")
  echo "This has a yellow background".bgYellow
  echo bgMagenta("This has a magenta background")
  echo "This has a cyan background".bgCyan
  echo bgWhite("This has a white background")
  echo "This has a grey background".bgGrey

  echo "\n--- Mixed usage and chaining ---"
  echo red("This is ") & "a ".italic.green & bold("colorful ") & underline("string!").yellow
  echo "Mixing " & bold("bold") & " and " & underline("underline") & " and " & "colors".red & " in " & "one line".blue.italic
  echo "Red on green".red.bgGreen & " and " & "Blue on yellow".blue.bgYellow

  echo "\n--- Programmatic color selection ---"
  let userColor = "grey"
  echo colorize("This text is colored programmatically", userColor)
  echo "This text is also colored programmatically".color(userColor)
  echo "This has a programmatic background".onColor(userColor)

  # Test with different color names
  for colorName in ["red", "blue", "yellow", "magenta", "cyan", "white", "grey", "gray", "brightgreen", "brightblue"]:
    echo colorize("This is " & colorName, colorName)
    echo colorize("This has " & colorName & " background", Color.White, getColorFromString(colorName), hasBg = true)