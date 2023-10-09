#import "../../utils.typ": *

#section("Syntax based translation")
- Annotations for syntax rules
  - attributes for symbols
  - semantic rules per syntax rule
  - semantic actions inside of syntax rules
- usage: additional actions during parsing
  - type checks
  - generate syntax tree
  - code-generation
  - direct evaluation
- limitations
  - only really used for parsing of syntax-tree
  - very complex and convoluted

#subsection("Example")
You can define rules with this, which have to adhere to a certain rule, here the
numbers always have to match according to mathematical rules.
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_10_09_08_30_31.png", width: 100%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_10_09_08_27_51.png", width: 100%)],
  )
])

#section("Parser Categories")
#align(
  center,
  [#image("../../Screenshots/2023_10_09_08_41_34.png", width: 30%)],
)
- First Letter: L -> left to right
- Second Letter: L -> Top-Down Parser, R -> Bottom-Up Parser
- Third Letter: k -> how many symbols are looked ahead -> LL(1) would be the
  parser for the module

#section("Bottom-Up Parser")
- read token without fixed goal
  - check with each step if read tokens can be reduced into an EBNF-rule
  - reduce if possible or continue reading if not
- at the end 1 last symbol remains, the starting symbol, otherwise syntax error

#columns(2, [
  #text(green)[Benefits]
  - more powerful than LL(k) parser -> left-recursion easy
  #align(
    center,
    [#image("../../Screenshots/2023_10_09_08_57_41.png", width: 100%)],
  )
  #colbreak()
  #text(red)[Benefits]
  - less performant
])

#subsection("Token actions")
Per token, you can have 4 different actions that you can take:
- SHIFT
- REDUCE
- ACCEPT
- ERROR

#subsection("Example")
Rules for the example:
#align(
  center,
  [#image("../../Screenshots/2023_10_09_08_55_27.png", width: 60%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_09_08_55_54.png", width: 100%)],
)

#subsection("Bottom-Up categories")
- LR(0)
  - parse table without lookahead
  - state must be enough to parse
- SLR(k) (Simple LR)
  - lookahead on reduce to solve conflicts
  - no new states
- LALR(k) (Look-Ahead LR)
  - analyzes language based on LR(0) conflicts
  - uses lookahead to solve conflicts with new states
- LR(k)
  - per grammarstep + lookahead a new state
  - not usable in production -> too many states

#subsection("LR Parser implementation")
1. change grammar
  - into BNF
2. calculate state machine
  - item, handle, closure, goto
3. build parse table
  - FOLLOWS-Set

#subsubsection("Change Grammar")
#align(
  center,
  [#image("../../Screenshots/2023_10_09_09_03_31.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_09_09_03_57.png", width: 80%)],
)

#subsubsection("Calculate State Machine")
#subsubsubsection("Item")
#text(teal)[On which item are we currently?]
#align(
  center,
  [#image("../../Screenshots/2023_10_09_09_05_12.png", width: 80%)],
)

#subsubsubsection("Closure")
#text(teal)[What can possibly follow after the item?]
#align(
  center,
  [#image("../../Screenshots/2023_10_09_09_05_33.png", width: 80%)],
)

#subsubsubsection("Goto")
#text(teal)[How much do we move forward?]
#align(
  center,
  [#image("../../Screenshots/2023_10_09_09_06_18.png", width: 80%)],
)

#subsubsubsection("State Machine for example")
#align(
  center,
  [#image("../../Screenshots/2023_10_09_09_11_16.png", width: 100%)],
)

#subsubsubsection("Follows Set")
#text(
  teal,
)[All possible terminal symbols that can follow after a non-terminal symbol.]
#align(
  center,
  [#image("../../Screenshots/2023_10_09_09_12_06.png", width: 80%)],
)

#subsubsubsection("Parse Table")
#align(
  center,
  [#image("../../Screenshots/2023_10_09_09_13_09.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_09_09_15_33.png", width: 100%)],
)

- very complicated
- conflicts possible
  - shift-reduce conflicts
  - reduce-reduce conflicts
  - possibly change grammar to solve conflicts
  - use bigger lookaheads

#subsubsubsection("AntLR4 for smallj")
#align(
  center,
  [#image("../../Screenshots/2023_10_09_09_18_55.png", width: 60%)],
)

#subsection("LR vs LL in usage")
#align(
  center,
  [#image("../../Screenshots/2023_10_09_09_17_13.png", width: 60%)],
)
Powerfulness:
#align(
  center,
  [#image("../../Screenshots/2023_10_09_09_18_00.png", width: 60%)],
)
