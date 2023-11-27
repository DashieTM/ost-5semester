#import "../../utils.typ": *

#section("Garbage Collection")

#subsection("Explicit Memory Handling")
- noobs can't handle it
- languages like C don't make it easy to work with -> return stack reference, get
  shit on
- C++ has old features -> shit, not everyone uses the newer ones...
- memory leaks -> always going to be an issue tbh

#subsubsection("Danling Pointer")
- Pointer directing to deleted object
- can happen with stack or heap
- stack easy to fix -> simple lsp check, don't allow stack pointer returns
- heap problematic -> how to check when deleted?

#subsection("Reference Counting")
- every pointer is a single count
- heap memory can't be deleted when count is not 0
- problem -> cyclic references
  - A has reference to B
  - B has reference to A
  - result: neither A nor B can be deleted
  - *memory leak by locking!*
  - solution: weak references!

#subsubsection("Weak / Strong")
- weak reference
  - does not count for delete check
  - can be "upgraded" to strong reference
  - used for references that *might* at some point matter -> good example buttons
- strong reference
  - regular counting reference

#subsubsection("Atomic")
For concurrency, you need atomic reference counting to ensure correct behavior
-> "Teure Updates".\
In a certain good language this is handled by Arc\<T\>.

#subsection("Garbage Collector")
- Checks whether or not a heap object can still be accessed or not -> *"Root Set"*
  - #text(
      teal,
    )[Root Set is the quantity of all references in paremeters, variables, evaluation
      stack and static variables]
- Uses Mark and sweep algorithm ```cs
   void Collect() {
   Mark();
   Sweep();
   }
   // similar to mark and delete for a game loop
   // idea: first mark all then delete -> mark is not noticeable for users, delete
   is -> minimize delete to 1 instance
   // 1 delete improves memory coherency -> free everything not small parts
   ```

#subsubsection("Mark Phase")
#align(
  center,
  [#image("../../Screenshots/2023_11_27_08_54_15.png", width: 100%)],
)
```cs
void Mark() {
  foreach (var root in RootSet) {
    Traverse(root);
  }
}
```

Traverse Code:\
```cs
void Traverse(Pointer current) {
  long block = heap.GetAddress(current)-BLOCK_HEADER_SIZE;
  if (!IsMarked(block)) {
    SetMark(block);
    foreach (var next in GetPointers(current)) {
      Traverse(next);
      // recursion ... problematic -> see next
    }
  }
}
```

#subsubsubsection("Recursive Traversal")
- garbage collector needs additional memory
- problematic since memory inside gc is small either way
- algorithms that don't need additional memory -> pointer rotation algorithm by
  Deutsch-Schorr-Waite

#subsubsection("Sweep")
Sweep Phase:
#align(
  center,
  [#image("../../Screenshots/2023_11_27_08_54_53.png", width: 100%)],
)
```cs
void Sweep() {
  long current = HEAP_START;
  while (current < HEAP_SIZE) {
    if (!IsMarked(current)) {
      Free(current);
    }
    ClearMark(current);
    current += heap.GetBlockSize(current);
  }
}
```

#subsubsection("Time Interval for GC")
- delayed
  - can't be identified immediately
  - at latest when heap is full
  - interval
- pre-emptive? (later)

#subsubsubsection("Stop&Go")
- sequential and exclusive -> no other program can run during GC
- Mutator: this is the regular program here, ignore it
  - however the name does say something: The mutator mutates memory -> hence no GC
    marking or sweeping during that time as otherwise not everything can be
    identified
#align(
  center,
  [#image("../../Screenshots/2023_11_27_09_18_12.png", width: 100%)],
)

Root Set identification:\
```cs
IEnumerable<Pointer> GetRootSet(CallStack callStack) {
  var list = new List<Pointer>();
  foreach (var frame in stack) {
    CollectPointers(frame.Parameters);
    CollectPointers(frame.Locals);
    CollectPointers(frame.EvaluationStack.ToArray());
    list.add(frame.ThisReference);
  }
  return list;
}
```

#subsubsubsection("Mark Flag")
#align(
  center,
  [#image("../../Screenshots/2023_11_27_09_21_27.png", width: 70%)],
)

