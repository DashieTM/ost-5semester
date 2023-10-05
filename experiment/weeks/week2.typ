#import "../../utils.typ": *

#section("Error Calculation")
#subsection("Maximum Error")
- The worst case scenario
- *if you calculate the maximum error, the boundaries for the error must be known!*
  - e.g. it's not the max error if there is an error that can be worse than this!
  - same would be the case for the minimum error
#subsection("Probable Error")
- is a likely error
- *actual value does not need to be known, can be variable*
  - usually done with a spectrum
#subsection("Usage for error calculation")
- provide accuracy values
  - e.g. this tool is so and so accurate
- provide worst case scenarios -> maximum error

#subsection("Implicit Error")
Implicit errors are used in order to not always provide error calculations for
absolutely everything, especially when it is not necesarily useful or relevant.
In this case, the errors are implicitly added.\

Values of implicit errors:
- minimum: add 0.5(units) to the last digit
  - ex1: 0.002 -> +\- 0.0005 is the possible error
  - ex1: 1 -> +\- 0.5 is the possible error
- maximum: add 3 to 4(units) to the last digit
  - ex1: 0.002 -> +\- 0.004 is the possible error
  - ex1: 1 -> +\- 4 is the possible error

#subsection("The Absolute Error")
This error has a *unit*, namely the same that the measurement has. For example
if we want to measure the length of an object and we start the measurement at
15mm and end at 17mm with an error of 0.5mm, then the errors are added as
follows:\
14.5mm -> 17.5mm, aka subtract 0.5mm from bottom value and add 0.5 to top value.\
used for:
- #text(teal)[additions and subtractions]
  - the rectangle example of the implicit error -> absolute error

#subsection("The Relative Error")
This is derived from the absolute error, it is simply a percentage of the
original value which can be added or removed as error:\
#text(size: 14pt, [$m/e*100$]) *where _m_ is the measurement and _e_ is the absolute error*\
used for:
- #text(teal)[multiplications and divisions]
  - errors of multiplications are done with this as percentages can be converted to
    factors easily

#subsection("Partial Differentiation")
In the previous section, we said we can accumulate factors, this can be seen as
an example here. How do we calculate the error of y squared? Easy, take the
error of y twice!:\
Base calculation:\
#text(
  size: 14pt,
  [$E = (x y^2) / z -> Delta E / E = (Delta x) / x + 2 (Delta y) / y + (Delta z) / z$],
)\
easy way:\
#text(
  size: 14pt,
  [$y^2 -> y * y -> (Delta y) / y + (Delta y) / y -> 2 * Delta y$],
)\
or we can use differentiation...\
#text(
  size: 14pt,
  [$Delta E -> | (delta E) / (delta x) Delta x | + |(delta E) / (delta y) Delta y | + |(delta E) / (delta z) Delta z |$],
)
#align(
  center,
  [#image("../../Screenshots/2023_09_28_09_19_13.png", width: 50%)],
)

#subsection("Usage of minimum and maximum values")
#text(
  red,
)[This is not a particularly useful idea, if this can't be applied easily, you
  should use partial differentiation!]\
#text(
  size: 14pt,
  [$E = (u - v) / (x - y) -> E_max = (u_max - v_max) / (x_max - y_max) -> Delta E = E_max - E$],
)

#subsection("Summary error")
#align(
  center,
  [#image("../../Screenshots/2023_09_28_09_20_15.png", width: 80%)],
)

#subsection("Real world usage")
- create abstraction architecture for tests
  - should resemble real world
- create datasets
- measured values are influenced by stochastic influence values, interruptions and
  errors
- validate systems
- calculate rest error
