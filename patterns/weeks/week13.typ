#import "../../utils.typ": *

#section("Singleton (Boxing and Killing)")
#set text(size: 14pt)
Problem | Guarantee that a resource exists *exactly once* and can be globally
accessed.\
Context |
- one instance
- globally accessible
- subclassing should be possible
- extending must not break code
- lazy or eager loading possible
#set text(size: 11pt)
// images
//
```java
public class Singleton {
  private static class InstanceHolder {
    // Singleton will be instantiated as soon as the
    // ClassLoader instantiates the overlying class.
    private static final Singleton INSTANCE = new Singleton();
  }
  public static Singleton getInstance() {
    return InstanceHolder.INSTANCE;
  }
  protected Singleton() { } // allow subclassing
}
```

#columns(2, [
  #text(green)[Benefits]
  - controlled access to sole instance
  - reduced name space
  - premits variable number of instances
    - -> can also be a dualton, tripleton, etc.
  - more flexible than class operations -> static etc.
  #colbreak()
  #text(red)[Liabilities]
  - introduces global state
    - clients might be interfering
  - no polymorphism
  - hard to test
    - requires mock implementations
  - multithreading makes access harder
    - use rust...
])

#subsection([Registry])
#set text(size: 14pt)
Problem | This solves the issue of testability with a singleton by providing a
registry to allow different singletons to replace each other. E.g. poor mans
polymorphism.\
#set text(size: 11pt)
// images
#align(
  center,
  [#image("../../Screenshots/2023_12_08_04_57_16.png", width: 50%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_12_08_05_03_00.png", width: 100%)],
)

#columns(2, [
  #text(green)[Benefits]
  - better testing via singleton plymorphism
  #colbreak()
  #text(red)[Liabilities]
  - IPC style registering
    - type leads to runtime error
])

#subsection([Monostate])
#set text(size: 14pt)

Problem | Multiple instances should have the same behavior -> behavior of
singleton without the same name.\
Behavior here does not mean the same result -> instead, same function signatures
-> must be capable of being placed everywhere where singleton is used.
#set text(size: 11pt)
// images
```java
// Example 1:
//  > Plain Monostate implementation
public class Monostate {
  private static int x;
  private static int y;
  public int getX() { return x; }
  public int getY() { return y; }
}
// Example 2:
//
> Mitigate Singleton & introduce interface
public interface Monostate {
  int getX();
  int getY();
}
public class MonostateImpl implements Monostate {
  public int getX() {
    return Singleton.getInstance().getX();
  }
  public int getY() {
    return Singleton.getInstance().getY();
  }
}
```

#subsection([Killing])
#set text(size: 14pt)

Problem | A framework uses a singleton, we therefore need a way to circumvent
the singleton in order to test the code.\
#align(
  center,
  [#image("../../Screenshots/2023_12_08_05_05_17.png", width: 100%)],
)

#text(red)[Solution with monostate pattern combined!]

#set text(size: 11pt)
#align(
  center,
  [#image("../../Screenshots/2023_12_08_05_31_53.png", width: 100%)],
)

#columns(
  2,
  [
    #text(green)[Benefits]
    - polymorphism for testing
    - well defined creation and destruction
    - transparency -> no need to know about monostate
    #colbreak()
    #text(red)[Liabilities]
    - breaks inheritance hierarchy -> a non monostate class can't be casted to a
      monostate class
      - reason: monostate only has global state, inheriting does hence not do anything!
      - you also can't cast since the memory can't be replaced -> it's static memory,
        this does not work!
    - monostate is *always created*
      - consumes memory needlessly
      - new keyword is not correct -> memory is already allocated
      - users might confuse this with the new() function for heap objects!
    - sharing monostate objects accross tiers is not possible
    - shared state of monostate may cause unexpected behavior
      - static variables -> change on obj1 -> obj2 also changes
      - *only use monostate when mitigating singletons!*
  ],
)

#subsection([Service Locator])
#set text(size: 14pt)
#align(
  center,
  [#image("../../Screenshots/2023_12_08_05_38_11.png", width: 100%)],
)

Problem | Same as singleton. Global functionality.\
Context | However, here we would like to *not use* singletons, instead we pick
the functionality from the singleton and use this instead, hence *services*.\
Participants:
- Provider/ServiceLocator: Registry Singleton that provides all service finders
- Finder: ServiceFinder that provides a service implementation
- Service: Service that does something...
#set text(size: 11pt)
- Implement the ServiceLocator as a Singleton «Registry»
  - Holds the concrete finder implementations
- ServiceLocator returns finder instances, which are used to locate the underlying
  services
  - Both, finder and service are exposed by interfaces only
- Also known as dynamic ServiceLocator or *Provider*
// images
#align(
  center,
  [#image("../../Screenshots/2023_12_08_05_44_20.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_12_08_05_44_31.png", width: 100%)],
)

#columns(
  2,
  [
    #text(green)[Benefits]
    - only a single singleton is used
      - all others are polymorphic with interfaces
      - services can be exchanged even at runtime
    #colbreak()
    #text(red)[Liabilities]
    - clients still rely on a static reference to ServiceLocator (tight coupling)
      - hence ServiceLocator can't be removed
      - can be removed with dependency injection
  ],
)
