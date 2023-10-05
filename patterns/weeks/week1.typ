#import "../../utils.typ": *

#section("Pattern Definition")
- addresses a common problem
  - specifically why a problem is hard (*forces*)
- *generic solutions* that can be adapted
- describes benefits and liabilities
- gets a name, so we can talk about it

Note:
- patterns often depend on each other
  - sometimes extend each other
  - or implement parts of it
- are never completely alone -> always exist in environment

#section("GoF Great of Four")
#align(center, [#image("../../Screenshots/2023_09_22_09_30_09.png", width: 70%)])

#subsection("Mediator")
#set text(size: 14pt)
Problem | *Coupling* -> too many objects interact with each other
Category | *Behavioral*
#align(center, [#image("../../Screenshots/2023_09_29_09_12_31.png", width: 80%)])
#align(center, [#image("../../Screenshots/2023_09_29_09_15_48.png", width: 80%)])
#set text(size: 11pt)
- Be careful with static, the structure can quickly become a too large monolith
  with too many colleagues.
- Mediator can be implemented as _Observer_ as well, the mediator is the
  observable and the colleagues are the observers.

#columns(2, [
  #text(green)[Benefits]
  - Colleague classes may become more reusable, low coupling
  - Centralizes control of communication between objects
  - Encapsulates protocols
  - Liabilities
  #colbreak()
  #text(red)[Liabilities]
  - Adds complexity
  - Single point of failure
  - Limits subclassing (of mediator class)
  - May result in hard maintainable monoliths
])