#subsubsubsection("Pointer offsets")
#align(
  center,
  [#image("../../Screenshots/2023_11_27_09_23_28.png", width: 70%)],
)
The problem with this is that we need to also find each pointer for the main
object -> aka we need to recursively mark and delete:\
```cs
IEnumerable<Pointer> GetPointers(Pointer current) {
  var list = new List<Pointer>();
  var descriptor = heap.GetDescriptor(current);
  var fields = ((ClassDescriptor)descriptor).AllFields;
  for (var index = 0; index < fields.Length; index++) {
    if (IsPointerType(fields[index].GetType())) {
      var value = heap.ReadField(current, index);
      if (value != null) {
      list.Add((Pointer) value);
      }
    }
  }
  return list;
}
```

#subsubsubsection("Free call")
```cs
void Sweep() {
  var current = HEAP_START;
  while (current < HEAP_SIZE) {
    if (!IsMarked(current)) {
      Free(current);
    }
    ClearMark(current);
    current += heap.GetBlockSize(current);
  }
}
```

#subsubsubsection("Free List")
#columns(
  2,
  [
    When allocating memory, the biggest challange is to find a "big enough" space
    within memory. This is usually done with a free list, which will be used to
    search for a space.
    #colbreak()
    #align(
      center,
      [#image("../../Screenshots/2023_11_27_09_25_16.png", width: 100%)],
    )
  ],
)

#subsubsubsection("Heap Block Layouts")
#text(teal)[Each header needs to be the same size -> sweep requirement]
#align(
  center,
  [#image("../../Screenshots/2023_11_27_09_26_03.png", width: 100%)],
)

#subsubsubsection("Fit strategies -> see operating systems 1")
- first fit
  - no sorting
  - traversal till first found
- best fit
  - sort by smallest possible
  - leaves small and unusable fragments
- worst fit
  - sort by biggest
  - always finds a fitting block
  - fragmentation problems

#subsubsubsection("Buddy System")
#columns(
  2,
  [
    At the start we have the full memory, then when we get an allocation request
    that is smaller than this size divided by 2, we split the memory into 2
    sections, these 2 sections are now considered "buddies", as the merge into the
    bigger part together. Since we requested 64bytes from the max of 512 bytes, we
    can split again, and again, we do this until the split would be smaller than the
    size we want, this size will then be allocated. Each new value that should be
    allocated will be done in the same way.
    #colbreak()
    #align(
      center,
      [#image("../../Screenshots/2023_11_27_09_31_17.png", width: 100%)],
    )

  ],
)
When freeing memory, it will always be checked whether or not the "buddy" is
also free, if it is, then the entire block can be combined and freed, otherwise
only this block is freed. Here is an example to check whether or not 2 addresses
are buddies: Let’s say we want to check if 2 addresses with the allocated size
of 16KB are buddies. This means that we first need to *figure out what power k
we are at*. This can be done by calculating 16KB, which is $2^1$4 -> 1 byte = 8
bit -> $2^3$ bit, then multiple this by 10 and double it as 16 is 8 \* 2. So, k
= 14.

```C
#include <stddef.h>
#include <stdio.h>

void expect(int a, int b) { fputs(a == b ? "OK\n" : "ERROR\n", stdout); }

int are_buddies(size_t a, size_t b, size_t level) {
  // shift k times until we get the binary number k 
  size_t bit_k = 1 << level; // k in binary

  // xor address a and b -> results in 1 bit being different, aka 1 bit being 1
  // example 110000000000000 and 100000000000000, the 14 bit is different
  // if this result is the same as bitk, then you have buddies
  // 010000000000000 and 10000000000000, note the left address has 1 leading 0!
  // leading 0s are ignored! treated as the same number!
  return (a ^ b) == bit_k ;
}

int main(int argc, char **argv) {
  expect(are_buddies(0, 1, 0), 1);
  expect(are_buddies(0, 0x40, 7), 0);
  expect(are_buddies(0, 0x40, 6), 1);
  expect(are_buddies(0, 0x40, 5), 0);
  expect(are_buddies(0xabd40, 0xabd00, 6), 1);
  expect(are_buddies(0x40, 0x40, 6), 0);
  expect(are_buddies(0x40, 0x40, 6), 0);
}
```

#subsubsubsection("Free list variants")
#align(
  center,
  [#image("../../Screenshots/2023_11_27_09_29_04.png", width: 100%)],
)

