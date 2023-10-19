#import "../../utils.typ": *

#section("Time Row/Zeitreihe")
This is a timeline with ordered attributes that appeared within this timeframe.
- cost/profit
- usage of resources
- orders
- shipments

#text(
  teal,
)[Mostly used to *recognize structures* within the timeline, *trends*, or to make
  *prognosis*, however this is risky.]

#subsection("Trend")
- over a long period
- in the past only
- often used to "look" into the future -> risky
- trends can be
  - linear
  - exponential
  - polynomial
  - logarithmic
  - non-linear trends are often harder to interpret

#subsection("Floating Average")
We often have certain values or events that will make it hard to pick a proper
average, aka extreme values. While some means do offer protection against this
out of the box, we still want a general way to reduce these extreme values in
order to use the other variants as well.

#align(
  center,
  [#image("../../Screenshots/2023_10_19_03_07_44.png", width: 70%)],
)
The trend for the example above is a slight decrease in value.

#set text(14pt)
Past: $X_T [T = 1 ,..., t-1]$
Current: $X_t [T = t]$
Mean: $M_t = 1/(T+t)(sum_(T=1)^(t-1)X_T + X_t) $
#set text(11pt)

#section("Regression")
#subsection("Linear Regression")
#align(
  center,
  [#image("../../Screenshots/2023_10_19_03_18_50.png", width: 70%)],
)

Idea:\
The basic idea of linear regression is to check for correlation between two sets
of data, for example, what is the correlation of mouse size to mouse weight?
\newline Linear regression tries to do this with a simple straight line! It is
therefore the easiest way to get a correlation, but it is also not very
accurate.\newline To rectify the bad accuracy, we do this multiple times for a
small sets of data, aka for slices of the data.

Formula and Mean Squared Error:\
#set text(14pt)
$ accent(y, \^)_i = m * x_i + d $
$e_i = y_i - accent(y, \^)_i $
$E = 1/2N sum_(i=1)^(N)e_(i)^2$
$text("MSE") = 1/2N sum_(i=1)^(N)(y_i - (m * x_i +b))^2$
#set text(11pt)
Legend:\
- m = slope
- (x_i) = x of datapoint
- (y_i) = y of datapoint
- ( delta y_i ) = y of line -> mean(y)
- d = y offset / intercept
- (e_i) = single residual -> value of a datapoint
- E = sum of residuals
- N = amount of datapoints

The ( y_i ) inside the MSE is the actual data that we have from our dataset.\
While the (m \* x_i + b) is the formula that we used. -> linear or polynomial
regression.\
We are essentially comparing the 2 y's, the one from the data and the one from
the calculation.\
We then square the difference and do this for every point in the dataset.\
Our final calculation will be the Mean Squared Error [0.33,0.4] You need to
first decide what the line is for yourself, this means manual fitting!\
Then you can see the Residual Error which would be E in the formula!\
The ultimate goal is to MINIMIZE E -> MINIMIZE ERROR!\
To do this, we calculate the mean squared error by checking the difference
between the data we calculated and our training data.\
aka the sum of (training y - calculation y) squared.

#subsubsection("Least Squares")
This term simply explains the improvement of fitting a function by calculating
them via derivates of slopes:\
As you can see you take the derivate of MSE and slope with respect to slope and
try to find a 0 value -> a local minimum or maximum.\
And considering we didn't use a fucked up line in the first place, we can be
sure that it is indeed a local minimum!\
derivate in relation to slope = $1/2N sum_i=1^N d/text("dm")(y_i - (m * x_i +b))^2 $\
derivate in relation to slope = $1/2N sum_i=1^N (2b (b x - y)) $\
derivate in relation to intercept = $1/2N sum_i=1^N d/text("db")(y_i - (m * x_i +b))^2 $\
derivate in relation to intercept = $1/2N sum_i=1^N 2(x-y+b) $\

