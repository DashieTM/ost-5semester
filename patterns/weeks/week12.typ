#import "../../utils.typ": *

#subsection("Singleton (Boxing and Killing)")
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

#subsubsection([Registry])
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

#subsubsection([Monostate(Killing)])
*Problem* | Given code that uses a singleton, you need to remove the singleton for your tests...\
*Solution* | Wrap the singleton access into monostate, which can either return the singleton, or a stub.\
#set text(size: 5pt)
```lang
// this is a regular monostate
public class Monostate {
  private static int x;
  private static int y;
  public int getX() { return x; }
  public int getY() { return y; }
}
// this can instead be used to access the singleton OR a stub:
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
public class MonostateMockImpl implements Monostate {
  private static MockSingleton = new MockSingleton();
  public int getX() {
    return MockSingleton.getX();
  }
  public int getY() {
    return MockSingleton.getY();
  }
}
// both can now be used
```
#set text(size: 8pt)

compared to regular singleton
#columns(2, [
  #text(green)[Benefits]
  - testing, polymorphism 
  #colbreak()
  #text(red)[Liabilities]
])

regular monostate 
#columns(2, [
  #text(green)[Benefits]
  - transparency -> no need to know about monostate 
  - well defined creation and destruction for static members
  #colbreak()
  #text(red)[Liabilities]
  - monostate objects are real -> use memory
  - monostate can lead to unexpected behavior -> static data
  - monostate data is always allocated
  - monostate may not use internal state -> non static state
])

#subsubsection([Killing])
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

#subsubsection([Service Locator])
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
