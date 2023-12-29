== Atomic Parameter Patterns
<atomic-parameter-patterns>
Moderator: Fabio Lenherr
=== Interface Representation Patterns
<interface-representation-patterns>
==== Structural Representation Patterns
<structural-representation-patterns>
There are various structural patterns for API representation design. The
following key quality attributes are especially siginificant:

+ Interoperability: Ensuring the API can seamlessly work across different
  platforms and programming languages.
+ Performance: Optimizing factors such as latency, network resource consumption,
  and message verbosity.
+ Developer Convenience and Experience: Balancing ease of use for both API
  consumers and providers.
+ Maintainability: Facilitating the ability to evolve API clients and providers
  independently without disruptions, often by aiming for loose coupling.
+ Security and Data Privacy: Ensuring the confidentiality, integrity, and
  availability of data in transit and guarding against malicious tampering or
  impersonation.

Note: Quality attributes can vary depending on whether the API is public or
internal.

==== Structures for API
<structures-for-api>
- Single structured
- Single atomic
- Multiple structured
- Multiple atomic
- Pagination

==== Atomic Parameter
<atomic-parameter>
Problem:

Two applications need to communicate over a network, how can these applications
guarantee consistent data when (possibly) different technologies are used?

Forces:

- Interoperability -\> Only create custom ones when needed
- Expressiveness: Specify undefined or NULL values explicitly
- Information: Specify ranges in API documentation
- Performance: API should not spam network

Solution:

Use single parameters with a singular scalar value that should be as universal
as possible (int over Integer class -\> java). These singular parameters can
have limited ranges or might possibly be nullable, however, this should be
documented in the API documentation.

Liabilities:

- Might become spammy -\> too many single parameters -\> too many single packets
- Not very expressive
- Additional work needed for strong statically typed languages -\> rust, haskell

Uses:

- Remote API with #emph[low] amount of information sent or received

==== Atomic Parameter List
<atomic-parameter-list>
Problem:

This is an extension of the Atomic Parameter pattern. How do you handle sending
multiple data units to the server?

Solution:

- To transmit two or more simple, unstructured information items, define multiple "Atomic
  Parameters."

Forces:

- Performance: Instead of sending multiple API calls with a single Atomic
  Parameter, combine then into a list to preserve network capacity and server-side
  resources. Organize these Atomic Parameters in an ordered list.

Liabilities:

- Serialization and deserialization needed (not always natively supported)
- More work, less expressive than single atomic parameters

Uses:

- Remote API with #emph[high] amount of information sent or received
- Facebook’s Graph API
- Twitter API
=== Prüfungsfragen
<prüfungsfragen>
- Are Atomic Parameter Lists suitable for all programming languages out of the
  box? \[no\]
- Single Atomic Parameter is a suitable pattern for a notification daemon with
  optional image and response functionality \[no\]
== Auftrag 2
<auftrag-2>
Moderator: Fabio Lenherr
=== Structural Representation Patterns
<structural-representation-patterns>
==== Parameter Tree Pattern
<parameter-tree-pattern>
Problem: A simple message format has been defined, like Atomic parameter or
Atomic parameter list. But this simple message format does not fully satisfy the
information need of the message receiver.

Forces:

- Expressiveness and efficiency have to be balanced.
- Interoperability
- Serialization time
- Learning effort and maintainability
  - security -\> checks forgotten

Solution: The solution is to organize the data in a message echange format, like
JSON or XML. A primary container called root is created, that can hold various
kinds of data structures, like tuples (which combine different types of data,
such as a ZIP code and a city name) or arrays (which group elements with the
same structure).

These structures can then be nested inside of each other.

Liabilities:

- Big tree can cause serialization issues
- Different trees might be requested -\> too many requests
- Tree structure needs to be perfectly documented -\> otherwise hell to maintain
  or use
- Accept everything, but send only what you specified
  - Specify upper and lower boundaries -\> arrays
  - Be specific about possible null values
- careful with complex structures such as key-value mappings -\> see
  networkmanager dbus

Uses:

- Notification dbus
=== Parameter Forest Pattern
<parameter-forest-pattern>
==== Forces same as above
<forces-same-as-above>
Problem: What if I want multiple trees?

Solution: Use multiple trees on the top level.

Liabilities:

