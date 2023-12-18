#import "../../utils.typ": *

#section("Just in Time Compiler JIT")
- faster than interpreter -> obviously
- not everything will be compiled usually
  - only critical parts
  - so called *hot spots*
  - code that is run over and over again -> main loop in game

#subsection("Profiling")
The interpreter keeps track of the amount of times a specific code section is
being run. -> Via methods and traces.
#align(
  center, [#image("../../Screenshots/2023_12_11_08_18_23.png", width: 60%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_11_08_18_46.png", width: 60%)],
)

#subsection("Intel 64 architecture")
- 14 general registers
#align(
  center, [#image("../../Screenshots/2023_12_11_08_19_25.png", width: 60%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_11_08_19_48.png", width: 100%)],
)
- special registers
#align(
  center, [#image("../../Screenshots/2023_12_11_08_20_13.png", width: 70%)],
)
- media registers -> 64, 128 and 256 bit
- floating point registers -> double etc.

#subsubsection("Callstack")
#align(
  center, [#image("../../Screenshots/2023_12_11_08_25_36.png", width: 100%)],
)

#subsubsection("Mov")
#align(
  center, [#image("../../Screenshots/2023_12_11_08_26_18.png", width: 70%)],
)

#subsubsection("Aithmetic Instructions")
#align(
  center, [#image("../../Screenshots/2023_12_11_08_26_39.png", width: 100%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_11_08_31_43.png", width: 80%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_11_08_32_38.png", width: 70%)],
)

#subsubsection("Jumps")
#align(
  center, [#image("../../Screenshots/2023_12_11_09_16_57.png", width: 100%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_11_09_17_57.png", width: 100%)],
)

#subsection("Conversion")
#align(
  center, [#image("../../Screenshots/2023_12_11_08_40_02.png", width: 70%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_11_08_40_16.png", width: 70%)],
)

#subsection("Local and Global Registers")
- local
  - evaluation stack
  - display evaluation stack entries in registers -> register stack
- global
  - save variables in registers
  - faster than memory access

#subsection("Allocation Record")
- parameters are stored within registers
  - first 4 parameters for winshit: RCS, RDX, R8, R9
  - first 6 parameters for unix: RDI, RSI, RDX, RCX, R8, R9
#align(
  center, [#image("../../Screenshots/2023_12_11_09_18_31.png", width: 40%)],
)
#align(center, [
  #text(red)[load variable]
  #image("../../Screenshots/2023_12_11_09_18_46.png", width: 100%)
])
#align(center, [
  #text(red)[relocate variable]
  #image("../../Screenshots/2023_12_11_09_19_34.png", width: 100%)
])
#text(red)[JIT]
#align(
  center, [#image("../../Screenshots/2023_12_11_09_19_49.png", width: 60%)],
)
```cs
switch (opCode) {
  // ...
  case LDC:
    var target = Acquire();
    var value = (int)instruction.Operand;
    assembler.MOV_RegImm(target, value);
    Push(target);
    break;
  case LOAD:
    var index = (int)instruction.Operand;
    /* if parameter index */
    reg = allocation.Parameters[index – 1];
    Push(reg);
    break;
  case STORE:
    var source = Pop();
    var target = allocation.Locals[index-1-nofParams];
    assembler.MOV_RegReg(target, source);
    Release(source);
    break;
  case ISUB:
    var operand2 = Pop();
    var operand1 = Pop();
    var result = Acquire();
    assembler.MOV_RegReg(result, operand1);
    assembler.SUB_RegReg(result, operand2);
    Release(operand1);
    Release(operand2);
    Push(result);
    break;
  case IDIV:
    Reserve(RAX);
    Reserve(RDX);
    ForceStack(1, RAX);
    var operand2 = Pop();
    Pop(); // is RAX
    assembler.CDQ();
    assembler.IDIV(operand2);
    Push(RAX);
    Release(operand2);
    Release(RDX);
    break;
  // ...
}
```

#subsubsection("Allocation matching")
One problem is that different branches might want to use different registers, in
that case you might need to move values to these registers:
#align(
  center, [#image("../../Screenshots/2023_12_11_09_32_41.png", width: 100%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_11_09_32_53.png", width: 100%)],
)
```cs
switch (opCode) {
  case if_true:
    var offset = (int)instruction.Operand;
    var target = code[position + 1 + offset];
    var label = labels[target];
    matchAllocation(label);
    if (previous == CMPEQ) {
      assembler.JE_Rel(label);
    }
    break;
  // ...
}
```

#subsubsection("Register runout")
When using JIT, you might run into the issue of running out of registers,
solutions include pushing temporary values to the stack and pushing local
variables and parameters to the stack.
