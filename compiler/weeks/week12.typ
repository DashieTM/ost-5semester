#import "../../utils.typ": *

#subsection("Garbage Collector Metadata")
The garbage collector needs to know what every single object in the program is
-> e.g. it needs to know at runtime how to interpret something in order to
understand A: where it lives? and B: how big it is.
- offset inside the object
- offset in stack
- pointer in register

#subsection("GC for C/C++/Rust")
- only plausible as interpreter GC
  - check all memory of program
  - check if memory can possibly be a pointer
  - if it can -> leave it be
  - memory leaks very much still possible
- no metadata leads to shit GC

#subsection("Finalizer")
This is a method that handles open connections etc of garbage. E.g. If an object
becomes garbage, the *finalizer* handles the closing of all problematic things
for this particular object, this resolves potential infinite loops.\
```java
class Block {
 @Override
 protected void finalize() {}
}
```
#text(red)[Will be run after GC-phase!]
- could potentially block GC!
- aka finalizer might cause an infinite loop
- finalizer can potentially create new objects
- finalizer can crash
- finalizer might resurrect object

#set text(14pt)
#text(
  red,
)[Note, with finalizer, you need to wait until you can sweep! -> E.g. you need a
  second mark phase for potentially resurrected objects!]
```cs
System.gc();
System.runFinalization();
System.gc();
```
#set text(11pt)

#subsubsection("Resurrection")
As mentioned the finalizer can resurrect objects again, it does this by binding
the objects reference to itself, hence it is no longer garbage.
#align(
  center,
  [#image("../../Screenshots/2023_12_04_08_28_01.png", width: 100%)],
)

#subsubsubsection("Internals of Finalizer")
Note, the finalizer has 2 sets for references, the first is the *weak reference
list -> "finalizer set"*, in here, references will not lead to the object not
becoming garbage, it just exists to get the reference if needed.\
The other set -> *pending queue* is the actual set that leads to the
resurrection -> e.g. it is the strong reference.
#align(
  center,
  [#image("../../Screenshots/2023_12_04_08_30_10.png", width: 100%)],
)
After resurrection, the strong reference is removed from the pending queue, this
makes you require a new mark phase!\
E.g. the garbage collector needs to check for potential changes and hence needs
to mark again before sweeping memory.
#align(
  center,
  [#image("../../Screenshots/2023_12_04_08_33_40.png", width: 100%)],
)

#subsubsection("Finalizer Notes")
- finalizers are concurrent
- finalizers run in random order
- finalizers run after a timeout
- finalizers *do NOT run after resurrection*
  - never for java
  - optionally resurrection opt-in -> "GC.ReRegisterForFinalize(this)"

#subsection("Weak References")
- don't count to GC collection
- used to still get a reference when needed
  - can be casted to strong
#text(
  red,
)[Ok, cool for Rust and co. But how is this dealt with in Object Object languages?\
  -> *Weak references need to be set to null when referenced object gets cleaned
  up!*\
  This is done via a weak reference table:]
#align(
  center,
  [#image("../../Screenshots/2023_12_04_08_45_47.png", width: 100%)],
)

#subsubsection("Java Weak")
The question remains, do weak references get removed (set to null) before or
after the finalizer?\
- Java has 3 weak references
  - weak
  - soft
  - phantom

#subsection("Compacting GC")
The compacting GC tries to solve the issue of *external fragmentation*. E.g. a
regular GC might free many random small memory pieces, this leaves new objects
with many small empty spaces that might not be big enough for new objects.
#align(
  center,
  [#image("../../Screenshots/2023_12_04_08_52_15.png", width: 100%)],
)
- also called mark & copy GC
- allocation at the end of the heap
- GC moves objects to end -> alongside references
- conservative method -> not really possible
#align(
  center,
  [#image("../../Screenshots/2023_12_04_08_53_09.png", width: 100%)],
)

#subsection("Incremental GC")
This tries to make the garbage collector run in parallel to the
mutator(program), by making the gc run only in small *incremental* steps.
#align(
  center,
  [#image("../../Screenshots/2023_12_04_08_54_16.png", width: 100%)],
)
There are different incremental GCs:
- generational GC
  - frees younger objects faster
- partitioned GC
  - heap is managed via partitions
- Concurrent GC
- Real-Time GC
- Shenondoah GC
  - forwarding pointers for concurrent evacuation(incremental GC for evacuation)
  - still requires stop of mutator
- Z GC
  - read barriers for concurrent evacuation
  - fast with colored pointers -> (uses MMU)
  - guarantees short stops of mutator

#subsubsection("Generational GC")
#align(
  center,
  [#image("../../Screenshots/2023_12_04_08_56_19.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_12_04_08_56_32.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_12_04_08_56_44.png", width: 100%)],
)
- references from old to new generations
  - additional root set for older generations per newer generation
  - G2 to G1, G2 to G0, etc.
- Write barriers
  - writing of references in old generations must be noticed
  - aka no references are allowed to be written into older generations
  - software wise: ?
  - hardware wise: Page faults via memory access rights
- Garbage collector of older generation must also clear younger generation
  - G2 gets cleared -> G1 and G0 must also be cleared

#subsubsection("Partitioned GC")
- concurrent mark phase
- focus on partitions with a lot of garbage
  - moves alive objects into a different partition
  - clear entire partition
- problem: garbage can point to other partitions
  - this requires *a stop of the program in order to mark*
#align(
  center,
  [#image("../../Screenshots/2023_12_04_09_05_31.png", width: 100%)],
)
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_12_04_09_05_42.png", width: 100%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_12_04_09_06_15.png", width: 100%)],
  )
])

