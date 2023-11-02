#import "../../utils.typ": *

#align(
  center,
  [#image("../../Screenshots/2023_11_02_11_42_54.png", width: 70%)],
)

#section("Laplace Experiments")
Simple probability:
#set text(14pt)
$P(A) = |A|/|Omega|$
A: Probability of a certain outcome -> dice 6
$Omega$: All possibilities -> 6 different possibilities Aka the probability of
recieving a 6 is 1/6, this never changes for this experiment.
#set text(11pt)

#subsection("Ordered Probability")
This means that the order in which the result appears matters -> for example a
game with dices might take the first dice as a 10digit dice.

#subsubsection("With memory")
The best result here is throwing a single dice, the same number may appear again
and again.
#set text(14pt)
$K = n^k$
- K = amount of different possibilities
- k = amount of dice rolls
- n = amount of sides of a dice -> 6 -> $6^k$
#text(
  red,
)[Note, k and n are sometimes the same -> seat order for 10 people with free seat
  choice -> 10 seats:\
  In this case you can simply use: *$K = 10!$*]
#set text(11pt)

#subsubsection("Without Memory")
The best example for this is a lock, you can only have a specific combination
once, for a lock with 2 numbers -> 1-1 is a specific combination, next: 1-2,
1-3, etc.
#set text(14pt)
$K = n!/(n-k)!$
$K = product_n^(n-k+1)n$
- K = amount of different possibilities
- k = amount of section in the lock
- n = amount of numbers in the lock -> 0-9 lock with 5 sections -> $10!/(10*5)!$
#set text(11pt)

#subsection("Un-ordered Probability")
#subsubsection("With Memory")
tournaments -> each team competes against another once, order doesn't matter ->
unlike a lock\
#set text(14pt)
$K = (product_n^(n-k+1)n)\(k!)$
$K = (n!)/(k! * (n-k)!)$ -> *Problem! the triple factorial is compute heavy! not
a practical formula*
- K = amount of different team combinations
- k = amount of teams within one combination -> 2 here
- n = amount of teams
- example calculation with 25 teams: $K = (25!)/(2! * (25-2)!) = 300$
#set text(11pt)

#subsubsection("Without Memory")
Same idea as above but the same combination can appear again -> randomly
choosing places.\
Example: 6 groups compete for 3 seats within a parliament(or something), one
group can win multiple seats(this is the difference to above!).\
#set text(14pt)
$K = (n + k - 1)/(k)$
- K = amount of different team combinations
- k = amount of items within one combination -> 2 here, 1 seat 1 group
- n = amount of items -> 6 here
- example $K = (6 + 3 - 1)/(3) = 56$ -> 56 different combinations possible
#set text(11pt)
