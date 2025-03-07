# util/higherlighter.nim
import pkg/colors

const nimKeywords = [
  "addr", "and", "as", "asm", "bind", "block", "break", "case", "cast",
  "concept", "const", "continue", "converter", "defer", "discard", "distinct",
  "div", "do", "elif", "else", "end", "enum", "except", "export", "finally",
  "for", "from", "func", "if", "import", "in", "include", "interface", "is",
  "isnot", "iterator", "let", "macro", "method", "mixin", "mod", "nil", "not",
  "notin", "object", "of", "or", "out", "proc", "ptr", "raise", "ref",
  "return", "shl", "shr", "static", "template", "try", "tuple", "type",
  "using", "var", "when", "while", "xor", "yield"
]

const nimTypes = [
  "int", "float", "string", "bool", "char", "byte", "uint",
  "int8", "int16", "int32", "int64",
  "uint8", "uint16", "uint32", "uint64",
  "float32", "float64", "seq", "array", "void"
]

proc highlightNimCode*(code: string): string =
  var inString = false
  var inChar = false
  var wordStart = 0
  var i = 0
  result = ""

  template addWord(start: int, ending: int) =
    let word = code[start..<ending]
    if word.len > 0:
      if word in nimKeywords:
        result.add word.red
      elif word in nimTypes:
        result.add word.yellow
      else:
        result.add word

  while i < code.len:
    case code[i]
    of '#':  # Comments
      if not inString and not inChar:
        addWord(wordStart, i)
        wordStart = i
        while i < code.len and code[i] != '\n':
          i.inc
        result.add code[wordStart..<i].green
        wordStart = i
        continue
    of '"':  # Strings
      if not inChar:
        if not inString:
          addWord(wordStart, i)
          wordStart = i
        if i == 0 or code[i-1] != '\\':
          inString = not inString
          if not inString:
            result.add code[wordStart..i].cyan
            wordStart = i + 1
    of '\'':  # Characters
      if not inString:
        if not inChar:
          addWord(wordStart, i)
          wordStart = i
        if i == 0 or code[i-1] != '\\':
          inChar = not inChar
          if not inChar:
            result.add code[wordStart..i].cyan
            wordStart = i + 1
    of ' ', '\n', '\t', '(', ')', '[', ']', '{', '}', ',', '.', ';', ':', '+', '-', '*', '/', '=', '<', '>', '!':
      if not inString and not inChar:
        addWord(wordStart, i)
        result.add code[i]
        wordStart = i + 1
    else:
      discard
    i.inc

  # Add any remaining word
  if wordStart < code.len:
    addWord(wordStart, code.len)