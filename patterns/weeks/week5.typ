#import "../../utils.typ": *

#subsection("Object Aspects")
- task
  - behavior
  - identity
  - small state
- value
  - behavior
  - state
- entity
  - state
  - small behavior
  - identity
- service
  - behavior

#align(
  center,
  [#image("../../Screenshots/2023_10_20_07_40_21.png", width: 100%)],
)

#section("Values in Programming")
How are values represented in progamming languages?
- types
  - int
  - double
  - etc.
- functions convert values
  - fn(i32) -> i32
- OO -> values represented by objects
  - must be converted since technically values can't have an "identity"

  #subsection("Why objects?")
  Classes allow you to specify what exactly your value type does. For example, if
  you want a temperature value with kelvin, then you need a specific range, by
  using classes, you can ensure that it will be within this range without needing
  to check inside functions that use this value.

  #align(
    center,
    [#image("../../Screenshots/2023_10_20_07_54_38.png", width: 80%)],
  )

  #subsubsection("Issues with objects")
  When using objects, we introduce identity to values, this means whenever we want
  to compare the actual values, we need to make sure to dereference the identity
  -> \*ptr. Or if you are forced to use shit languages: "java".equals("shit") ->
  true !

  #section("Patterns of Value")

  #subsection([Whole Value])
  #set text(size: 14pt)

  Problem | When creating something like a date class, there is an issue with
  parameters, year, month and day are all integers, how can we enforce the correct
  usage at compile time? Use types for each parameter!
- disallows inheritance to avoid slicing
- wraps existing types
- value receives meaning by providing a *dimension and range*\
Context |\
Participants :
-
#set text(size: 11pt)
// images
  //typstfmt::off
  ```java
  // year
  public final class Year {
    public Year(int year) { value = year; }
    public int getValue() { return value; }
    private final int value;
  }

  // ...

  // usage
  public final class Date {
    public Date(Year year, Month month, Day day) { … }
    // ...
  }
  Date first = new Date(new Year(year), new Month(month), new Day(day));
  ```
  //typstfmt::on


  #columns(2, [
    #text(green)[Benefits]
    - enforces value is withing range of meaning
    - usually done at compile time -> no runtime performance hit when used with real languages
    #colbreak()
    #text(red)[Liabilities]
    - change in meaning requires change in code -> less flexible
  ])

  #subsection([Value Object])
  #set text(size: 14pt)

  Problem | When creating an object, we only have an integer to compare the objects, this is not ideal, we usually would like to compare the actual contents, not the identity. How can we do this?\
  Solution | We simply use hashing functions and compare the hash.
  -
  #set text(size: 11pt)
  //typstfmt::off
  ```java
  public final class Date implements Serializable {
    // ...
    private static final long serialVersionUID = -3248069808529497555L;
    // ...
    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;
      Date date = (Date) o;
      return year.equals(date.year) && month.equals(date.month) && day.equals(date.day);
    }
    @Override
    public int hashCode() {
      return Objects.hash(year, month, day);
    }
  }
  ```
  //typstfmt::on



  #columns(2, [
    #text(green)[Benefits]
    - allows you to compare values with identity and multiple values within
    #colbreak()
    #text(red)[Liabilities]
    - change in object requires redoing hash
    - hashing might not always be simple
    - hash collisions possible
  ])

  #subsection([Copied Value and Cloning])
  #set text(size: 14pt)

  Problem | How can we transform value objects from one to the other? \
  Solution | \
  - conversion methods
    - toOtherType method
    - Date.toInstant()
  - constructor
    #align(center, [#image("../../Screenshots/2023_10_20_08_13_23.png", width: 30%)])
  - factory method
    - Date.from(Instant instant) -> same as conversion just static

  #subsection([Immutable Value])
  #set text(size: 14pt)

  Problem | We require a value that is not subject to change and needs to be shared between threads -> immutable and implements Send/Sync\
  Solution | jafuck: make class final, rust: just don't make it mut, lol, also impl Send/Sync, done
  #set text(size: 11pt)
  // images
  //typstfmt::off
  ```java
  public final class Date {
    private final Year year;
    private final Month month;
    private final Day day;
    public Date(Year year, Month month, Day day) {
    // range checks ...
    this.year = year;
    this.month = month;
    this.day = day;
    }
    // ...
  }
  ```
  //typstfmt::on


  #subsection([Enumeration Values])
  #set text(size: 14pt)

  Problem | Same as whole value but range should not change -> Enum\
  Context | Every single language has this these days...
  #set text(size: 11pt)
  // images
  //typstfmt::off
  ```java
  public enum Month {
    JANUARY(1),
    //  ...
    DECEMBER(12);
    private final int value;
    private Month(int value) {
      if (value < 1 || value > 12) {
        // avoid careless mistakes, check value range
        throw new IllegalArgumentException();
      }
      this.value = value;
    }
    public int getValue() {
      return value;
    }
  }
  ```
  //typstfmt::on


  #subsection([Copied Value and Cloning])
  #set text(size: 14pt)

  Problem | Essentially call by value on value objects -> .clone()
  Context | Can be used for memory safety
  #set text(size: 11pt)
  #align(center, [#image("../../Screenshots/2023_10_20_08_23_01.png", width: 70%)])



  #columns(2, [
    #text(green)[Benefits]
    - memory safety
    - call-by-value
    #colbreak()
    #text(red)[Liabilities]
    - runtime overhead
  ])

  #subsection([Copy Contructor])
  #set text(size: 14pt)

  Problem | Copy all values from another object without copying the identity\
  Solution | Loop through all attributes and copy them over\
  #set text(size: 11pt)
  // images
  #align(center, [#image("../../Screenshots/2023_10_20_08_24_12.png", width: 70%)])


  #subsection([Class Factory Method])
  #set text(size: 14pt)

  Problem | How can we create objects without constructors (and adding caching to it)?\
  Solution | Static Functions to create the object\
  #set text(size: 11pt)
  // images
  #align(center, [#image("../../Screenshots/2023_10_20_08_25_58.png", width: 70%)])
  Aka with these constructors we could check whether we already have this date within the cache and just return that if that is the case.



  #columns(2, [
    #text(green)[Benefits]
    - more control over constructor
    #colbreak()
    #text(red)[Liabilities]
    - -
  ])
