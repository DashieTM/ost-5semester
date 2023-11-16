#import "../../utils.typ": *

#section("Continuous Distribution")
The issue with continuous distributions is that we no longer have specific
intervals, aka we can't do regular math anymore -> we might need derivations and
integrations.\
In other words, we are now calculating a range, and not specific timestamps.
#align(
  center,
  [#image("../../Screenshots/2023_11_16_06_03_35.png", width: 80%)],
)

#subsection("Rectangle Distribution")
- all events have the same probability
- events can appear within a certain timeframe -> aka within the rectangle

#columns(2, [
  #set text(16pt)
  $E(X) = (a + b)/2$
  $#text("Var") (X) = sigma^2 = 1 / 12 * (b - a) ^ 2$
  $sigma approx 0.289 𝑏 − 𝑎$
  #set text(11pt)
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_06_07_19.png", width: 80%)],
  )
])
Examples:
#align(
  center,
  [#image("../../Screenshots/2023_11_16_06_08_36.png", width: 80%)],
)

#subsection("Triangle Distribution")
#align(
  center,
  [#image("../../Screenshots/2023_11_16_06_10_35.png", width: 80%)],
)

Examples:
#align(
  center,
  [#image("../../Screenshots/2023_11_16_06_10_49.png", width: 80%)],
)

#subsection("Exponential Distribution")
#columns(2, [
  #set text(16pt)
  $E(X) = 1/lambda$
  $#text("Median") = ln(2)/Lambda approx 0.69/Lambda$
  $#text("Modus") = 0$
  $#text("Var") (X) = sigma^2 = 1/Lambda^2$
  #set text(11pt)
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_06_12_58.png", width: 80%)],
  )
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_06_13_08.png", width: 40%)],
  )

])
Examples:
#align(
  center,
  [#image("../../Screenshots/2023_11_16_06_13_26.png", width: 80%)],
)
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_06_42_56.png", width: 100%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_06_43_23.png", width: 100%)],
  )
])

#subsection("Weilbul Distribution")
#align(
  center,
  [#image("../../Screenshots/2023_11_16_06_44_10.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_16_06_44_38.png", width: 30%)],
)

Examples:
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_06_45_14.png", width: 100%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_06_45_26.png", width: 100%)],
  )
])

#subsection("Gama Distribution")
#set text(16pt)
$E(X) = k * theta$
$#text("Var") (X) = sigma^2 = k * theta^2$
#set text(11pt)
#align(
  center,
  [#image("../../Screenshots/2023_11_16_06_49_10.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_16_06_54_56.png", width: 80%)],
)

#subsection("Normal Distribution")
- all variables that occur need to be independend of each other
- variable count needs to be "enough" -> statistically significant
- no random variable is an extreme value
#align(
  center,
  [#image("../../Screenshots/2023_11_16_10_53_57.png", width: 80%)],
)
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_10_54_21.png", width: 100%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_10_54_42.png", width: 100%)],
  )
])
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_10_55_03.png", width: 100%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_10_55_13.png", width: 100%)],
  )
])
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_10_55_32.png", width: 100%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_10_55_42.png", width: 100%)],
  )
])

#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_10_56_01.png", width: 100%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_10_56_10.png", width: 100%)],
  )
])
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_10_56_28.png", width: 100%)],
  )

  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_11_16_10_56_36.png", width: 100%)],
  )

])

Example:
#align(
  center,
  [#image("../../Screenshots/2023_11_16_10_56_48.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_16_10_57_01.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_16_10_57_12.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_16_10_57_27.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_16_10_57_36.png", width: 100%)],
)

#subsection("Overview")
#align(
  center,
  [#image("../../Screenshots/2023_11_16_10_57_55.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_16_10_58_15.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_16_10_58_28.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_16_10_58_37.png", width: 100%)],
)

#subsection("Random Numbers")
- random numbers are not reproducable -> hence bad
- instead use pseudo-random numbers with known seeds
#align(
  center,
  [#image("../../Screenshots/2023_11_16_10_59_53.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_16_11_00_04.png", width: 100%)],
)
