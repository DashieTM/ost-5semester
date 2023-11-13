#import "../../utils.typ": *

#section("OO in VM")
#subsection("Heap")
#align(
  center,
  [#image("../../Screenshots/2023_11_13_08_43_17.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_13_08_43_29.png", width: 100%)],
)
E.g. the issue with reference object is both the liftetime -> aka when do we
delete the object without breaking the code, while also making sure there is no
memory leak or unused memory. At the same time, there is also the issue with
allocation and de-allocation in terms of using memory in a sensible way -> if
you don't you might run into situations where you technically have enough ram
for objects, but you can't use it since the allocation is all over the
place(small free spaces between allocations).
#subsection("Unmanaged")
#align(
  center,
  [#image("../../Screenshots/2023_11_13_08_53_02.png", width: 70%)],
)
#text(
  teal,
)[Note, as a result of independence of the unmanaged stack, one can't use dotnet
  references inside of unmanaged.]

#subsection("Object block in Heap")
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_11_13_10_35_28.png", width: 100%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_11_13_10_35_40.png", width: 100%)],
  )
])

#subsection("Heap Class in Smallj Compiler")
```cs
class Heap {
  // allocates a type with a specific descriptor
  Pointer AllocateObject(ClassDescriptor type);
  // read a field from the class -> class.color
  object ReadField(Pointer ptr, int index);
  // write to a field fro mthe class -> class.color = rgb(255,255,255);
  void WriteField(Pointer ptr, int index, object value);
}
```
Allocation: ```cs
// new obj
var type = CheckClassDescriptor(instruction.Operand);
var instance = NewObject(type);
Push(instance);

// null obj
Push(null);
```

Get and Set: ```cs
// get
var field = CheckFieldDescriptor(instruction.Operand);
var instance = CheckPointer(Pop());
var value = heap.ReadField(instance, field.Index);
Push(value);

// set
var field = CheckFieldDescriptor(instruction.Operand);
var value = Pop();
var instance = CheckPointer(Pop());
heap.WriteField(instance, field.Index, value);
```

#subsection("Arrays")
#align(
  center,
  [#image("../../Screenshots/2023_11_13_10_39_55.png", width: 100%)],
)

Code:```cs
// helper class
class Heap {
 Pointer AllocateArray(ArrayDescriptor type, int length);
 int GetArrayLength(Pointer array);
 object ReadElement(Pointer array, int index);
 void WriteElement(Pointer array, int index, object value);
}

// allocation
var type = CheckArrayDescriptor(instruction.Operand);
var length = CheckInt(Pop());
var array = heap.AllocateArray(type, length);
Push(array);
```

#subsection("Easy Heap without GC")
```cs
Pointer Allocate(int size, TypeDescriptor type) {
  int blockSize = size + 16;
  if (freePointer + blockSize > limit) {
    // LOL
    throw new VMException("Out of Memory");
  }
  long address = freePointer;
  freePointer += blockSize;
  heap.Write(address, blockSize);
  SetTypeDescriptor(type, address); // at offset 8
  return new Pointer(address + 16);
}

Pointer AllocateObject(ClassDescriptor type) {
  // we can't read less than 8 bytes -> hence padding of 8
  int size = type.AllFields.Length * 8;
  return Allocate(size, type);
}

Pointer AllocateArray(ArrayDescriptor type, int length) {
  // we can't read less than 8 bytes -> hence padding of 8
  int size = length * 8;
  return Allocate(size, type);
}
```
