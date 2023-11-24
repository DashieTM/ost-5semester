#import "../../utils.typ": *

#section("From distribution to reality")
The idea is, if we do one specific experiment multiple times, then we get
multiple results, aka multiple medians and multiple variances.
#align(
  center,
  [#image("../../Screenshots/2023_11_24_07_06_13.png", width: 100%)],
)

#subsection("Law1")
#set text(16pt)
Law 1: If we have some experiments with n data points as *samples* from them ->
{x1,x2,x3,...,xn}:\
sample median: $E[X] = mu = overline(x) = 1/n sum^n_(i=1)x_i$\
#text(teal)[The sum of random variables is again a random variable!]\
#text(
  teal,
)[The value of this sum is the same as the expected result of the base
  quantity(grundgesamtheit)]\
When considering each element of the sample as a possible value of the random
variable $X_i$ then we can also consider this formula:\
sample median: $overline(X) = 1/n sum^n_(i=1)X_i$\
Variance: $sigma^2_overline(X) = (sigma^2)/n$
#text(
  teal,
)[The bigger n, the smaller the variance of the sample -> makes sense more probes
  means less extreme values. -> E.g. the variance will be closer and closer to the
  variance of the base quantity(grundgesamtheit)]

legend:
- $mu$: Poisson number
- E[X]: Sample median
- $sigma^2$: Variance
#set text(11pt)

Example:
#align(
  center,
  [#image("../../Screenshots/2023_11_24_07_28_05.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_07_28_16.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_07_28_34.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_07_28_47.png", width: 100%)],
)

#subsection("Law2")
#set text(16pt)
If law1 is given -> X is distributed in a normal fashion, then *the sample probe
is also distributed in a normal fashion*:\
$E[X] = mu$ and $sigma_x = sigma_mu/root(2, n)$
Legend:
- $sigma_x$: standard deviation of the random samples
- $sigma_mu$: standard deviation of the base quantity
- $mu$: median of base quantity
- $E[X]$: median of samples
- $overline(X)$: random variable of the sample
- n: amount of samples
#set text(11pt)

Examples:
#align(
  center,
  [#image("../../Screenshots/2023_11_24_07_40_35.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_07_40_50.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_07_41_01.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_07_41_40.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_07_41_53.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_07_42_05.png", width: 100%)],
)

#subsection("T-Distribution or accurate sampletheory")
- used for samples with count below 30 -> normal distribution is bad for this ->
  too general!
- in the examples above -> for n 5 and 25 -> t would have been better!

#set text(16pt)
- r: Freedom value -> how many parameters can be chosen
#text(
  teal,
)[We don't need the formula, just make sure to remember the stuff on the bottom
  right]
#align(
  center,
  [#image("../../Screenshots/2023_11_24_07_52_47.png", width: 100%)],
)
#text(
  red,
)[See the formula, calculate t just like the Z value in the normal distribution
  example] \
- *p: error value -> 0.1 means 10%!!*
#align(
  center,
  [#image("../../Screenshots/2023_11_24_07_54_36.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_08_02_08.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_08_08_36.png", width: 100%)],
)

#align(
  center,
  [#image("../../Screenshots/2023_11_24_08_00_39.png", width: 100%)],
)

#set text(11pt)

#subsection("Chi-Square-Distribution")
- only 1 parameter -> which must be a natural number.
  - this parameter is the freedom value r
- used for test distributions..
  - test of variances
  - (is just an approximation?)
- derivation of the normal distributions
- requires *independent random variables* and *a normal distribution of these
  variables*
- Chi-square is the *sum of all variables squared*
  - Y(function) = $X^2_1 +X^2_2+X^2_3 +X^2_4 +X^2_r$
#align(
  center,
  [#image("../../Screenshots/2023_11_24_08_09_56.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_08_10_10.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_08_10_22.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_08_10_38.png", width: 100%)],
)

