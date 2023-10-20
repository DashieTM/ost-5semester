#import "../../utils.typ": *

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
#align(
  center,
  [Simple clock, 3 modes -> display time, change hours, and change minutes.\
    On mode change you get to a different state.
    #image("../../Screenshots/2023_10_13_10_23_32.png", width: 70%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_13_10_24_49.png", width: 90%)
    - ClockDataContext: Handles data for the pattern -> all states need to access this
    - ClockState: Parentobject that will redirect calls to each state
    - concrete states: handle calls that will be used
    - OcjectsClickStateMachine: needs both a reference of CLockDataContext(readonly
      for this object) and the clockstate],
)

#columns(2, [
  #text(green)[Benefits]
  - abstracts functionality away
  - no ifs needed to check for current state
  #colbreak()
  #text(red)[Liabilities]
  - fixed structure -> lot of work when changed
    - similar to visitor pattern
  - pattern is often overkill
  - virtual classes are often used -> performance
])

#subsection([State Pattern (Methods for States)])
#set text(size: 14pt)

Problem | Wile the object state pattern does solve the underlying problem, it
also creates indirection problems which means a complicated structure that is
hard to change later on. In order to avoid this, we can use function pointers
instead.\
#set text(size: 11pt)
// images
#align(
  center,
  [#image("../../Screenshots/2023_10_13_10_24_49.png", width: 90%)
    - all methods are created within the MethodsClockStateMachine
      - tick is always the same
      - increment, nextHour, nextMinute
        - 3 different functions for 3 different modes
      - nextModeDisplayingTime, nextModeSettingHours,NextModeSettingMinutes
        - 3 different functions for 3 different modes
    - The Mode object has 3 lambdas which will be created with the respective
      functions for each mode to represent
      - note that the functions inside Mode need to fit -> java -> runnable, rust ->
        fn(i32) -> i32
  ],
)

#columns(
  2,
  [
    #text(green)[Benefits]
    - slightly better performance due to removed typecasting -> virtual objects
    - behavior is coupled to state machine and not into thousands of classes
    - each distinct behavior is assigned its own method
    - No object context needs to be passed around, methods can already access the
      internal state of the state machine
    #colbreak()
    #text(red)[Liabilities]
    - indirection still exists -> performance loss is still there
    - list of methods might get too large to properly manage
  ],
)

#subsection([Sate Pattern (Collection For States)])
#set text(size: 14pt)

Problem | In order to solve the problem of both too many objects, but also too
many functions inside one object, we create multiple different state machines,
e.g. one for every state. Each state then uses a "Mode" class, here called
workpiece that will take the function of the state and apply it via lambda.\
Participants :
- CollectionClockStateMachine
  - a state machine that is explicit for the state in question
- Workpiece
  - class used to invoke functions
#set text(size: 11pt)
// images
#align(
  center,
  [#image("../../Screenshots/2023_10_13_10_52_36.png", width: 90%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_13_10_53_07.png", width: 90%)],
)

#columns(
  2,
  [
    #text(green)[Benefits]
    - No need to create a class per state
    - Optimized for multiple objects (state machines) in a particular state
    - Object's collection implicitly determines its state
      - No need to represent the state internally
    - Can be combined with other State Machine (Objects / Methods) approaches
    - good for multiple workpieces -> multiple set of functions
      #colbreak()
      #text(red)[Liabilities]
      - can lead to a more complex state manager
      - performance...
  ],
)

#section("Value Definition")
#subsection("System Analysis (OOA)")
#text(
  teal,
)[An individual is something that can be named and reliably distinguished from
  other individuals.]\
There are 3 kinds of individuals:
- events
  - *an individual thing* that happens at a particular time
  - example: user-action
- entities
  - *an individual* that *persists* and *changes its properties and states*.
  - entities may *invoke events*
  - example: person
- values
  - *exists outside of time and space* -> is not represented directly
  - it is part of an entity
  - example: weight
#align(
  center,
  [#image("../../Screenshots/2023_10_13_11_11_10.png", width: 70%)],
)

#subsection("Software Design (OOD)")
- entity
  - express system information, typicall of *persisten nature*.
  - identity distinguishes an entity from another
  - example: some custom class
- service
  - represent *system activities*
  - Services are *distinguished by their behavior* rather than their state or
    content
  - example: 
- values
  - *the content is the dominant behavior* -> value is more important than the rest
    -> weight -> kg is just something to make it easier for us to interpret
  - transient: 5kg is always 5kg, no other interpretation
  - example: value weight
- task
  - *like services, but with a representation of identity and state*
  - example: threads
