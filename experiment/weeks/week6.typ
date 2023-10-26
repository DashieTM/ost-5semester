#import "../../utils.typ": *

#section("Random Experiment")
An experiment that can be re-done as many times as one wants, it will *always be
random*.\
All possible endstates of the experiment is the result quantity $Omega$.
#align(
  center,
  [#image("../../Screenshots/2023_10_26_09_14_09.png", width: 70%)],
)
- partial quantity: parts of the result quantity -> for example a best case
  scenario -> *events/ereignisse*
- result quantity: the quantity that encompasses all possible results

#subsection("Events and Notation")
Events, aka results are often notated with the mathematical quantity notation: $A sect B$.\
In this case it's considered that *event x happens when result x appears* ->
event A or B happens when result $A union B$ appears.\
Or in other words, events are the partial quanity in the result quantity.
- $A sect B$: A and B
- $A union B$: A or B
- $A complement$: everything that is not A
#align(
  center,
  [#image("../../Screenshots/2023_10_26_09_24_17.png", width: 60%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_26_09_24_34.png", width: 30%)],
)

#subsubsection("Special Events")
- the empty quantity $nothing$ is the impossible event
- the result quantity $Omega$ is the 100% event -> always happens since every
  event is within $Omega$
- elementary events(Elementarereignisse) are events within a subquantity of the
  result quantity
- two events are not compatible when: $A union B == nothing$

#section("Probability P")
#subsection("Dependent Probability")
This means that you expect something to be true and then you calculcate the
probability.\
In this case B has to have happened and then you calculate A -> probability A
given B.
#set text(15pt)
$P(A|B) = (P(A union B)/(P(B)))$\
$P(A union B) = P(B) * P(A|B)$\
#align(
  center,
  [#image("../../Screenshots/2023_10_26_09_37_30.png", width: 60%)],
)

#set text(11pt)
Note the P(B) in the equation, if it is 0 aka B didn't happen -> not a valid
equation!
#align(
  center,
  [#image("../../Screenshots/2023_10_26_09_31_25.png", width: 70%)],
)
#subsubsection("Example")
#align(
  center,
  [#image("../../Screenshots/2023_10_26_09_38_51.png", width: 70%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_26_10_01_22.png", width: 70%)],
)

#subsubsection("Rule of Bayes")
$P(A union B) = P(B) * P(A|B)$\
$P(B union A) = P(A) * P(B|A)$\
$P(A union B) = P(B union A)$\
$P(A) * P(B|A) = P(B) * P(A|B)$\
Essentially this has to be the case as unions of A and B are always the same, no
matter what order the letters are.

#subsection("Independent Probability")
This is the same as above, but without a preceding event/result.
#set text(15pt)
$P(A|B) = P(A)$
#text(
  teal,
)[Aka, the B doesn't matter as it doesn't depend on it. B can be whatever, the
  result of probability A is the same!]
#align(
  center,
  [#image("../../Screenshots/2023_10_26_09_46_04.png", width: 40%)],
)
Probabilities are independent if:
$P(A union B) = P(A) * P(B)$
Which also means that $A$ and $B complement$, $A complement$ and $B$, $A complement$ and $B complement$ are
also independent from another.
#set text(11pt)

#subsection("Complete Probability")
#set text(15pt)
$P(A) = sum_(i=1)^n P(A|B_i) * P(B_i)$
#set text(11pt)
#align(
  center,
  [#image("../../Screenshots/2023_10_26_09_53_54.png", width: 30%)],
)

#align(
  center,
  [#image("../../Screenshots/2023_10_26_09_50_11.png", width: 80%)],
)
