#import "../../utils.typ": *

#section("Inheritance")

#subsection("ancestor table")
Here the idea is that checking the parent until you eventually land on the type
you want, you can check specific levels of inheritance immediately as a list of
inheritances.

#align(
  center,
  [#image("../../Screenshots/2023_11_20_08_19_58.png", width: 100%)],
)

```cs
class ClassDescriptor {
  private int ancestorLevel;
  private ClassDescriptor[] ancestorTable;
  // ...
}
```

#subsection("Useless typecasts")
When using casts or instanceof on the same type, the compiler should remove this
instruction as it does nothing.
#align(
  center,
  [#image("../../Screenshots/2023_11_20_08_22_23.png", width: 60%)],
)

#subsection("instanceof")
```cs
var instance = CheckPointer(Pop());
var target = CheckClassDescriptor(instruction.Operand);
var desc = heap.GetDescriptor(instance);
var level = target.AncestorLevel;
var table = desc.AncestorTable;
Push(table[level] == target);
```

#subsection("Checkcast")
```cs
// instanceof logic
if (!CheckBoolean(Pop())) {
  throw new VMException("Invalid cast");
}
Push(instance)
```

#subsection("VTable")
#align(
  center,
  [#image("../../Screenshots/2023_11_20_08_23_16.png", width: 60%)],
)

#subsubsection("Linear Extension")
With single inheritance and no interfaces, you can essentially just add methods
in a list-append fashion:
#align(
  center,
  [#image("../../Screenshots/2023_11_20_08_27_18.png", width: 70%)],
)
Calling the function can hence simply be done via the class descriptor on a
methodlist via index:
#align(
  center,
  [#image("../../Screenshots/2023_11_20_08_29_41.png", width: 70%)],
)
```cs
class ClassDescriptor {
  // list of methods
  private MethodDescriptor[] virtualTable;
}
class MethodDescriptor {
  // index for each method
  private int position;
}
```

#subsubsection("Invoke Virtual in VM")
```cs
// pop arguments
var staticMethod = CheckMethodDescriptor(instruction.Operand);
var target = CheckPointer(Pop());
var desc = heap.GetDescriptor(target);
int pos = staticMethod.Position;
var vTable = desc.VirtualTable;
var dynamicMethod = vTable[pos];
// call dynamic method
```

#subsubsection("Interface VTable")
With interfaces we can't just use the linear extension as we can have multiple
interfaces for the same class -> hence we need a way to store more functions for
the object. We can do this by extending the array to a 2 dimensional array:
#align(
  center,
  [#image("../../Screenshots/2023_11_20_08_34_53.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_20_08_35_05.png", width: 100%)],
)
#text(
  red,
)[The issue with this approach is that for each interface, we need an entire array
  for methods, even if the interface doesn't even add methods -> this means we
  waste a lot of memory:]
#align(
  center,
  [#image("../../Screenshots/2023_11_20_08_38_33.png", width: 50%)],
)
#text(teal)[The solution is to use offsets for the vtable:]
#align(
  center,
  [#image("../../Screenshots/2023_11_20_08_40_02.png", width: 100%)],
)

#subsubsubsection("Check for Interfaces")
With interfaces we also need to check if the base object is compatible(with bad
languages that only use vtables...):
#align(
  center,
  [#image("../../Screenshots/2023_11_20_08_41_06.png", width: 80%)],
)

