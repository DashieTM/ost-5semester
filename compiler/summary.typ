#set page(
  "a4", columns: 4, flipped: true, foreground: [
    #columns(4, [#line(stroke: .5pt + black, start: (105%, 2%), end: (105%, 98%)),
      #colbreak()
      #line(stroke: .5pt + black, start: (-51%, 2%), end: (-51%, 98%))
      #colbreak()
      #line(stroke: .5pt + black, start: (-54%, 2%), end: (-54%, 98%))
    ])

  ], margin: 12pt,
)
#set columns(gutter: 2pt)
#set text(12pt, font: "Arial", spacing: 50%, stretch: 10%)
#set list(spacing: 0pt, tight: true, body-indent: 0em)
#set block(below: 0.5em)

#text(blue)[*Lexer*]\
- Input: text, Output: Tokens (Lexems)
- remove comments and whitespaces
- remember error location for debugging purposes
- token: fixtoken, identifiertoken, stringtoken, integertoken
#text(blue)[*Regular Language*]\
A language is only regular in EBNF if it doesn't feature recursion.\
A lexer can only use regular languages, as it's otherwise not deterministic.
Integer = Digit [ Integer ]. should be made to Integer = Digit { Digit }.
- #text(red)[Lexer: regular language]
- #text(red)[parser: context free language]
- #text(red)[semantic checker: context-sensitive language]
#text(blue)[*Extended Backus Naur*]\
Expression = "A" "B" | { "B" } | [ "C" ]\
Term = Expression + "Number" A and B OR\
one or more B OR 0 or more C\
#text(red)[Note, for a lexer, the grammar needs to be specific:]
Expression = "Number" | Expression + Expression\
This results in issues since the resulting grammar can mean number + expression
or expression + number\
#text(blue)[*Parser*]\
Input: tokens, Output: Syntax Tree and/or AST(Abstract Syntax Tree)\
recursive rules allowed here -> not regular\
bottom-up(LR(k)) or top-down(LL(k))\
L: left to right, LR: top or bottom, k: lookup amount\
- top-down: Expr → Term + Term → ... → 1 + (2 - 3)
#text(blue)[*Recursive Descent*]\
- one function per non terminal symbol
  - parseExpression, parseTerm, parseFactor
- lookahead -> tokens.peek() or similar
  - can be 1 or more
  - also resolved by restructuring EBNF
- stack via method calls -> push down automaton
- predictive direct, always clear what is taken, (preferred)
- backtracking, just don't dude
#text(blue)[*Bottom Up:*]Expr ← Term + Term ← ... ← 1 + (2 - 3)\
- read until reduceable -> aka until match rule in EBNF
  - SHIFT, REDUCE, ACCEPT, ERROR
- if no match is found shift -> aka move right with token
- #text(red)[less performance, but more powerful compared to LL]
- LR(0) -> no lookup, table(EBNF) is enough
- SLR(k) (Simple LR)
  - lookahead on reduce to solve conflicts
  - no new states
- LALR(Look-Ahear LR)
  - analyzes language on LR(0) conflicts
  - uses lookahead on conflicts with solves it with new states
- LR(k)
  - per (grammar step + lookahead) one state
  - not pragmatical
#text(blue)[*Semantic Analysis*]\
- different scopes -> global scope, method scope etc.
- differentiation between reference and primitive types
  - reference variables need additional information
- structure\
  1: create all declared types\
  traverse AST, start with global scope\
  2: resolve types of all declarations\
  go into identifier and resolve to declaration\
  add ClassSymbol, TypeSymbols etc into variable symbols\
  3: resolve usage of types in AST\
  add type to symbol\
  4: check types in AST\
  post-order traversal -> check if types match\
  additional checks:\
  operators ,redeclarations, only one main method, array length read only, return
  methods match, left hand of expression
#text(blue)[*Code Generation*]\
- turns code into either byte-code or machine-code
- usually done with evaluation stack
- registers for machine code (not for byte code!)
- byte code languages need to store additional metadata -> types etc
  - variable names will still be stored as numbers -> mangling
- structure
  + traverse symboltable
    - create bytecode metdata
  + traverse AST per method
    - create instructions via bytecode assembler
  + serialize in output format
- backpatching: expressions that move lines up or down...
- traversal order:
  - expressions: post-order
  - statements: depends on code template
- parameters: load like in assembly
#text(blue)[*VM*]\
#text(blue)[*Loader*]\
- loads file into memory
- creates metadata for classes and methods, variables, etc.
  - defines layouts for fields, variables, parameters
  - resolves references to methods, types and other assemblies → patching
- initializes program -> interpreter or JIT
- optional: Code verification
#text(blue)[*Interpreter*]\
- interpreter loop
  - emulates one instruction after the other
