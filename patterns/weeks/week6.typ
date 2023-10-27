#import "../../utils.typ": *

#subsection([Mutable Companion])
#set text(size: 14pt)

Problem | We need a way to mutate immutable variables later on, but that's
impossible. However, we can make a wrapper class around the immutable object and
just mutate that instead, e.g. creating a new instance of the immutable object
which isn't immutable.\
Participants :
- companion: factory object for immutable value
- immutable value
#set text(size: 11pt)
// images
```java
public final class YearCompanion {
  private int value;
  public YearCompanion(Year toModify) {
    this.value = toModify.getValue();
  }
  public void next() {
    value++;
  }
  public Year asValue() { // factory method
    return Year.of(value);
  }
}

// usage
var yearBuilder = new YearCompanion(
Year.of(2020));
yearBuilder.next();
var nextYear = yearBuilder.asValue();
```

#align(
  center,
  [#image("../../Screenshots/2023_10_27_10_55_32.png", width: 80%)],
)
#text(
  teal,
)[The *asYear* function is called a *Plain Factory Method* that converts the
  companion to the immutable value.]\

In multithreaded environments, it is often a good idea to combine methods as
that makes synchronization easier(*Combine Method idiom*):
#align(
  center,
  [#image("../../Screenshots/2023_10_27_10_56_56.png", width: 80%)],
)

#columns(
  2,
  [
    #text(green)[Benefits]
    - changes on immutable values
    #colbreak()
    #text(red)[Liabilities]
    - requires double the amount of ram -> don't do this with extremely large structs
  ],
)

#subsection([Relative Values])
#set text(size: 14pt)

Problem | When we compare reference objects, we compare only the reference, how
can we make sure to compare the type/value instead? Create comparator(jafuck),
implement Eq trait(rust), overload comparison operators(C++).\
#set text(size: 11pt)
// images
```java
public final class Year implements Comparable<Year> {
  @Override
  public boolean equals(Object o) {    // Bridge Method, override generic equals()
  if (o == null || getClass() != o.getClass()) return false;
    return equals((Year)o);           // forward to typed method
  }
  public boolean equals(Year o) {      // Override-Overload Method Pair
  if (this == o) return true;
  if (o == null) return false;
    return value == o.value;
  }
  @Override
  public int compareTo(Year o) {       // Override-Overload Method Pair, Type Specific Overload
    if (o.value == value) return 0;
      return (value < o.value) ? -1 : 1;
  }
}
```
#text(
  teal,
)[Rust requires the Eq and PartialEq trait, C++ just requires overloading of
  operators -> spaceship operator.]

#section("CHECKS Pattern")
How to differentiate good input from bad input -> ensure temperature has valid
value.
#align(
  center,
  [#image("../../Screenshots/2023_10_27_11_03_52.png", width: 100%)],
)

#subsection([Meaningful Quantities])
#subsubsection([Exceptional Behavior])
#set text(size: 14pt)

Problem | When receiving an input, the input can be an *exceptional value*, this
is often a null value or undefined -> Err value or None. This can be a valid
input for the backend, but the backend has to handle it.\
#set text(size: 11pt)
// images
```ts
export enum CalculationError {
  DivByZero = "div/0",
  NumeratorIsNaN = "NaN(numerator)",
  DivisorIsNaN = "NaN(divisor)“
}
export class Calculator {
  public static divide(numerator: number, divisor: number): number | CalculationError {
    if (divisor === 0) { return CalculationError.DivByZero; }
    if (isNaN(numerator)) { return CalculationError.NumeratorIsNaN; }
    if (isNaN(divisor)) { return CalculationError.DivisorIsNaN; }
    return numerator / divisor;
  }
}
```

#subsubsection([Meaningless])
#set text(size: 14pt)

Problem | This is essentially just the idea of let's try to run it and handle
the errors later. E.g. try to divide by 0 and when something bad happens -> div
by 0, we will handle that state later.\
#set text(size: 11pt)
// images
```java
export class Calculator {
  public static divide(numerator: number, divisor: number): number {
    return numerator / divisor; // may result in Infinity (Java: NaN) if divisor is 0.0
  }
}
```

#columns(2, [
  #text(green)[Benefits]
  - exceptions don't have to be added everywhere
  #colbreak()
  #text(red)[Liabilities]
  - exceptions get a bit out of hand -> catch all needed
])

#section("Frameworks")
- implement common functionality
  - don't reinvent the wheel
  - avoid bad performance by using something that is established and optimized
- Control stays with user in contrast to a simple library
  - *inversion of control*
  - callback hooks
  - extensions
  - see react
#align(
  center,
  [#image("../../Screenshots/2023_10_27_11_22_33.png", width: 100%)],
)

#subsection("Application Frameworks")
- object-oriented class library
- main() lives in application framework
- provided hooks
- provides ready-made classes for use
- product lines use these -> office application all use the same base
#align(
  center,
  [#image("../../Screenshots/2023_10_27_11_20_41.png", width: 50%)],
)

#subsection("Micro Frameworks")
#subsubsection("Template Method")
The idea is, the abstract class provides methods that can be overriden and extended.
#align(
  center,
  [#image("../../Screenshots/2023_10_27_11_25_21.png", width: 80%)],
)

#subsubsection("Strategy")
Use different strategies based on context.
#align(
  center,
  [#image("../../Screenshots/2023_10_27_11_25_09.png", width: 80%)],
)

#subsubsection("Command Processor")
#align(
  center,
  [#image("../../Screenshots/2023_10_27_11_24_51.png", width: 80%)],
)
