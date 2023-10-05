#import "../../utils.typ": *

#section("Base Idea")
the reason we do experiments, is to validate a *Hypothesis*, which is based on a
model of the real world.\
Aka, we think about a supposed way the world works, and then to test this
assumption, we create an experiment to compare the model world to the real
world.

*Note, experimenting is not randomly doing something, it has a purpose!*

#subsection("Mathematical Base")
*statistics* and *error calculation* is the base that covers:
- inaccuracies
- noise
- continuity

#subsection("Experiment Planning")
- keeps the amount of actual experiments low
- only change one factor at a time -> otherwise you can't tell what made the
  difference

#align(
  center,
  [#image("../../Screenshots/2023_09_21_08_42_20.png", width: 50%)],
)

#section("Industrial Experiment Planning (Design of Experiments DOE)")
#columns(2, [
  - Complexity
    - high amount of factors or elements
    - lot of aspects
  - Trickyness (Kompliziertheit)
    - unknown, not understood or hard to describe mechanisms or connections
    - tendency to oversimplify
  - Noise
    - time variation
    - different results after same input
      - inconsistent system
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_09_21_08_50_46.png", width: 90%)],
  )
])
- 1. Research of basics
- 2. Testing of hypothesis and theories
- 3. Development of new products
- 4. Creation of new processes
- 5. Optimization
  - of old processes
  - of cycle time
  - of process parameters
  - of product quality
  - of costs
  - of load
*Experiments can either be done on the real object/real world, or in a simulated
environment.*

#align(
  center,
  [#image("../../Screenshots/2023_09_21_08_55_39.png", width: 70%)],
)
The idea here is that you never know the end result, and the object/world is
always considered to be a black box.\
You can never know the box fully until the end.\
Take into account:
- noise
  - unknown or known inaccuracies
  - often can't be removed
- input factors
  - this is the only thing we can truly influence
- error in measurements
  - we always make errors here, again either consciously or unconsciously

#subsection("Solving a real problem via statistics")
#align(
  center,
  [#image("../../Screenshots/2023_09_21_08_58_58.png", width: 70%)],
)

#section("Terms")
#subsection("Target Values")
This refers to the result of the experiment.\
Can be measurements, calculated values(consider error propagation here).\
Multiple target values can be defined for an experiment.

#subsection("Influence Values")
- Control Values
  - turning knobs we can control
  - input parameters $x^i$
- Noise Values
  - can't be controlled by us
  - unknown value

#subsection("Factors and Factorlevels")
- *Factors*
  out of all values, we take the supposed relevant influence values for the
  experiment, these are called *factors*
- *Factorlevels*
  After choosing the factors, we have to define which values these factors are
  going to have in the experiment.\
  example, in a function graph, where are we in this graph? What values are
  relevant for the section we want to experiment on?
- *Quantitative factors (metric scale)*
  - Number values on the metric scale
- *Qualitative factors (nominal scale)*
  - Names, descriptions, labels

#subsection("Procedure of an experiment")
#align(
  center,
  [#image("../../Screenshots/2023_09_21_09_08_21.png", width: 80%)],
)

#pagebreak()
#subsection("Analysis")
#columns(2, [
  analyze current situation
  #align(
    center,
    [#image("../../Screenshots/2023_09_21_09_16_38.png", width: 90%)],
  )
  #colbreak()
  Define goals of experiment
  #align(
    center,
    [#image("../../Screenshots/2023_09_21_09_17_10.png", width: 90%)],
  )
])
#columns(2, [
  Define Target Values
  #align(
    center,
    [#image("../../Screenshots/2023_09_21_09_18_29.png", width: 90%)],
  )
  #colbreak()
  Best Practice
  #align(
    center,
    [#image("../../Screenshots/2023_09_21_09_18_58.png", width: 90%)],
  )
])

#subsection("example")
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_09_21_09_22_31.png", width: 90%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_09_21_09_22_57.png", width: 90%)],
  )
])
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_09_21_09_23_13.png", width: 90%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_09_21_09_23_27.png", width: 90%)],
  )
])