- instruction pointer (IP)
  - address of the next instruction
- evaluation stack
  - virtual version for the VM
- locals and parameters for active methods
- method descriptor for active method
- terms:
  - activation frame -> data of current method, including its own evaluation stack
  - call stack -> stack of activation frames according to call order
    - call stack managed for interpreter -> unmanaged in HW
#text(blue)[*Verification*]\
- check for errors or manipulation
  - at runtime -> verification in interpreter\
    check types -> CheckInt(Pop()), check jumps, check op codes, stack over or
    underflow, index bounds etc.
  - at loading -> static analysis
#text(blue)[*OOP shit*]\
- Ancestor Table -> Array
  - first: root parent, last: self
  - works only on single inheritance, but has constant time
- Vtable
  - linear -> one by one, works only with single inheritance
  - fixed method -> each method has a fixed position in the Vtable
- Vtable interfaces:
  - fixed method is hard with multiple interfaces!
  - double array: store methods in a separate array for each interface
    - flexible, but costs memory and has indirection overhead
  - offset based: more complex, but solves the issue
#text(blue)[*Garbage Collector*]\
- can only be done with metadata -> gc without it is not feasible!
  - behavior based gc have been tried, they do not work
- solves dangling pointers and memory leaks
- structure\
  1: (mark phase)mark all objects in root set
  - Pointer Rotation Algorithm
  - or just traverse recursive (requires more memory!)
  2: (sweep phase)if marked(linear scan), ignore, else free\
  #text(purple)[Note, this requires the program(mutator) to stop running.]
- root set
  - pointers in parameter, local variables, evaluation stack and this-reference
#text(blue)[*Free List*]\
- holds pointers to free memory
- various allocation strategies
  - first-fit -> (default) first fitting block
  - best fit -> sort ascending on size, creates unusable fragments
  - worst fit -> sort descending on size -> find block immediately
- segregated free list -> different free list with different blocksizes can exist
- #text(purple)[remerge empty space on sweep]
- buddy system -> linux -> take smallest block possible divide by 2
  - if bigger than double your memory -> divide block by 2
  - remerging of divided empty blocks
#text(blue)[*Reference Counting*]\
- can also solve garbage collection
- uses strong and weak references
- so called "teure" updates
- atomic or unatomic
#text(blue)[*Finalizer*]\
- run when object becomes garbage -> after mark
  - can lead to resurrection in java
    - done via finalizer set which has weak reference
    - put into pending queue which gets a *new* strong reference
      - hence object not cleaned
      - #text(red)[GC now requires 2 mark phases before sweep!]\
        One with finalizer and one without
  - can create new objects
  - can potentially crash
  - runs only once (optional rerun for dotnot)
  - *order of finalizer is undefined!*
#text(blue)[*other GCs*]\
- Compacting GC -> mark and copy
  - allocate at end of list and copy non garbage to front
  - not possible without metadata
- Incremental GC
  - ""parallel"" to program -> small increments of GC -> GO
  - Generational GC -> G2, G1, G0
    - old objects live longer
    - references from old to new
    - if old is cleaned -> newer cleaned 
    - objects move from one generation to the other
    - write barriers when writing into references of other generations
  - Paritioned GC
    - move objects into an empty partition, sweep now fully garbage partition
    - concurrent marking with a second mark phase that stops program
    - requires forwarding pointers for concurrent *evacuation* of objects
      - *and read barriers*!
#text(blue)[*JIT*]\
- hot spot -> code that is run again and again -> usually loops
  - checked with profiling -> how many times did i run this code -> increment
#text(blue)[*Processor Registers*]\
- local AL bit 0-7, AH bit 0-7, AX bit 0-15, EAX bit 0-31, RAX bit 0-63, RSP stack
  pointer, RBP base pointer, RIP instruction pointer
- global (depends on OS)
  - RDI, RSI, RDX, RXS, R8, R9
  - #text(
      purple,
    )[used for parameters -> global are not overwritten on function call!]
- register clobbering
  - some operations overwrite registers, make sure you saved values from there
    before (idiv -> RAX RDX)
- op codes in smallj -> 1-p parameters -> p+1 - unlimited locals
#text(blue)[*Code Optimization*]\
- convert divisions, multiplications and modulo to bit operations -> cheaper
- run expressions in code at compile time
  - constant propagation -> can also apply to variables that do not change!
- expressions that do not change in loops can be extracted into a variable -> no
  op
  - in general multiple operations for the same value -> into variable
- removal of dead code
- redundant code e.g. unnecessary variables removed and expression inlined,
  reversal of extraction
  - copy propagation
- Static Single Assignment (SSA)
  - re-assigment to new variable, this allows for numbering of variable
  - if old variable is never used, drop
- Peephole Optimization
  - peek next op codes, substitution op
