#import "../../utils.typ": *

#section("Virtual Machine")
#align(
  center,
  [#image("../../Screenshots/2023_11_06_08_06_48.png", width: 80%)],
)

#subsection("Loader")
- *loads temporary code into memory*
- *creates metadata for classes, methods, variables and code*
  - defines layouts for fields, variables, parameters
  - resolves references to methods, types and other assembly address relocation
- *initiates execution*
  - interpreter or JiT compiler
- *optional: code verification*

#subsubsection("Metadata")
#align(
  center,
  [#image("../../Screenshots/2023_11_06_08_13_26.png", width: 80%)],
)

#subsubsubsection("Descriptors")
- classes
  - field types
  - methods
    - types of parameters, local variables and return type
    - bytecode
- arrays
  - element type

Type descriptor:
#align(
  center,
  [#image("../../Screenshots/2023_11_06_08_15_13.png", width: 60%)],
)
Class&Method Descriptor
#align(
  center,
  [#image("../../Screenshots/2023_11_06_08_15_49.png", width: 70%)],
)

#subsubsection("ByteCode Loading")
The descriptors explained above will replace the classes, methods, etc.\
In other words we don't want the simple types anymore, now we need all the
description about it -> what methods does the class have, etc.
#align(
  center,
  [#image("../../Screenshots/2023_11_06_08_17_18.png", width: 80%)],
)
This is done via patching, aka we go through the code and replace the usage of a
class with the descriptor:
#align(
  center,
  [#image("../../Screenshots/2023_11_06_08_18_53.png", width: 80%)],
)

#subsection("Interpreter")
The interpreter goes through the bytecode instructions one by one and executes
them dynamically:
#align(
  center,
  [#image("../../Screenshots/2023_11_06_08_20_47.png", width: 100%)],
)
- interpreter loop
  - emulates each instruction one after the other
- instruction pointer(IP)
  - address of next instruction
- evaluation stack
  - for virtual stack processor
- locals & parameters
  - for active method
- method descriptor
  - for active method

#align(
  center,
  [#image("../../Screenshots/2023_11_06_08_36_59.png", width: 60%)],
)

Loop: ```cs
while (true) {
 var instruction = code[instructionPointer];
 instructionPointer++;
 Execute(instruction);
}
```

execute: ```cs
switch(instruction.OpCode) {
 case LDC: Push(instruction.Operand);
 case IADD: {
 var right = Pop();
 var left = Pop();
 var result = left + right;
 Push(result);
 }
 // other cases...
}
```

#align(
  center,
  [#image("../../Screenshots/2023_11_06_08_24_15.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_06_08_24_51.png", width: 80%)],
)

#subsubsection("Activation Frame and Call Stack")
Each method creates its own "Activation Frame", which holds the information for
this method(parameters etc):
#align(
  center,
  [#image("../../Screenshots/2023_11_06_08_32_19.png", width: 70%)],
)
#text(
  teal,
)[For the interpreter, this call stack is "managed" aka with GC and everything,
  represented in a OO way(at least for dotnot).\
  With JiT and proper languages, the call stack is *not* managed.]

#subsubsubsection("Managed")
managed callstack: ```cs
class ActivationFrame {
 private MethodDescriptor method;
 private Pointer thisReference;
 private object[] arguments;
 private object[] locals;
 private EvaluationStack evaluationStack;
 private int instructionPointer;
 // ...
}
class CallStack {
 private Deque<ActivationFrame> stack;
}
```

method call: ```cs
var method = (MethodDescriptor)instruction.Operand;

var nofParams = method.ParameterTypes.Length;
var arguments = new object[nofParams];
for (int i = arguments.Length – 1; i >= 0; i--) {
 arguments[i] = Pop();
}
var target = Pop();

var frame = new ActivationFrame(method, target, arguments);
callStack.Push(frame);
```

method return: ```cs
var method = activeFrame.Method;
var hasReturn = method.ReturnType != null;
object result = null;
if (hasReturn) {
 result = Pop();
}
callStack.Pop();
if (hasReturn) {
 Push(result);
}
```
#subsubsubsection("Unmanaged")
#align(
  center,
  [#image("../../Screenshots/2023_11_06_08_36_10.png", width: 60%)],
)

#subsection("Verification")
- detect wrong IL-code -> manipulation or error
  - static analysis on compile time
  - runtime analysis

What will be checked?
- correct usage of instruction
  - types are correct
  - method calls are correct with parameters and return types
  - jumps are valid -> methods, if, loops etc
  - op-codes are correct
  - stack-overflow or underflow are prevented
- types are known
  - metadata correct -> no unknown types
  - values on evaluation stack have a type
- values are initialized
- null-dereferences, out of bounds
- garbage collection -> if needed...
- compatibility of external references -> includes

*Example:*
#align(
  center,
  [#image("../../Screenshots/2023_11_06_08_43_07.png", width: 60%)],
)

 
