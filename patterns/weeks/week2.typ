#import "../../utils.typ": *

#subsection("Memento")
#set text(size: 14pt)
Problem | *History* -> Object should remember its own state
Category | *Behavioral*
Participants | Originator -> Object in question, Memento -> History, e.g. stack,
#align(center, [#image("../../Screenshots/2023_09_29_09_21_19.png", width: 80%)])
Caretaker -> storage, e.g. database
#set text(size: 11pt)

- similar:
  - Serialization
  - Future Pattern

#columns(2, [
  #text(green)[Benefits]
  - Internal state of an object can be saved and restored at any time
  - Encapsulation of attributes is not harmed
  - State of objects can be restored later
  #colbreak()
  #text(red)[Liabilities]
  - Creates a complete copy of the object every time, no diffs
  - May require a lot of memory
  - No direct access to saved state, it must be restored first
])

#subsection("Singleton")
Problem | *Static Instance* -> only 1 object of this type should exist 
Category | *Creational*
#columns(2, [
  #text(green)[Benefits]
  - clean solution to single object 
  - solves dependencies including the singleton object
  - solves argument spam in functions
  #colbreak()
  #text(red)[Liabilities]
  - if built wrong can lead to needless mock implementations of a singleton -> mock singletons for tests 
  - can lead to race conditions -> not in rust 
  - might require getDB() calls
])

#subsection("Prototype")
Problem | *Inheritance problem* -> too many inheritances 
Category | *Creational*
Similar | *Trait / Interface*



