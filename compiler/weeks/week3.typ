#import "../../utils.typ": *

#section("Parser")
Turns tokens into a parse tree, meaning it can check syntax. -> type must be
before variable. Note that it does not offer semantic checking, aka will it
compile etc. It only offers what clangd offers in templates, aka syntax only.
- creates syntax tree
  - must be valid
  - only one tree possible, otherwise syntax ambiguous
#columns(
  2,
  [
    *Parse tree / Concrete syntax tree* | complete view of tokens as syntax tree
    #align(
      center,
      [#image("../../Screenshots/2023_10_02_08_17_28.png", width: 80%)],
    )
    #colbreak()
    *Abstract syntax tree* | Simplified view, everything unnecessary removed
    #align(
      center,
      [#image("../../Screenshots/2023_10_02_08_18_06.png", width: 80%)],
    )
  ],
)

#columns(2, [
  *Top Down Parsing*
  #align(
    center,
    [#image("../../Screenshots/2023_10_02_08_20_20.png", width: 100%)],
  )
  #colbreak()
  *Bottom Up Parsing*
  #align(
    center,
    [#image("../../Screenshots/2023_10_02_08_20_51.png", width: 100%)],
  )
])

#subsection("Recursive Descent parser code")
```cs
// Expression = Term { ( "+" | "-" ) Term }.
void ParseExpression() {
  ParseTerm();
  while (Is(Tag.PLUS) || Is(Tag.MINUS)) {
    _stream.Next();
    ParseTerm();
  }
}
```
Recursive descent defines a function for every non-terminal token, this makes it
easy to parse said tokens. Also note that these tokens need to be recursive as
their name implies that you need to go through it multiple times to receive
terminal tokens.

#subsection("Predictive Direct vs Backtracking")
Predictive direct makes it clear which function(which token will be parsed) will
be called when, backtracking on the other hand will try a random parser until it
fails, then goes to the next parser to try again. (Backtracking is used for the
lexer, for the parser we don't want this since we have only one tree either way,
otherwise the syntax is wrong and we can't make a real parser either way!!)

#subsection("Lookahead")
Many tokens require multiple specific tokens in a row to be valid, for these we
need lookahead for tokens. For this we need a way to view tokens without calling
Next(), which would take these tokens away.

#subsubsection("Multi lookahead")
Sometimes multiple tokens have the same next token, which means we will have to
lookahead further than just one token. In this case we can *reform* the tokens
with new tokens that will make it possible to use 1 lookahead.
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_10_02_08_56_46.png", width: 100%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_10_02_08_43_28.png", width: 80%)],
  )
])

#subsection("Left-recursion vs EBNF-Repetition")
//typstfmt::off
#columns(2, [
  ```cs
  // Sequence = Sequence ["s"].
  void ParseSequence() {
    ParseSequence();
    if (!_stream.IsEnd) {
      if (_stream.Current == ‘s’) {
        _stream.Next();
      } else {
        Error();
      }
    }
  }
  ```
  #text(red)[Problem: endless recursion possible!]
  #colbreak()
  ```cs
  // Sequence = {"s"}.
  void ParseSequence() {
    while (!_stream.IsEnd()) {
      if (_stream.Current == ‘s’) {
        _stream.Next();
      } else {
        Error();
        break;
      }
    }
  }
  ```
  #text(green)[better]
])
//typstfmt::on

#subsection("Class syntax tree")
#columns(2, [
#align(center, [#image("../../Screenshots/2023_10_02_08_53_30.png", width: 100%)])
#colbreak()
#align(center, [#image("../../Screenshots/2023_10_02_08_54_17.png", width: 100%)])
])

#subsection("Statement syntax tree")
#align(center, [#image("../../Screenshots/2023_10_02_08_53_57.png", width: 80%)])

#subsection("Creation of Parse Nodes")
//typstfmt::off
```cs
ExpressionNode ParseFactor() {
  if (IsOperator(UNARY_OPERATORS)) {
    return ParseUnaryExpression();
  } else if (Is(Tag.OPEN_PARENTHESIS)) {
    int start = currentStart;
    _stream.Next();
    var expression = ParseExpression();
    Check(Tag.CLOSE_PARENTHESIS);
    if (IsIdentifier()) {
      return ParseTypeCast(start, expression);
    } else {
      return expression;
    }
  } else {
    return ParseOperand();
  }
}
```
//typstfmt::on

#subsubsection("Errors in tokens")
//typstfmt::off
```cs
if (Is(Tag.RIGHT_PARENTHESIS)) {
  _stream.Next();
} else {
  Error(") missing");
}
```
//typstfmt::on

#subsubsection("Skippable errors")
Sometimes errors make it impossible to parse something, in that case we might want to just move to the next top token, for example a class and try to parse that again. -> Compiler should be fast
//typstfmt::off
```cs
Expression ParseTerm() {
  if (!IsNumber() || !Is(Tag.LEFT_PARENTHESIS)) {
    Error("invalid term");
    while (!IsNumber() && !Is(Tag.LEFT_PARENTHESIS)
           && canSkip()) {
    _stream.Next();
  }
}
```
//typstfmt::on