- limit the number of trees
- provide tests and use suitable messaging formats such as xml or json
- be careful with spikes -\> trees that might be extremely big or small
  - worse performance
  - harder to maintain
  - harder to protect against tampering

Notes:

- can have multiple roots -\> multiple trees
=== Pagination Pattern
<pagination-pattern>
Problem: How to provide large amounts of data that doesn’t really fit into a
single response.

Solution:

- send only parts (agreed upon fixed size or dynamic)
- The pattern has variants such as Offset-Based Pagination, Cursor-Based
  Pagination (also known as Token-Based Pagination) and Time-Based Pagination
- The default page-based Pagination and its Offset-Based Pagination variant are
  quite similar

Forces:

- Page size -\> how much do we send/receive?
- Variability of data (Identically structured? How often data definition changes)
- Memory available for a request (both on provider and on consumer side) and data
  currentness

Liabilities:

- pattern needs to be applied consistently
- max size needs to be chosen carefully
- pagination is of limited use when all data is loaded either way
- additional pages should be included with dymanic links that are timestamped
- big datasizes lead to potential DDOS, problems with packet sizes, performance
  issues especially without serialization libraries
=== Prüfungsfragen
<prüfungsfragen>
- Can Parameter Tree Pattern handle multiple trees on the top level for multiple
  trees? \[No\]

- Is Pagination Pattern mainly for handling large data that doesn’t fit in a
  single response? \[Yes\]

  #figure(
    [#image(width: 50%,"../presentations/uploads/094f3812bc6fd3c1f68add604a9145c5/list.png")], caption: [
      list.png
    ],
  )

  #figure(
    [#image(width: 50%,"../presentations/uploads/b276b829704c67a42ee691be7a31d65a/tree.png")], caption: [
      tree.png
    ],
  )

  #figure(
    [#image(width: 50%,"../presentations/uploads/22d866a2ed3c51d25127f3d812c80249/forest.png")], caption: [
      forest.png
    ],
  )

  #figure(
    [#image(width: 50%,
        "../presentations/uploads/7a8ca424c530b3fd309a7168fa1660f8/pagination.png",
      )], caption: [
      pagination.png
    ],
  )
== Auftrag 3
<auftrag-3>
Moderator: Nick Götti
=== Version Identifier
<version-identifier>
Problem: How can an API provider indicate its current capabilities as well as
the existence of possibly incompatible changes to clients?

Forces: - Accuracy and exact API version - Minimizing impact on client -
Guaranteeing API changes don’t cause accidental breakage - Traceability for
versions

Solution: Introduce an explicit version number into the exchanged messages to
indicate the API version.

Examples: Version of representation format
#image(width: 50%,
  "../presentations/uploads/f55758d145d702374870c5721495a8be/represenation.png",
)

Specific operation
#image(width: 50%,
  "../presentations/uploads/2e2d3801a405b2dff4b85c5c7b8792b1/operation.png",
)

Whole Api #image(width: 50%,"../presentations/uploads/2735a3a0967525f807ea094e138e4de0/api.png")

JSON payload
#image(width: 50%,
  "../presentations/uploads/742cae61ab201413c72205d3940e654e/payload.png",
)

benefits: - Reduces likelihood of breakage because of api changes - Makes
version tracing possible - Helps to identify proper API early

Liabilities: - Governance - Version changes don’t always introduce changes in
functionality
=== Semantic Versioning
<semantic-versioning>
Problem: How can stakeholders compare API versions to immediately detect whether
they’re compatible? How to differentiate between bug fixes and breaking changes?

Forces: - Minimal effort to detect version incompatability - Manageability of
api versions - Clarity of change impact

Solution: Introduce a hierarchical three-number versioning (e.g 1.1.1)

Example:
#image(width: 50%,
  "../presentations/uploads/c834347ce17c41236f0b9aac97d2a026/versioning.png",
)

Benefits: - Clarity for clients about compatibility

Liabilities: - Increased effort to determine version identifiers
=== Two in Production
<two-in-production>
Problem: How can a provider gradually update an API without breaking existing
clients, but also without having to maintain a large number of API versions in
production?

Forces: - Ability to roll back API - Minimize changes to the client by API -
Minimize maintenance effort for clients and server - Time for clients to
implement changes

Solution: Deploy and support two versions of an API endpoint. Update and
decommission (i.e. deprecate and remove) the versions in a rolling, overlapping
fashion

