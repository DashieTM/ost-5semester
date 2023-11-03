#import "../../utils.typ": *

#subsection([Reflection])
#set text(size: 14pt)

Problem | How do you load code during runtime, e.g. without recompiling?\
Context | Plugin system\
#set text(size: 11pt)
// images
There is two aspects to reflection:
- *introspection*\
  The ability for a program to observe and therefore reason about its own state.\
  e.g. query for object properties, methods etc.
- intercession\
This is the part where you change code during runtime -> or rather load a
dynamic library\
Programming languages like javascript can be changed directly during runtime.

#align(
  center,
  [#image("../../Screenshots/2023_11_03_09_36_00.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_03_09_37_20.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_03_09_42_02.png", width: 80%)],
)

cloning an object using reflection:\
```java
 if (origin instanceof Cloneable) {
 cloned = ((Cloneable)origin).clone();
 } else {
 cloned = origin.getClass().getDeclaredConstructor().newInstance();
 // ...
 BeanUtils.copyProperties(origin, cloned); // get data from getters, fill into
setters
// beanutils copies things dynamically at runtime without your code doing anything
 }
 ```

#columns(
  2,
  [
    #text(green)[Benefits]
    - flexibility -> allows for a base platform to be more powerful without more code
      - functionality can be added later on
    #colbreak()
    #text(red)[Liabilities]
    - security risks -> dynamic library is essentially arbitrary code!
    - performance hit -> dynamic libraries are an overhead
    - limited type safety
    - control flow is hard to understand -> requires that you also read the dyn
      libraries etc.
  ],
)

#subsection([Type Object])
#set text(size: 14pt)

Problem | In a library, media (books, videos etc) share certain attributes, like
author, year, etc.\
At the same time, you might have a certain book multiple times.\
Also Videos might have a additional properties like length in minutes.\
Solution | Create a Variant Type -> Enum -> Video/Book, can be checked
dynamically or more types can be added later on.
#set text(size: 11pt)
// images
#align(
  center,
  [#image("../../Screenshots/2023_11_03_09_49_46.png", width: 40%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_03_09_53_16.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_03_09_53_28.png", width: 80%)],
)
Jafuck example:
#align(
  center,
  [#image("../../Screenshots/2023_11_03_09_55_40.png", width: 80%)],
)

#columns(
  2,
  [
    #text(green)[Benefits]
    - more categories can be added easily -> games in the example
    - avoids explosion of subclasses with attributes etc
    - allows multiple type object levels -> type object for type object
    #colbreak()
    #text(red)[Liabilities]
    - lower efficiency -> indirection
    - separation not always easy to understand directly
    - changing database schemas can be tricky
      - Solution needs to store different object layouts persistently (mitigated with
        OR-mapping)
  ],
)

#subsection([Property List])
#set text(size: 14pt)

Problem | How do you provide properties that can be used on any arbitrary object
-> e.g. for example in a game engine, add properties at any level with
properties still attached?\
Or in IPC, how do we transfer a list of properties that can be expanded or
shrinked dynamically?\
Solution | Hashmap with properties -> PropList in dbus-rs\
#set text(size: 11pt)
// images

#align(
  center,
  [#image("../../Screenshots/2023_11_03_09_57_05.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_03_09_57_20.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_03_09_56_32.png", width: 80%)],
)

#columns(2, [
  #text(green)[Benefits]
  - black box expendability
  - object extension while keeping identity and type
  - same attributes can be used across hierarchy
  #colbreak()
  #text(red)[Liabilities]
  - indirection for each property
  - no type safety
  - naming not checked by compiler -> at runtime!
  - semantics of attributes not given by class
])

#subsection([Introducing Bridge Method])
#set text(size: 14pt)

Problem | Property lists can cause issues with types and certain attributes
existing or rather not existing. How can we enforce the same access for these
properties as regular properties?\
Solution | Create a bridge method or struct that converts the property list to
static properties, usually done with Optional\<T\> or using default values.
#set text(size: 11pt)
// images
#align(
  center,
  [#image("../../Screenshots/2023_11_03_10_03_49.png", width: 80%)],
)
Example of a bridge using rust and dbus.
#align(
  center,
  [#image("../../Screenshots/2023_11_03_10_08_11.png", width: 40%)],
)

#columns(2, [
  #text(green)[Benefits]
  - static usage of properties
  - type safety
  #colbreak()
  #text(red)[Liabilities]
  - conversion requires performance
  - new attribute means new conversion -> not very flexible
])