#text(red)[ Now we need to make sure that the derivate is 0! \
  ( textMSE' = 0 ) ]\
If this is given, then we have our slope or intercept that will fit best with
our current data!

#subsubsection("Examples")
#align(
  center,
  [#image("../../Screenshots/2023_10_19_03_21_32.png", width: 70%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_19_03_22_08.png", width: 70%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_19_03_23_33.png", width: 70%)],
)

#subsection("Exponential Regression")
When we want to use regression on this, we first need to flatten the curve, use
regression and then bring it back to original form again.

#align(
  center,
  [#image("../../Screenshots/2023_10_19_07_51_47.png", width: 70%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_19_07_52_05.png", width: 70%)],
)

#subsection("Exponential Regression")
Polynomial functions are simply functions with an x amount of degrees. A second
degree polynomial is like this:\
$y = f(x) = a * x^2 + b * x + c)$\
When calculating the mean squared error, we would need all 3 different
parameters: a,b and c, this would mean we need 3 different functions, which we
don't have. So we use derivations instead -> try to get the derivative of each
parameter to 0:
$d/(d a) text("of mse") = 2 * sum^k_(i=1) (y_i - a * x_i^2 - b * x_i - c) * (- x_i^2)$
$d/(d a) text("of mse") = accent(y_i * x_i^2, -) = a * accent(x_i^4, -) + b * accent(x_i^3, -) + c * accent(x_i^2, -)$
$d/(d a) text("of mse") = accent(y_i * x_i, -) = a * accent(x_i^3, -) + b * accent(x_i^2, -) + c * accent(x_i, -)$
$d/(d a) text("of mse") = accent(y_i, -) = a * accent(x_i^2, -) + b * accent(x_i, -) + c $

#subsubsection("Python example")
#align(
  center,
  [#image("../../Screenshots/2023_10_19_08_03_13.png", width: 90%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_19_08_03_41.png", width: 90%)],
)

#subsection("Logistic Regression")
See AI-foundations
#align(
  center,
  [#image("../../Screenshots/2023_10_19_08_05_35.png", width: 70%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_19_08_05_56.png", width: 70%)],
)

#section("Correlation")
Correlation and Causation\
Just because something has a mathematical correlation, does not mean that it
also has a causality. Some things might be correlated for random reasons, or
even simple chance.\
For example you might find that the increase in cats is correlated with stormy
weather, the data reflects that, but if you know how the weather works, you know
that this is utter bs and will never be true.

Parson Correlation Coefficient\
- The correlation is 1 if m is positive, and E is 0.
- The correlation then gradually gets less if there is a deviation between x and
  y.
- If m is negative and E is 0, then we have -1 correlation. This is still
  correlation, just negative!
- Should either x or y be constant then calculating the correlation is not
  possible.
- Lastly, nonsense / nonfunction data, we have correlation 0.

- *Numeric Correlation*
  - a calculation
- *causal correlation*
  - window is causality for shit software

#subsection("Correlation Coefficient")
#set text(14pt)
Variant 1:\
$sigma_(X * Y) = 1/n sum_(i=1)^n (x_i - accent(x, -)) (y_i - accent(y, -))$
Variant 2:\
$sigma_(X * Y) = 1/n sum_(i=1)^n x_i * y_i - accent(x, -) * accent(y, -)$
#set text(11pt)
Legend:\
$x_i$: data point of x
$y_i$: data point of y
$accent(x, -)$: average of all x data points
$accent(y, -)$: average of all y data points

#set text(14pt)
Coefficient r:\
$r = (sigma_(X * Y))/(sigma_X * sigma_Y)$ where $sigma_(X * Y) < sigma_X * sigma_Y$
$r = (sum_(i=1)^(n) (x_i - accent(x, -) (y_i - accent(y, -))))/(sqrt((sum * (x_i - accent(x, -)))*(sum * (y_i - accent(y, -))))) $
#set text(11pt)
- #text(
    teal,
  )[A positive r equals a positive correlation -> if x goes up, so does y]
- #text(
    teal,
  )[A negative r equals a negative correlation -> if x goes down, y goes up]
- #text(teal)[An r value of 0 means there is no correlation.]
