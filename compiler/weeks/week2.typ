#import "../../utils.typ": *

#section("lexical analysis")
What does a lexer do?
- turns program code into tokens
- eliminates whitespaces, comments and other useless characters for compiler
- marks positions in programcode for error propagation to user -> LSP, debugging

Uses of a lexer
- abstraction
  - parser has guarantee that tokens are already generated
- simplicity
  - parser uses lookahead per token, not per character
- efficiency
  - lexer doesn't use stack, unlike parser -> next tokens etc.

#subsection("Lexem")
a specific series of characters that represent a token.\
For example "MyStruct" is the lexem for a specific struct token.

#subsubsection("Lexer language support")
Lexers only support regular languages, this means that *only non-recursive
languages are supported.*\
Note, this is specific to tokens, *multiple tokens can later be parsed into a
non-regular language*.\
#align(center, [#image("../../Screenshots/2023_09_25_08_17_57.png", width: 70%)])
#align(center, [#image("../../Screenshots/2023_09_25_08_20_00.png", width: 50%)])

Note, sometimes languages can be restructured, which can lead to a language not
being regular, or being regular:
#align(center, [#image("../../Screenshots/2023_09_25_08_22_16.png", width: 50%)])
#text(
  teal,
)[Note the note below, pumping lemma for proving a language not to be regular.]

#subsubsection("Lexer Tokens")
#subsubsubsection("Identifier")
- identifier for classes, methods, variables etc
- starts with a character, after that numbers are allowed
  - no whitespace allowed though!
```rs
//Identifier = Letter { Letter | Digit }.
//Letter = "A" | ... | "Z" | "a" | ... | "z".
//Digit = "0" | ... | "9".
```

#subsubsection("lexer as finite automaton")
A lexer absorbes as much as possible from the input to a token.\
This means that something like "my1234Name" will all convert into an identifier,
not into identifier, number, identifier.
#align(center, [#image("../../Screenshots/2023_09_25_08_27_30.png", width: 50%)])

#subsubsection("Comments in lexer")
- are skipped by lexer
- can be blocks
  - however, can't be boxed -> not recursive, again, lexer only supports regular
    languages
- or can be a line -> \/\/ end of line defines end of comment

#subsubsection("Tokens in lexer")
#align(center, [#image("../../Screenshots/2023_09_25_08_33_31.png", width: 70%)])
- FixToken These are tokens that represent reserved *keywords or operators*. ```rs
   pub Enum Tag {
   CLASS, ELSE, IF, RETURN, WHILE, // keywords
   AND, OR, PLUS, MINUS, SEMICOLON // operators
   }
   ```
  #text(
    teal,
  )[Note, reserved typenames should be considered to be identifiers instead!]
- IdentifierToken variables, method names etc
- IntegerToken token for int value
- StringToken token for string value
- ...

#align(center, [#image("../../Screenshots/2023_09_25_08_42_11.png", width: 70%)])
each token is read by one lexer that is specific for this token.

#subsubsection("Lexer Example")
```cs
class CharReader {
  int Position { get; }
  char Current { get; }
  bool End { get; }
  SourceReader(TextReader reader) {
      // ...
  }
  void Next() {}
}
```
Lexer class:// typstfmt::off
```cs
class Lexer {
  private IEnumerable<Token> Lex(TextReader reader, …) {
    var source = new SourceReader(reader);
    var tokenLexers = new TokenLexer[]{
    new NameTokenLexer(source, diagnostics),
    new IntegerTokenLexer(source, diagnostics),
    new FixTokenLexer(source, diagnostics),
    new SlashTokenLexer(source, diagnostics),
    new StringTokenLexer(source, diagnostics)
  };
  source.Next();
  One character lookahead
  SkipBlanks(source);
  while (!source.End) {
    if (TryLexToken(…, out var token)) yield return token!;
  else { // ... error
    SkipBlanks(source);
  }
}

// eliminate whitespaces
private bool TryLexToken(tokenLexers, out Token? token) {
  foreach (var lexer in tokenLexers) {
    if (lexer.TryLex(out token)) return true;
    // ...
  } // ...
    return false;
}
```

IntegerTokenLexer:
```cs
private bool IntegerTokenLexer() {
  if (!IsDigit()) {
    token = default;
    return false;
  }
  int value = 0;
  while (!IsEnd && IsDigit()) {
    int digit = Current - '0’;
    value = value * 10 + digit;
    // note, here should check for values that are too big
    Next();
  }
  token = new IntegerToken(value);
  return true;
}
```
NameTokenLexer:
```cs
private bool NameTokenLexer() {
  if (!IsLetter()) {
    token = default;
    return false;
  }
  string name = Current.ToString();
  Next();
  while (!IsEnd && (IsLetter() || IsDigit())) {
    name += Current;
    Next();
  }
  token = Keywords.TryGetValue(name, out var tag) ? new FixToken(tag) : new IdentifierToken(name);
  return true;
}
```
Remove Comments:
```cs
private void SkipLineComment() {
  Next(); // skip second slash
  while (!IsEnd && Current != '\n’) {
    Next();
  }
}
```
// typstfmt::on
General mechanism, the out parameter is the stream of code, which will then be used on each lexer individually until one lexer matches and creates a token.\
This is handled with the bool return on each lexer.

#subsubsection("Lexer Expansions")
- keep track of line
  - for errors and debugging
  - save line in tokens
- extras in other languages
  - character literals instead of strings
  - string/character escaping
  - hex or other values
  - floats
- error handling
  - errors
    - unexpected end of token
    - string or comment not terminated
    - values too big or too small
  - error  handling
    - panic mode: exceptions
    - #text(teal)[return error token (please use this)]
    - autocorrect, replace etc.

#subsubsection("Lexer Generators")
These tools can generate lexers for a specific language.
#align(center, [#image("../../Screenshots/2023_09_25_09_10_08.png", width: 70%)])
Usage:
```rs
// grammar SmallJ;
//  // lexer rules
// Identifier: Letter (Letter | Digit)*;
// Integer: Digit+;
// String: '"' .* '"';
// Letter: [A-Za-z];
// Digit: [0-9];
// Whitespaces: [ \t\r\n]+ -> skip;
```
#columns(2, [
benefits:
- less programming
- less silly mistakes
#colbreak()
negatives:
- errors often unclear
- temporary view is predefined
- verbose generated code
- dependency on tooling
])