Benefits: - Clients have time to implement new API - Reduces likelihood of
undetected changes further

Example: #image(width: 50%,
  "../presentations/uploads/91b75328686095c4f5878b8cb567b2ee/rollout.png",
)

Liabilities: - Clients have to adapt to incompatible API changes over time -
Causes additional costs for operating multiple API versions
=== Limited Life time Guarantee
<limited-life-time-guarantee>
Problem: How can a provider let clients know for how long they can rely on the
published version of an API?

Forces: - plannable API changes - maintenance effort

Solution: As an API provider, guarantee to not break the published API for a
given, fixed timeframe.

Benefits: - No multi version support needed - Clients know about changes
- Clients have enough time to change API

Liabilities: - Limits ability to respond to urgent change requests - Forces
clients to upgrade at a defined point in time - Clients do not always update API
even with this method -\> see windows EOL
=== Prüfungsfragen
<prüfungsfragen>
- Should fixes only increment the third part of the semantic versioning?(1.1.0 -\>
  1.1.1) \[yes\]
- Semantic versioning makes it easier to differentiate between bug fixes and
  breaking changes in an API \[yes\]

=Auftrag 4 Moderator: Felix
=== Game Loop basics
<game-loop-basics>
The game loop has the following base functionality that it needs to implement:

```c
while(true) {
  // handle user input
  process_input();
  // move player, move objects, enemies etc
  update();
  // after moving we update the UI
  render();
  // move time forward -> see below
}
```

#image(width: 50%,
  "../presentations/uploads/241c3957b083c9533158d990bd8084f2/bevy-function.png",
)
#image(width: 50%,"../presentations/uploads/3d2ff886e4051235f3d8b38b9eb3aac3/bevy.png")
=== Fixed Time Step with No Synchronization:
<fixed-time-step-with-no-synchronization>
Run the game loop as fast as possible without synchronization. This was mostly
used in the early days of gaming.

Benefits:

- Simple implementation

Liabilities: - Game speed directly affected by hardware and complexity.
- Gameplay is faster on a fast machine Liabilities: - Game speed
directly affected by hardware and complexity. - Gameplay is faster on a fast
machine

#figure(
  [#image(width: 50%,
      "../presentations/uploads/afaf7dc8d9b2d75757b16d28ef170411/fixedTime.png",
    )], caption: [
    fixedTime
  ],
)
=== Fixed Time Step with Synchronization:
<fixed-time-step-with-synchronization>
Run the game at a fixed time step but add a delay or synchronization point to
prevent it from running too fast.

Benefits:

- Relatively simple with added power efficiency and doesn’t play too fast
- saves power
- good when implemented as option -\> fps slider

Liabilities: - Game can still play too slowly if updates take too long - CPU
thread scheduling is not guaranteed - bad when forced -\> NFS Rivals

#figure(
  [#image(width: 50%,
      "../presentations/uploads/383d7a7d5ad1a12eed9eb24ec1073422/fixedTimeS.png",
    )], caption: [
    fixedTimeS
  ],
)
=== Variable Time Step
<variable-time-step>
Adapt to playing both too slowly and too fast by adjusting the time step.

Benefits: - Adaptable to varying processing speeds.

Liabilities: - Makes gameplay non-deterministic and unstable. Can complicate
physics and networking. - aka ball moves through wall randomly cuz fun - Update
function is called every frame, with 180frames per second this is 180 times,
with 60 frames this is 60 times -\> hence the first pc will have more update
calls than the second. This will create a floating point error delta between the
two PCs.

#figure(
  [#image(width: 50%,
      "../presentations/uploads/776785bef3ce0cdd37b042783e57d2d0/varTime.png",
    )], caption: [
    varTime
  ],
)

Example from bevy:

```rs
 transform.translation.y -= 50. * bullet.speed * timer.delta_seconds();
```
=== Fixed Update Time Step, Variable Rendering:
<fixed-update-time-step-variable-rendering>
Update with a fixed time step but drop rendering frames if necessary to catch up
to the player’s clock.

Benefits:

- Adapts to playing both too slowly and too fast, providing smoother gameplay on
  high-end machines.
- Floating point error delta between different pcs eliminated.

Liabilities: - More complex implementation, requiring tuning of the update time
step for different hardware.

