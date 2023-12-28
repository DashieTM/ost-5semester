#import "../../utils.typ": *

#subsubsection([Parameterize from Above])
#set text(size: 14pt)

Problem | How can I provide individual services that need to run independently
of each other with global data without using singletons?\
Solution | Parameterize from above, aka first define global services and put
them into the application, then register "horizontal" services one by one, see
picture. Participants :
-
#set text(size: 11pt)
// images
The idea is that you have certain services, that need to run at each layer,
while other services need to run on top of each other. This means you can't just
inject the horizontally layered services into the application.
#align(
  center, [#image("../../Screenshots/2023_12_28_04_33_56.png", width: 100%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_28_04_27_41.png", width: 100%)],
)
```java
public final class Bootstrapper {
  public static void main(string[] args) { // PfA applied
    // instantiate vertical layer contexts first
    SecurityContext securityContext = new SecurityContextImpl();
    ConfigurationSettings configuration = new ConfigurationSettingsImpl(args);
    // encapsulate variables into an application context
    var applicationContext = new ApplicationContextImpl(
    securityContext,
    configuration);
    // instantiate horizontal layer contexts from bottom to top
    DataContext dlContext = new DataContextImpl(applicationContext);
    BusinessContext blContext = new BusinessContextImpl(applicationContext, dlContext);
    UIContext uiContext = new UIContextImpl(applicationContext, blContext);
    // show initial UI dialog
    uiContext.show();
  }
}
```

#columns(
  2, [
    #text(green)[Benefits]
    - no global variables
    - implementations of parametrized functionalities are exchangeable
      - additional implementation possible -> testing etc.
    - enforces separation of concerns at architecture level
      - view, logic, data are separated
    #colbreak()
    #text(red)[Liabilities]
    - complexity
      - Object instances aren’t accessible from everywhere; access to application
        context needed
      - Programmers must understand and accept the concept
    - contexts must be passed through the entire application stack
    - fragile bootstrapper: application must be wired completely at startup
  ],
)

#subsubsection([Dependency Injection])
#set text(size: 14pt)

Problem | The bootstrapper from the Parameterize from above pattern is not
flexible enough, hence I want a solution with which I can override existing
services.\
Solution | Inject a framework container with dependencies, which can then be
used, exchanged, etc with framework components. Participants |
- central container, which acts as a service registry
  - container searches for services via *interfaces* provided by user
- code annotations: users apply these to components
  - declare the interface implementations
  - reference required interfaces
  - clients do not reference container directly
#set text(size: 11pt)
// images
#align(
  center, [#image("../../Screenshots/2023_12_28_04_41_52.png", width: 100%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_28_04_42_33.png", width: 100%)],
)

#columns(
  2, [
    #text(green)[Benefits]
    - reduces coupling between client and implementation
      - no need to reference container
    - The contracts between the classes are based on interfaces
      - Classes relate to each other not directly, but mediated by their interfaces
    - Supports the open/closed principle
    - Allows flexible replacement of an implementation
    - Implementations can be marked as “single” (only one in the system) or
      “transient” (new instance per injection)
    #colbreak()
    #text(red)[Liabilities]
    - black magic -> how does this work?
      - code annotations...
    - debugging can be hard
    - recursive dependencies are hard to find and may prevent the system from startup
    - relies on reflection and can result in a performance hit
  ],
)

#subsubsection([Flyweight])
#set text(size: 14pt)

Problem | Many objects use the same constant data, how can we avoid copying this
data, with objects that might also have non-shared data?\
Solution | Create global access to constant data for all objects, hence avoiding
copying this data.\
Participants :
- extrinsic data: unshared data
- intrinsic data: shared data
  - *immutable!*
