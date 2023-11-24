#import "../../utils.typ": *

#section("Random Variables")
A random variable in math is just a function that maps each result a number in
the result quantity.\
In fucktarded math notation:\
#set text(16pt)
#align(center, [
  $X := {text("Event1, Event2")} in RR $\
  \
  $X(omega) := vec(
    (1, text("if") omega text(" = Event1")),
    (-1, text("if") omega text(" = Event2")),
    delim: "{",

  )$
  #align(
    center,
    [#image("../../Screenshots/2023_11_09_03_40_02.png", width: 80%)],
  )
  - $Omega$: result quanitity
  - A: event quantity
  - P: Probability -> of an event
])
#set text(11pt)
Roulette Example:
#align(
  center,
  [#image("../../Screenshots/2023_11_09_03_12_36.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_09_03_13_14.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_09_03_14_08.png", width: 80%)],
)

#subsection("Random Variables and Probability")
Usually random variables are represented as one possible value within an
interval, so it makes sense to calculate the interval instead of just one
variable:\
Essentially, we have two quantities, the quantity A which is the event quantity
and the quanitity $Omega$ which is the result quantity.\
Aka the event is the mapping of random result to real world event -> if i get
result 12 I win -> event +1, other numbers give -1.\
#set text(16pt)
#align(center, [
  $A = {omega in Omega | X(omega) in II} in AA$
  #align(
    center,
    [#image("../../Screenshots/2023_11_09_03_44_11.png", width: 80%)],
  )
])
I is the wanted subquantity of $Omega$ aka the resultquantity.
#set text(11pt)
#text(
  teal,
)[Note: Even single values are subquantities -> just quantities with 1 element...]

Example:
#align(
  center,
  [#image("../../Screenshots/2023_11_09_03_44_59.png", width: 100%)],
)

#subsection("Probability with discrete and continuous ranges")
#align(
  center,
  [#image("../../Screenshots/2023_11_09_03_49_03.png", width: 100%)],
)
#text(
  teal,
)[As one can see, on the left we have the summation of each probability, while on
  the right we can take a derivation of the function since it is continuous.]

Example:
#align(
  center,
  [#image("../../Screenshots/2023_11_09_03_50_44.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_09_03_51_03.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_09_03_51_21.png", width: 100%)],
)

#subsection("Bernoulli Process")
- a repeated process of a random experiment
- binary process -> does event happen or not, 1 or 0
- probability for success -> p
- probability for failure -> q -> $1-p$
- no memory -> previous results are ignored
#set text(16pt)
$E(x) = overline(x) = sum_(i=1)^2 x_i * p_i$
$E(x) = 1 * p + 0 * (1-p) = p$
$text("Var")(x) = sigma^2 = sum_(𝑖=1)^2 x_i^2 p_i − p^2$
$sigma^2 = 1^2 * p + 0 * (1-p) - p^2 = p $
$sigma^2 = p - p^2 = p * (1 - p) = p * q$
- $sigma^2$: Variance
- $E(x)$: amount of appearances of expected result
#set text(11pt)

#subsection("Binomial Distribution")
- usage
  - only 2 events -> binary
  - experiment will be repeated n times -> scope n
- result: probability with n repeats that:
  - result appears once
  - result appears x times
  - result appears at least x times
  - result does not appear
  - etc.
#align(
  center,
  [#image("../../Screenshots/2023_11_09_04_04_54.png", width: 50%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_09_04_05_20.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_09_04_05_38.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_09_04_06_00.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_09_04_06_22.png", width: 80%)],
)
\
#set text(16pt)
$f(x) = P(X = x) = (vec(n, x, delim: "(")p^x(1-p)^(n-x))$\
$E(X) = n*p$\
$text("Var")(X) = n * p(1-p)$\
- n: amount of repeats
- x: amount of wanted result appearing
- p: probability of wanted result
- $E(x)$: amount of appearances of expected result
#set text(11pt)

#subsection("Poisson Distribution")
Within a time frame the result appears on average $mu$ times.\
You can now compare this with it appearing x amount of times.\
#set text(16pt)
$f(x) = P(X = x) = (mu^x)/(x!)e^(-mu)$\
$E(X) = text("Var")(X)=mu$\
#set text(11pt)

#align(
  center,
  [#image("../../Screenshots/2023_11_09_04_25_55.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_09_04_26_08.png", width: 100%)],
)

#subsection("Possion and Binomial")
With *np 10 or below and n 1500 or above* for the binomial distribution, you can
set the poission and binomial distribution to be equal:
#align(
  center,
  [#image("../../Screenshots/2023_11_09_04_32_14.png", width: 100%)],
)

#subsection("All combined")
#align(
  center,
  [#image("../../Screenshots/2023_11_09_04_26_31.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_09_04_26_52.png", width: 100%)],
)