#image(width: 50%,
  "../presentations/uploads/a4ae4893cf9406606b680fb9148f1cc1/physicswait.png",
)
#image(width: 50%,
  "../presentations/uploads/4754664079677c4012e41022735b6da7/fixTimeVar.png",
)

```c
// variable rendering with:
render(lag / MS_PER_UPDATE);
// visibly move objects -> physics is not changed, player just sees something as "moved"
```
=== Prüfungsfragen
<prüfungsfragen>
- Fixed update time step solves the issue of floating point errors.\[yes\]
- Fixed time stamp with no synchronization is the preferred variant by
  gamers.\[no\]

#figure(
  [#image(width: 50%,
      "../presentations/uploads/73ef97c1ed6b2d8a9322d3c1328ce56f/monobehaviour_flowchart.svg",
    )], caption: [
    monobehaviour\_flowchart.svg
  ],
)
== Auftrag 5
<auftrag-5>
Moderator: Fabio
=== Component
<component>
How can a single entity span multiple domains without coupling the
domains to each other?

Problem: - Creating monolithic classes that handle multiple
responsibilities is hard to change - A game character class that handles
input, sound, physics and the rendering. This becomes a large file very
quickly.

#figure([#image(width: 50%,"../presentations/uploads/e1b615ffcf3fb7ee180e78a4926db098/player.png")],
  caption: [
    player
  ]
)

#figure([#image(width: 50%,"../presentations/uploads/662bfa86dafc4fd021b6e198a6fe43f3/bad-bjorn.png")],
  caption: [
    bad-bjorn
  ]
)

Solution: - Place the different components into different classes. Input
into InputComponent and the game character has an instance of it. Entity
is reduced to a container of components

#image(width: 50%,"../presentations/uploads/c5c8ffa55e7f77517cb0dd1a99ddc4c8/component-bevy.png")
#image(width: 50%,"../presentations/uploads/0cf700577d0d4b29c1b7423b18fe09ee/good-bjorn.png")

Benefits: - Components become reuseable packages - Developers can work
on a component without needing knowledge on how other components work

Liabilities: - More complexity - More indirection

==== Additional Information
<additional-information>
===== Diamond (or why not to use inheritance)
<diamond-or-why-not-to-use-inheritance>
This refers to a class inheriting from 2 classes which in return will
inherit the same class. This leads to undefined behavior as the system
can’t determine which function to use.

#figure([#image(width: 50%,"../presentations/uploads/8986ed9ce8851a72672148ca59709beb/diamond.png")],
  caption: [
    diamond
  ]
)

===== ECS (Entities Components Systems)
<ecs-entities-components-systems>
#image(width: 50%,"../presentations/uploads/cb2d4ada762601c9a55c91d1d4bee1b6/ecs.png") This takes
the component pattern to the extreme by only storing ids of components.
This allows for fast queries of components, which in return solves the
complexity of component interaction:

#figure([#image(width: 50%,"../presentations/uploads/065052c0427ee26879e7be948c3e4da6/reset-powerup.png")],
  caption: [
    reset-powerup
  ]
)

===== Data Locality
<data-locality>
Accelerate memory access by arranging data to take advantage of CPU
caching (L1, L2, L3 cache). Components are often stored in contiguously,
which means they are spatially local. This reduces the need to fetch
data from slower levels of the memory hierarchy and improves access
speed.

===== Polymorphism
<polymorphism>
Instead of attaching a component directly, one can also use pointers in
order to provide more flexibility. This would mean you can create
versions of a specific component to attach -\> a player might want a
player-input component, which in return is a input component. With this
a different type of player can have a different input component, or the
same player on a different level etc.

```cpp
// class stuff
private:
  InputComponent* input;    // can be casted and hence dynamic
  PhysicsComponent physics; // can't be casted -> always the same functionality
```

Benefits: - flexibility

Liabilities: - indirection - Vtable

===== Communication options
<communication-options>
- Container state / global state
  - multiple writers can lead to race condition
  - 1 writer / multiple readers -\> for true "state" values
- Directly
  - parent to child
    - child to parent needs inheritance
  - simple and fast
  - not flexible
- messages
  - good when recipient might need to respond or handle the action
    immediately
  - can be combined with queue
  - broadcast
  - see bevy example above with "EventReader"
=== Questions
<questions>
Is inheritance preferable to composition? - No

The component pattern creates more objects which decreases the
performance, can data locality help to decrease the performance losses?
- yes
== Event Queue
<event-queue>
How to decouple the sending of an event/message from when it is
processed.

