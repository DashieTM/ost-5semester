#import "../../utils.typ": *

#section("Approximation Tactics")
Base idea: The problem is that we don't always have the necessary parameters for
all the functions explained previously. Instead, we need to approximate both $mu$ and $sigma$.\
Note, this is a mathematical approach, not random bullshit go, aka it is a
function that tried to *approximate* the result.\

In the end we want 2 things out of the approximation:
- figure out the base quantity
- reduce the error of the approximation or at least measure it

#subsection("Different Tactics")
#subsubsection("Point Approximation")
Here we need the median value $mu$, the variance $sigma^2$ and the probability $p$.
#align(
  center,
  [
    #text(
      teal,
    )[The curved line above T is a common notation to show an approximation or guess.]
    #image("../../Screenshots/2023_11_30_04_50_53.png", width: 100%)
  ],
)
#align(center, [
  #text(teal)[Not relevant for the exam, just for clarification]
  #image("../../Screenshots/2023_11_30_04_51_08.png", width: 100%)
])
#align(
  center,
  [#image("../../Screenshots/2023_11_30_04_51_41.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_30_04_51_56.png", width: 100%)],
)

#subsubsection("Interval Approximation")
Here we compare the parameters from above over an interval to test the error of
the parameters -> reliability score

#subsubsubsection("Expected Value")
#align(
  center,
  [#image("../../Screenshots/2023_11_30_04_52_53.png", width: 100%)],
)
#text(
  teal,
)[
  - the results of the probe are calculated with an approximation function such as
    chi-thai pingpang
  - in an experiment, many results are gathered with again are distributed under a
    function
  - only in case of an unlimited base quantity N are the probes truly independent
    - However, it an be considered "approx unlimited" when we have enough probes -> n
      is big enough
    - see below for when to consider N to be unlimited
]
#align(
  center,
  [#image("../../Screenshots/2023_11_30_04_54_04.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_30_05_59_35.png", width: 100%)],
)

#align(
  center,
  [#image("../../Screenshots/2023_11_30_04_54_16.png", width: 100%)],
)

#set text(14pt)
#text(red)[Steps to build the confidence interval]
+ determine the distribution form of $overline(X)$
+ determine the variance of $overline(X)$, if not deterministic -> approximate
  with $s^2$ see approximation of variance above
+ determine the quantile value of z or t aus table or calculator\
  This is usually taken from a table -> read it from the distribution
+ calculate the maximum approximation error
  - the product of quantile value and standard deviation of X
+ determine confidence borders
  - the top and bottom border are calculated by adding or subtracting the
    approximation error to the median $overline(X)$
#set text(11pt)

Example:
#align(
  center,
  [#image("../../Screenshots/2023_11_30_04_54_32.png", width: 80%)
    N -> 600 n -> 26
    $overline(X)$ -> 124.5g s -> 1.72g],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_30_04_54_44.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_30_04_54_59.png", width: 80%)],
)
#pagebreak()
#set text(14pt)
#text(red)[Steps to build the confidence interval of a fraction -> e.x. 90%]
+ determine the distribution form of $P$.\
  The approximation function is in normal distribution when $n*P (1-P) > 9$.
+ determine variance of P
+ determine the quantile value of z
+ calculate the maximum approximation error
  - the product of quantile value and standard deviation of P
+ determine confidence borders
  - the top and bottom border are calculated by adding or subtracting the
    approximation error to the median $P$
- #text(red)[Alright P is a percentage -> 30% of consumers know brand x]
#set text(11pt)

Example:
#align(
  center,
  [#image("../../Screenshots/2023_11_30_06_20_03.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_30_06_20_36.png", width: 80%)],
)

#set text(14pt)
#text(
  red,
)[This is the reversal, instead of wanting to know the error of something, we
  would like to know the value of something given an error:]

#align(center, [
  with backtracking aka n > 30 aka N $approx$ unlimited:
  #image("../../Screenshots/2023_11_30_06_28_00.png", width: 90%)
])
#align(center, [
  #image("../../Screenshots/2023_11_30_06_28_51.png", width: 90%)
])

#align(center, [
  without backtracking aka n < 30 aka N $approx$ unlimited:
  #image("../../Screenshots/2023_11_30_06_29_59.png", width: 90%)
])
#align(
  center,
  [#image("../../Screenshots/2023_11_30_06_30_09.png", width: 90%)],
)

#subsubsubsection("Variance")
#align(
  center,
  [#image("../../Screenshots/2023_11_30_04_55_35.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_30_04_55_45.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_30_04_55_58.png", width: 100%)],
)

