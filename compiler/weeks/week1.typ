#import "../../utils.typ": *

#section("The 3 architectures")
- system languages
- byte code languages
- runtime languages

#subsection("System languages")
Compiler -> Machine code\
byte code languages -> compiler -> byte code -> JIT(just in time) compiler ->
runtime\
runtime languages -> JIT compiler -> runtime

#section("Compiler architecture")
- #text(red, size: 15pt)[lexer] (lexical analysis)
  - input: written code from programmer
  - output: terminalsymbols/_tokens_
- #text(red, size: 15pt)[parser] (syntax analysis)
  - output: syntax tree
- #text(red, size: 15pt)[semantic checker] (semantic analysis)
  - output: temporary view
- #text(red, size: 15pt)[optimization] (optional)
  - output: temporary view
- #text(red, size: 15pt)[code generation]
  - machine code / byte code etc, depends on language architecture
- #text(red, size: 15pt)[temporary view] (intermediate representation)
  - defines code as data structure -> machine code

#section("Runtime")
#align(center, [#image("../../Screenshots/2023_09_18_08_43_01.png", width: 30%)])
- #text(red, size: 15pt)[loader]
  - loads machine code into memory, starts execution
- #text(red, size: 15pt)[Interpreter]
  - reads instructions and emulates this software
- #text(red, size: 15pt)[JIT (Just In Time) Compiler]
  - translates code into hardware instructions
  - this is the entire reason why js is cross platform. A JIT exists for every
    platform.
- #text(red, size: 15pt)[Hardware instruction -> native instruction]
  - instruction supported natively on hardware
- #text(red, size: 15pt)[metadata, heap + stack]
  - handlings of infos, objects, lifetimes etc
- #text(red, size: 15pt)[Garbage Collection]
  - automatic freeing of memory (evil)

#section("Syntax and Semantic")
- #text(red, size: 15pt)[Syntax]
  - defines forms and rules for language
  - defined by
    - amount of tokens/terminalsymbols
    - amount of non-terminal symbols (tokens that have multiple meanings -> result of
      a production)
    - amount of productions (syntax rule)
    - start symbol

- #text(red, size: 15pt)[Semantic]
  - defines meaning of program

#section("EBNF (Extended Backus-Naur Form)")
This is the grammar definition language.\
It can be used to create things like calculators or syntax rules for programming
languages.\
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_09_18_09_08_39.png", width: 100%)],
  )
  #colbreak()
  #align(center, [#text(red, size: 15pt)[Rules for EBNF]])
  #align(
    center,
    [#image("../../Screenshots/2023_09_18_09_09_15.png", width: 100%)],
  )
])
- #text(
    teal,
    size: 12pt,
  )[Original Backus Naur form with := instead of = and without repeatable tokens]
- #text(
    teal,
    size: 12pt,
  )[ISO Version with semicolon at the end -> something = \[ "(" something ")" \]];
- #text(teal, size: 12pt)[ABNF -> Augmented Backus Naur Form];

Special cases:\
- """ -> this is considered to be a token/terminalsymbol
- "A" | .. | "Z" -> is considered to be a symbol between A and Z
- _*Whitespaces are ignored*_
  - unless syntax considers them -> python F\#
- Comments are also ignored

#subsection("Example Grammar for calculator")
```rs
 // standard grammar for calculator
 // made with original Backus Naur Form -> this version has no repeatable tokens
 // exp := term | exp + term | exp - term
 // term := factor | factor * term | factor / term | factor % term
 // factor := number | ( exp )
```
compared to a simpler example: (not a full calculator)
#columns(
  2,
  [
    #image("../../Screenshots/2023_09_18_09_22_56.png", width: 70%)
    #colbreak()
    Here the optional parts are marked with {} which makes the grammar smaller,
    however it also makes it harder to read imo.\
  ],
)

#subsection("Ambiguous Syntax")
#columns(
  2,
  [
    #align(
      center,
      [#image("../../Screenshots/2023_09_18_09_41_40.png", width: 100%)],
    )
    The issue is that there is no clear rule which expression to evaluate first.\
    Here one would have to change the first expression to number in order to fix
    this issue.
    #colbreak()
    #align(
      center,
      [#image("../../Screenshots/2023_09_18_09_42_10.png", width: 100%)],
    )
  ],
)
