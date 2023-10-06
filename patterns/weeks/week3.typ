#import "../../utils.typ": *

#subsection("Command Pattern")
#set text(size: 14pt)

Problem | decouple the execution itself from when to execute.\
#set text(size: 11pt)
Context | How can *commands be encapsulated*, so that they can be
*parameterized, schedules, logged and/or undone*? Can also be seen as mapping a
function to something like a button on a controller -> SpiritOfMars!
#align(
  center,
  [#image("../../Screenshots/2023_10_06_08_45_09.png", width: 80%)],
)

#columns(
  2,
  [
    #text(green)[Benefits]
    - command can be activated from different sources
    - new commands can be introduced relatively quickly
    - command objects can be saved in history -> for example for undo
    - time and functionality are decoupled -> not done by the same thing
    #colbreak()
    #text(red)[Liabilities]
    - large design with many commands -> might need many small command classes
      - was also noticeable with SpiritOfMars
    - undo is not defined -> no explanation how, would need an additional pattern
  ],
)

#subsection("Command Processor Pattern")
#set text(size: 14pt)

Problem | Allow easy undo with the command pattern.\
Context | Kind of a combination between the command pattern and the memento
pattern.\
Participants :
- Command Processor
  - seperate object that handles executing and managing history
- command
  - functionality to execute
- controller/client
  - translates requests into command s and transfers commands to the command
    processor
#set text(size: 11pt)
#align(
  center,
  [#image("../../Screenshots/2023_10_06_08_52_25.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_06_08_54_50.png", width: 80%)],
)

#columns(2, [
  #text(green)[Benefits]
  - flexibility
  - command processor allows more than just execution -> logging, undo etc
  - enhances testability
  #colbreak()
  #text(red)[Liabilities]
  - efficiency loss due to indirection
])

#subsection("Visitor Pattern")
#set text(size: 14pt)

Problem |
- change functionality on classes without changing their code
- e.g. different algorithms needed to process an object tree
Context | Essentially just dynamic dispatch. Serialization -> The visitor struct
will be run over all nodes, using it's own visitor versions in order to
serialize to different formats.\
Double Dispatch | This is nothing more than the accepting of a visitor, which is
generic for the node, then using the visit method to use the visitor functin on
the node, which converts the visitor back to the original (sub)instance.\
Participants :
- Visitor
  - generic base
  - derivations will have specific functionality
- node
  - struct that will be changed by visitor
#set text(size: 11pt)
#align(
  center,
  [#image("../../Screenshots/2023_10_06_09_08_33.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_06_09_13_27.png", width: 80%)],
)

#columns(
  2,
  [
    #text(green)[Benefits]
    - adding new operations relatively easy
    - seperates operations from unrelated ones
    #colbreak()
    #text(red)[Liabilities]
    - changes in structure make the visitor pattern unviable
    - visitor can't change how structure is visited -> this is handled by the
      structure!
    - adding new nodes is hard
    - visiting sequence defined in nodes, not in visitor
    - visitor breaks logic apart
  ],
)

#subsection([External Iterator Pattern])

#set text(size: 14pt)

Problem | Iteration depends on the target implementation -> should be seperate
to allow multiple iteration strategies. (aka iterator should be a seperate
struct)\
Context | Bounded buffer represented with pointers -> seperate iterator struct
in order to not change structure directly.\
Participants :
- Base struct
- Iterator
#set text(size: 11pt)
// images
#align(
  center,
  [#image("../../Screenshots/2023_10_06_09_31_54.png", width: 80%)],
)

#columns(2, [
  #text(green)[Benefits]
  - single interface to loop through any collection
  #colbreak()
  #text(red)[Liabilities]
  - multiple iterators at the same time possible
    - not a problem with rust :)
  - life-cycle management of iterator objects
    - not a problem with rust :)
  - close coupling between iterator and corresponding collection
  - indexing might be more intuitive for programmers
])

#subsection([Internal/Enumeration Iterator Pattern])

#set text(size: 14pt)

Problem | Don't rely on external iterator which might introduce too much
coupling. Context | You would like to have a print functinality for your
datastructure, hence you create an enumeration function. This will then be used
in a "executeOn" function which takes a function as a parameter, which will then
be used on each item in the datastructure.
-
#set text(size: 11pt)
// images
#align(
  center,
  [#image("../../Screenshots/2023_10_06_09_37_26.png", width: 80%)],
)

#columns(
  2,
  [
    #text(green)[Benefits]
    - client is not responsible for loop
    - synchronization can be provided at the level of the whole traversal rather than
      for each element access
      - better safety
    #colbreak()
    #text(red)[Liabilities]
    - single element changes are annoying
      - less control
    - sometimes too abstract
    - depends on command type(not always??)
  ],
)

#subsection([Batch method Iterator])
#set text(size: 14pt)

Problem | Collection is on client -> iterator would not be efficient over
network. Context | We would like to access a datastructure on a remote pc, how
do we do this? -> *Batch request*\ We simply get all data, then proceed to
iterate on our local machine.
-
#set text(size: 11pt)
// images
#align(
  center,
  [#image("../../Screenshots/2023_10_06_09_51_15.png", width: 50%)],
)

#subsection([State Pattern (for objects)])
#text(red)[often misunderstood]
#set text(size: 14pt)

Problem | Allow an object to alter its behavior when its internal state changes.
The object will appear to change its class.\
Context | Behavior should change depending on state without needing 10000 if
statements(aka not yandere dev)\

#set text(size: 11pt)
// images
#align(
  center,
  [#image("../../Screenshots/2023_10_06_09_57_36.png", width: 80%)],
)

#columns(2, [
  #text(green)[Benefits]
  -
  #colbreak()
  #text(red)[Liabilities]
  - fixed structure -> lot of work when changed
    - similar to visitor pattern
])