#set text(size: 11pt)
// images
#align(
  center, [#image("../../Screenshots/2023_12_28_04_52_21.png", width: 80%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_28_04_52_45.png", width: 100%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_28_04_52_56.png", width: 100%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_28_04_53_13.png", width: 100%)],
)
#text(
  red,
)[Note, the UnsharedConcreteFlyweight is essentially it's own object, aka it
  doesn't get included anywhere.]
```java
// FlyweightFactory
package ch.ost.pf.flyweight;

import java.util.Hashtable;

public class FlyweightFactory {
  private final Hashtable<Character, FlyweightChar> chars = new Hashtable<>();

  public FlyweightChar getFlyweight(char key) {
    if (!chars.containsKey(key)) {
      chars.put(key, createFlyweight(key));
    }
    return chars.get(key);
  }

  protected FlyweightChar createFlyweight(char key) {
    return new ConcreteFlyweightChar(key);
  }
}

// FlyweightChar
package ch.ost.pf.flyweight;

public interface FlyweightChar {
    int getCharCode();
}

// ConcreteFlyweightChar
package ch.ost.pf.flyweight;

public class ConcreteFlyweightChar implements FlyweightChar {
    private final char character;

    public int getCharCode() {
        return character;
    }

    ConcreteFlyweightChar(char character) {
        this.character = character;
    }
}
```

#columns(
  2, [
    #text(green)[Benefits]
    - Reduction of the total number of instances (space savings). Savings depend on
      several factors:
      - the reduction in the total number of instances comes from sharing
      - the amount of intrinsic state per object
      - whether extrinsic state is computed (=computation time) or stored (= space cost)
      #colbreak()
      #text(red)[Liabilities]
    - Can’t rely on object identity; stored elements contain Value characteristics
    - May introduce run-time costs associated finding Flyweights, and/or computing
      extrinsic state
  ],
)

Notes:\
- often combined with composite
  - Hierarchical structure as a graph with shared leaf nodes
    - Leaf nodes cannot store a pointer to their parent
    - Parent pointer is passed to the flyweight as part of its extrinsic state
    - Impacts on how the objects in the hierarchy communicate with each other
- handles with fine-grained elements, which contain immutable value
  characteristics
- fine-grained objects are stored globally, lazy initialized
  - Behavior similar to a multi-Singleton; a single class stores multiple shared
    instances
- Objects are created in a Class Factory (Simple Factory / Static Factory
  Method)-like manner
- Flyweight contains a pool of shared objects
  - Pooling pattern by POSA3
- #text(
    red,
  )[Flyweight is categorized as a structural pattern, but it is kinda everything,
    especially creational]
#align(
  center, [#image("../../Screenshots/2023_12_28_04_57_18.png", width: 100%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_28_05_06_16.png", width: 100%)],
)

#subsubsection([Pooling])
#set text(size: 14pt)

Problem | I require fast/efficient access to resources that need to be available
to multiple objects.\
Solution | Create a pool of resources which can be acquired or released by
clients.\
#set text(size: 11pt)
// images
#align(
  center, [#image("../../Screenshots/2023_12_28_05_07_07.png", width: 100%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_28_05_07_22.png", width: 100%)],
)

Notes:\
- Define the maximum number of resources that are maintained by the resource pool
  - Typically set at initialization time of the pool
- decide between lazy or eager acquisition of resources
- Determine resource recycling/eviction semantics
  - E.g. clean up stack after thread execution has completed
  - Use appropriate allocation and destruction patterns
- *Resources are not named -> unlike caching, acquire will get you a random resource!*

#columns(
  2, [
    #text(green)[Benefits]
    - Improves the performance of an application
      - Helps reduce the time spent in costly release and re-acquisition
    - Lookup and release of previously-acquired resources is predictable
    - Simplified release and acquisition of resources
    - New resources can be created dynamically if demand exceeds the available
      resources
    #colbreak()
    #text(red)[Liabilities]
    - The management of resources results in a certain overhead
    - Depending on the environment and resource type, resources must be released back
      to the pool
    - Acquisition requests must be synchronized to avoid race conditions
  ],
)
