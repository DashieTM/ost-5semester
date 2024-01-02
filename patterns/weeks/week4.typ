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
  center, [#image("../../Screenshots/2023_10_06_09_57_36.png", width: 80%)],
)
#align(
  center, [Simple clock, 3 modes -> display time, change hours, and change minutes.\
    On mode change you get to a different state.
    #image("../../Screenshots/2023_10_13_10_23_32.png", width: 70%)],
)
#align(
  center, [#image("../../Screenshots/2023_10_13_10_24_49.png", width: 90%)
    - ClockDataContext: Handles data for the pattern -> all states need to access this
    - ClockState: Parentobject that will redirect calls to each state
    - concrete states: handle calls that will be used
    - OcjectsClickStateMachine: needs both a reference of CLockDataContext(readonly
      for this object) and the clockstate],
)

```rs
// self is necessary to ensure object safety
trait State {
    fn operation(&self) {
        println!("not implemented");
    }
}

struct Context {
    pub state: Box<dyn State>,
}

struct StateStart {}
impl State for StateStart {
    fn operation(&self) {
        println!("Game started");
    }
}

struct StateEnd {}
impl State for StateEnd {
    fn operation(&self) {
        println!("Game ended");
    }
}

fn main() {
    let mut grengeng = Context {
        // traits sizes are not known at compile time
        // create a pointer to interface with V-table
        state: Box::new(StateStart {}),
    };
    grengeng.state.operation();
    grengeng.state = Box::new(StateEnd {});
    grengeng.state.operation();
}
```

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
  center, [#image("../../Screenshots/2024_01_02_02_54_35.png", width: 90%)
  ],
)
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

```java
public class MethodsClockStateMachine implements ClockStateMachine {
  // STATE DEFINITIONS (with transition to other states)
  private final Mode displayingTime = new Mode( // increment, tick, changeMode
      this::doNothing,
      this::updateTime,
      this::nextModeSettingHours);
  private final Mode settingHours = new Mode(
      this::nextHour,
      this::doNothing,
      this::nextModeSettingMinutes);
  private final Mode settingMinutes = new Mode(
      this::nextMinute,
      this::doNothing,
      this::nextModeDisplayingTime);

  // initial state
  private Mode behaviour = displayingTime;

  // data for state management implementation
  private int hour;
  private int minute;
  private int second;

  @Override
  public int getHour() { return hour; }
  @Override
  public int getMinute() { return minute; }
  @Override
  public int getSecond() { return second; }

  /**
   * State machine construction logic goes here...
   */
  public MethodsClockStateMachine(int hour, int minute, int second) {
    this.hour = hour;
    this.minute = minute;
    this.second = second;
  }


  /**
   * Forward 'change mode' event to current state.
   */
  @Override
  public void changeMode() {
    behaviour.getChangeMode().run();
  }

  /**
   * Forward 'increment' event to current state.
   */
  @Override
  public void increment() {
    behaviour.getIncrement().run();
  }

  /**
   * Forward 'tick' event to current state.
   */
  @Override
  public void tick() {
    behaviour.getTick().run();
  }


  // state management implementation
  private void nextMode(Mode nextBehaviour) {
    behaviour = nextBehaviour;
  }

  private void doNothing() { }

  private void updateTime() {
    if (++second == 60) {
      second = 0;
      if (++minute == 60) {
        minute = 0;
        hour = (hour + 1) % 24;
      }
    }
  }

  private void nextHour() { hour = (hour + 1) % 24; }
  private void nextMinute() { minute = (minute + 1) % 60; }

  private void nextModeDisplayingTime() { nextMode(displayingTime); }
  private void nextModeSettingHours() { nextMode(settingHours); }
  private void nextModeSettingMinutes() { nextMode(settingMinutes); }
}

public class Mode {
  private final Runnable increment;
  private final Runnable tick;
  private final Runnable changeMode;

  public Mode(@NotNull Runnable increment, @NotNull Runnable tick, @NotNull Runnable changeMode) {
    this.increment = increment;
    this.tick = tick;
    this.changeMode = changeMode;
  }

  @NotNull
  public Runnable getIncrement() {
    return increment;
  }

  @NotNull
  public Runnable getTick() {
    return tick;
  }

  @NotNull
  public Runnable getChangeMode() {
    return changeMode;
  }
}
```

#columns(
  2, [
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

#subsection([State Pattern (Collection For States)])
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
  center, [#image("../../Screenshots/2023_10_13_10_52_36.png", width: 90%)],
)
#align(
  center, [#image("../../Screenshots/2023_10_13_10_53_07.png", width: 90%)],
)

```java
import java.util.ArrayList;
import java.util.List;

public class CollectionClockStateMachine implements ClockStateMachine {

  // contains all states
  private final List<Workpiece> workpieces = new ArrayList<>();

  private final List<Workpiece> displayingTime = new ArrayList<>();
  private final List<Workpiece> settingHours = new ArrayList<>();
  private final List<Workpiece> settingMinutes = new ArrayList<>();

  // the following fields/properties are only for demonstration purposes; not part of the pattern
  private final Workpiece defaultPiece;

  @Override
  public int getHour() { return defaultPiece.getHour(); }
  @Override
  public int getMinute() { return defaultPiece.getMinute(); }
  @Override
  public int getSecond() { return defaultPiece.getSecond(); }

  /**
   * State machine construction logic goes here...
   */
  public CollectionClockStateMachine(int hour, int minute, int second) {
    // #defaultPiece isn't part of the pattern
    defaultPiece = new Workpiece(hour, minute, second);

    workpieces.add(defaultPiece); // in real world, there are *many* such objects with a state
    displayingTime.addAll(workpieces);
  }

  @Override
  public void tick() {
    displayingTime.forEach(Workpiece::tick);
  }

  @Override
  public void increment() {
    settingHours.forEach(Workpiece::incrementHour);
    settingMinutes.forEach(Workpiece::incrementMinute);
  }

  @Override
  public void changeMode() {
    // simply rotate the objects within the collections
    ArrayList<Workpiece> displayingTimePieces = new ArrayList<>(displayingTime);
    displayingTime.clear();

    displayingTime.addAll(settingMinutes);
    settingMinutes.clear();

    settingMinutes.addAll(settingHours);
    settingHours.clear();

    settingHours.addAll(displayingTimePieces);
  }
}

// workpiece
public class Workpiece {
  private int hour;
  private int minute;
  private int second;

  public int getHour() { return hour; }
  public void setHour(int hour) { this.hour= hour; }

  public int getMinute() { return minute; }
  public void setMinute(int minute) { this.minute = minute; }

  public int getSecond() { return second; }
  public void setSecond(int second) { this.second = second; }

  public Workpiece(int hour, int minute, int second) {
    this.hour = hour;
    this.minute = minute;
    this.second = second;
  }

  public void incrementMinute() {
    minute = (minute + 1) % 24;
  }

  public void incrementHour() {
    hour = (hour + 1) % 24;
  }

  public void tick() {
    if (++second == 60) {
      second = 0;
      if (++minute == 60) {
        minute = 0;
        hour = (hour + 1) % 24;
      }
    }
  }
}
```

#columns(
  2, [
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
  center, [#image("../../Screenshots/2023_10_13_11_11_10.png", width: 70%)],
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