Problem: User input needs to be stored to prevent the operating system
from forgetting it between receiving input and processing it.

Solution: Store it in a queue. For example: A Combat Code can send
events, such as "enemy died," and any system can receive events from the
queue, then a tutorial system can display "Press x to loot" over a dead
enemy.
=== Interrupts vs. Events
<interrupts-vs.-events>
Interrupts are abrupt, immediately disrupting any ongoing workflows via
the operating system. In contrast, events can be queued up and are
handled when the program in question decides to do so.
=== Context
<context>
Events can facilitate the queuing of activities with specific
requirements:

#emph[Concurrency]: Events can be handled at any time, ensuring that
they do not block the main loop with activities like loading.

#emph[Prioritization]: Instances where similar events occur frequently,
such as in sound processing, require prioritization.

#emph[Memory]: Event queues provide limited storage for events. - This
aligns with concurrency, allowing events to be handled asynchronously. -
By storing events and deferring their processing, we avoid simultaneous
access from multiple sources to the audio thread, preventing blocking
behavior.

==== Central vs. Local
<central-vs.-local>
- Central is global -\> anyone can send/get events to/from it.
- Centralization can lead to problems:
  - Different event types
  - Size
=== Benefits
<benefits>
- Concurrency
  - Time and space separation.
- Decoupling
- Overall performance improvement -\> Concurrency
=== Liabilities
<liabilities>
- Complexity
- Single-request performance may worsen.
- Fire-and-forget requests are not suitable if a response is necessary.
- Feedback loops:
  - A sends an event
  - B receives the event and responds with an event
  - A receives the event and also responds with an event
  - Repeat infinitely
- Events can get lost if not handled.
- Memory usage

#image(width: 50%,"../presentations/uploads/bf150d1caed0d14d720304a21b3bd15c/bevy1.png")
#image(width: 50%,"../presentations/uploads/f2fb1b520a084f9298850c958230ea94/bevy2.png")
#image(width: 50%,"../presentations/uploads/9160090cd611dca6e7c3ec3b787d6b2c/illustration.png")

#image(width: 50%,"../presentations/uploads/38fce3977f9ee309d85a164928fca742/events5.png")
#image(width: 50%,"../presentations/uploads/92cdb2c30b411b9751bf5662602cfca0/events6.png")
#image(width: 50%,"../presentations/uploads/e97e0987c1dac015e4212b9ccd6bff97/events7.png")
=== Ring Buffers
<ring-buffers>
Ring buffers allow continuous adding and deleting of events without
shifting elements.

#image(width: 50%,"../presentations/uploads/49a113dc502555456caa7fd38f53f5c0/illustration2.png")
#image(width: 50%,"../presentations/uploads/07e723f6971077fd03367d9d6de572f8/events8.png")
#image(width: 50%,"../presentations/uploads/2eed469bf706a7df98890755d2eaee41/events9.png")
#image(width: 50%,"../presentations/uploads/0987835aa6959a15cd9d4af8ad58b66b/events10.png")
#image(width: 50%,"../presentations/uploads/350635c551de62764fd680447312ae14/events11.png")
=== Aggregating Events
<aggregating-events>
Duplicate entries can be aggregated within the queue -\> for example,
avoid to play the same sound twice, or even worse, twice the volume.

The window for looping through the event queue is not umlimited. It
might be necessary to do this in a different function -\> update(), or
you might add a hashmap for content.

==== Concurrency
<concurrency>
Make sure to always put the function that will be run on the event into
another thread if it does something specific -\> playSound, please don’t
use the same thread there.

==== Queues
<queues>
- Single Cast
- Request
- Broadcast
  - Event to all listeners
  - Events often filtered by listeners
  - Performance issues if too many listeners or events
  - Zero listeners -\> Discard event
- Worker Queue
- Split events
  - Different listeners get different events -\> more like a thread
    worker queue
=== Memory
<memory>
#figure([#image(width: 50%,"../presentations/uploads/2cdb16626f7c696d9c57806d8c42107e/image.png")],
  caption: [
    image
  ]
)

==== Questions
<questions>
- Does an event queue help synchronize actions in a game? \[no\]
- Does the use of ring buffers allow for continuous adding and deleting
  of events without the need for shifting elements? \[yes\]
