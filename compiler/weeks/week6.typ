#import "../../utils.typ": *

#section("Code Generation")

#subsection("Evaluation Stack")
Processors use registers in order to execute instructions, meanwhile, virtual
machine languages like jafuck use evaluation stacks in order to evaluate
instructions.
#align(
  center,
  [#image("../../Screenshots/2023_10_23_08_13_01.png", width: 70%)],
)

- each instruction has a defined amount of
  - pop calls
  - push calls
- one stack per method call
  - stack will be empty at the start and at the end of the method
- stack has no limit on capacity
  - for any complexity
  - if overflow OS/cpu will restrict

Just like with assembly, you first setup parameters and then local variables:
#align(
  center,
  [#image("../../Screenshots/2023_10_23_08_16_24.png", width: 70%)],
)
Or here how a while loop would be converted:
#align(
  center,
  [#image("../../Screenshots/2023_10_23_08_21_49.png", width: 70%)],
)

#subsubsection("Example")
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_08_18_20.png", width: 80%)],
  )
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_08_18_30.png", width: 80%)],
  )
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_08_18_40.png", width: 80%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_08_18_50.png", width: 80%)],
  )
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_08_19_08.png", width: 80%)],
  )
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_08_19_18.png", width: 80%)],
  )
])

#subsection("metadata")
- intermediary language
  - knows class names, types, filed, methods
  - knows method names, parametertypes, return types
  - knows local variables and their types
- no specific memory layout -> it's a virtual machine...
- doesn't include
  - names of local variables and parameters -> they are enumerated
  - int kappa = 7 > 1: INT -> 7

#subsection("Code Generation Methods")
+ traverse symboltable
  - create bytecode metadata
+ traverse AST per method(visit)
  - create instructions via bytecode assembler
+ serialize output

#subsection("Instruction Variations")
#align(
  center,
  [#image("../../Screenshots/2023_10_23_08_44_12.png", width: 90%)],
)
#text(teal)[It's a loop...]

#subsubsection("General")
#align(
  center,
  [#image("../../Screenshots/2023_10_23_08_14_53.png", width: 70%)],
)

#subsubsection("Negate Instruction")
#align(
  center,
  [#image("../../Screenshots/2023_10_23_08_21_30.png", width: 70%)],
)

#subsubsection("Compare Instructions")
#align(
  center,
  [#image("../../Screenshots/2023_10_23_08_21_05.png", width: 70%)],
)

#subsubsection("Branch Instruction")
#align(
  center,
  [#image("../../Screenshots/2023_10_23_08_22_21.png", width: 70%)],
)

#subsubsection("Returns")
#text(red)[Keyword: ret]
#align(
  center,
  [#image("../../Screenshots/2023_10_23_08_33_32.png", width: 70%)],
)

#subsubsection("Method Calls")
#align(
  center,
  [#image("../../Screenshots/2023_10_23_08_28_38.png", width: 70%)],
)
Note, static is exactly what it means -> without object instance, or global
instance, while virtual here means object dependent function -> jafuck is always
virtual cuz we hate performance.

#pagebreak()
#columns(2, [
  static:\
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_08_29_59.png", width: 60%)],
  )
  #colbreak()
  virtual/object based:\
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_08_30_31.png", width: 100%)],
  )
])

#subsubsection("Backpatching")
Labels as also seen in assembly are only for humans to make it easier to read,
later on these will be replaced with offets:
#align(
  center,
  [#image("../../Screenshots/2023_10_23_08_47_34.png", width: 40%)],
)
E.g. before the brfalse would have had a proper label

#subsection("Templating ByteCode Generation")
Templating makes code generation easier:
#align(
  center,
  [#image("../../Screenshots/2023_10_23_08_34_38.png", width: 70%)],
)

#pagebreak()
#subsubsection("Example")
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_09_01_29.png", width: 90%)],
  )
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_09_01_36.png", width: 90%)],
  )
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_09_01_46.png", width: 90%)],
  )
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_09_01_58.png", width: 90%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_09_02_05.png", width: 90%)],
  )
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_09_02_12.png", width: 90%)],
  )
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_09_02_39.png", width: 90%)],
  )
  #align(
    center,
    [#image("../../Screenshots/2023_10_23_09_02_58.png", width: 90%)],
  )
])

#pagebreak()
#subsubsection("Conditionals")
#align(
  center,
  [#image("../../Screenshots/2023_10_23_09_04_57.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_23_09_05_11.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_23_09_05_26.png", width: 80%)],
)

#subsubsection("While in Visitor")
//typstfmt::off
```java
@Override
public void visit(WhileStatementNode node) {
  var beginLabel = assembler.createLabel();
  var endLabel = assembler.createLabel();
  assembler.setLabel(beginLabel);
  node.getCondition().accept(this);
  assembler.emit(IF_FALSE, endLabel);
  node.getBody().accept(this);
  assembler.emit(GOTO, beginLabel);
  assembler.setLabel(endLabel);
}
```
//typstfmt::on


#subsubsection("Optimization")
Certain parts are handled with constants -> 6+2 somewhere in code can be
redefined to 8, does not need to be run!
#align(
  center,
  [#image("../../Screenshots/2023_10_23_08_32_42.png", width: 60%)],
)
