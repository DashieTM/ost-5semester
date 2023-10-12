#import "../../utils.typ": *

#section("Median")
#subsection("Modus")
- can be used as median
- attribute that is seen most often
- can be scalar or non-scalar
- often not clear -> multiple Modi possible
- example (1,2,6,5,3,4,3,) -> Modus 3
- attributes of Modus
  - easy and fast to determine
  - can be *used on any data*
  - not easily changed by extreme values -> unlike average
  - if all values appear the same amount -> all are modi
#align(center, [#image("../../Screenshots/modus.png", width: 70%)])

#subsection("Median Definition")
- needs a ranking -> nominal values not possible
  - e.g. must be ordinal -> ranked
#set text(14pt)
- depends on value
  - uneven -> Median $M = (n-1)/2 + 1$
  - even -> Median $M = ((n/2)+(n/2+1))/2$
- only offers a difference of 2 sides -> lower than median and higher
- not influenced by extreme values
#align(
  center,
  [#image("../../Screenshots/2023_10_12_10_35_47.png", width: 70%)],
)
#align(center, [#image("../../Screenshots/median.png", width: 70%)])

#set text(11pt)

#subsection("*tile")
- *Quantile* -> 2 parts, split by median
- *Quartile* -> 4 parts -> 25% each
- *Dezile* -> 10 parts -> 10% each
- *Perzentile* -> 100 parts -> 1% each

Calculation Quartile:
#align(
  center,
  [#image("../../Screenshots/2023_10_12_11_01_13.png", width: 70%)],
)
#set text(14pt)
$M_e = u + (n/Q - (H_m - 1))/(H_m - (H_m - 1)) * (o - u)$\
#set text(11pt)
- Q resembles the amount of \*tile -> here 4
- o starting x
- u ending x
- hm - 1 starting y
- hm ending y

#subsection("Arithmetic Mean")
Average of each attribute($x_i$) applied to each object($h_i$).\
#set text(16pt)
$accent(x, -) = 1 / n sum_(i=1)^v x_i * h_i$
#set text(11pt)
- most used
- often criticized -> extreme values influence outcome

#subsection("Harmonic Mean")
The *distance* from objects before and after the median is the same.\

#set text(16pt)
$accent(M_H, -) = (sum_(i=1)^v h_i)/(sum_(i=1)^v h_i/x_i)$
#set text(11pt)
- $h_i$ object
- $x_i$ attribute of interest
- $v$ amount of elements
- no 0 values allowed -> div by 0!
- attribute of interest must be relative
#align(
  center,
  [#image("../../Screenshots/2023_10_12_11_21_57.png", width: 70%)],
)

#subsection("Geometric Mean")
- not comparable with the previous means
- attributes need to be relative
- $x_i$ is a quotient -> result of division
  - usually a starting value and end value -> for example for growth per year
  - value must be bigger than 0 -> div by 0!
- the *only* method applicable for growth over a time span
#align(
  center,
  [#image("../../Screenshots/2023_10_12_11_38_57.png", width: 70%)],
)
#align(center, [
  The growth for this image is 12.5%\

  #set text(16pt)
  $M_G = root(n, (product_(i=1)^n x_i))$
])
#set text(11pt)

#section("Ranges")
#subsection("Range (Spannweite)")
- easy to understand
- no information about values in this range
- easily influenced by extreme values
- attribute must be interval scalable
Calculation:\
#set text(16pt)
$R = text(min) - text(max)$\
R = Range
#set text(11pt)

#subsection("Central Quartile Distance (ZQA)")
- not influenced by extreme values
- attribute must be interval scalable
- usable when a specific range is of interest
#align(
  center,
  [#image("../../Screenshots/2023_10_12_11_54_08.png", width: 60%)],
)
Calculation:\
#set text(16pt)
$ text("ZQA") = Q_3 - Q_1$\
#set text(11pt)
#align(
  center,
  [#image("../../Screenshots/2023_10_12_11_54_39.png", width: 70%)],
)

#subsection("Mean absolute Difference (Mittlere absolute Abweichung)")
- attributes must be interval scalable
- better than variance
- extreme values can be an issue
Calculation:\
#set text(16pt)
$delta = 1/n sum_(i=1)^v |x_i - accent(x, -)| h_i$\
- n: count of objects
- v: count of attribute values
- hi: absolute quantity of objects with a specific attribute value
#set text(11pt)
#align(
  center,
  [#image("../../Screenshots/2023_10_12_11_58_02.png", width: 70%)],
)

#subsection("Variance / standard deviation")
- attributes must be interval scalable
- not easy to understand immediately
- can't be interpreted
- extreme values are a big issue
- good for describing statistic but not for closing statistic
Calculation:\
#set text(16pt)
$sigma^2 = 1/n sum_(i=1)^v (x_i - accent(x, -)^2 * h_i)$\
- n: count of objects
- v: count of attribute values
- hi: absolute quantity of objects with a specific attribute value
- $sigma$: variance / standard deviation
#set text(11pt)
#align(
  center,
  [#image("../../Screenshots/2023_10_12_11_58_28.png", width: 70%)],
)

#subsection("Variation Coefficient")
*The Division of Standard Deviation and arithmetic mean multiplied by 100.*
- attribute must be interval scalable
- comparison between the 2 means
#align(
  center,
  [#image("../../Screenshots/2023_10_12_12_19_41.png", width: 70%)],
)

#section("BoxPlot")
#align(
  center,
  [#image("../../Screenshots/2023_10_12_12_20_04.png", width: 100%)],
)
