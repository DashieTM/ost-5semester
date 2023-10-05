#import "../../utils.typ": *

#section("Data")
#subsection("Data-Mining")
This is *random collection of data*, which will later be processed.
- advertising
- predictive analysis
- statistical process needed

#subsection("Data-Farming")
This is *targeted collection of data*, which will later be processed.
- detection of weaknesses
- adherence to norms
- evaluation of median and variance values.

#subsection("Data matters")
- which data do we use?
  - is the data neutral, or is there a clear bias?
- do we collect targeted data or random data?
  - note that targeted data will always include our own biases!
- do we collect small samples or massive amounts of data?

#section("Terms")
*these terms will be in german since I will have to complete the exam in that ""great""
language, sorry.*
#subsection("Merkmalsträger")
This is the object with the attribute of interest.\
For example: We would like to measure failure rate for cars, hence a car is our
object of interest -> Merkmalsträger.

#subsection("Grundgesamtheit")
The amount of all objects of interest together
#subsubsection("Abgrenzungsmerkmal")
This determines the category of which each object of interest must be in, in
order to get considered for the amount of all objects of interest.\
These attributes have 3 different categories:\
- space/raum : all objects(ex. machines) within a room
- time/zeit : all measured data within a measurement interval
- object/sachlich : all objects(ex. machines) of a brand

#subsection("Merkmal / Attribute")
The attribute of interest during a statistical investigation. For example, the
failure rate of something is an attribute.

#subsection("Merkmalswerte / Attribute Value")
This is the value of the attribute, note that each attribute might have their
own unit -> percentage, hours, etc.

#section("Scala")
#subsection("Nominal Scala")
these are named attributes that have no specific value, e.g. they are all of the
same value, trying to calculate with these is stupid. Measurable Values:\
- #text(purple)[Difference(non scalar)/Verschiedenartigkeit]
#grid(
  rows: (auto, auto, auto),
  columns: (auto, auto),
  gutter: 8pt,
  [Attribute],
  [Attribute value],
  [gender],
  [attack helicopter, pony, penguin],
  [cat],
  [globi, grief],
)

#subsection("Ordinal Scala")
This is essentially the same with names, or rather categories as values, but,
this time the categories are ranked, e.g. *not equal*.\
*Note the ranking is from best to worst*\
Measurable Values:
- #text(purple)[Difference(non scalar)/Verschiedenartigkeit]
- #text(purple)[rank]
#grid(
  rows: (auto, auto, auto),
  columns: (auto, auto),
  gutter: 8pt,
  [Attribute],
  [Attribute value],
  [Operating Sytem],
  [Linux , BSD , Winshit],
  [Editor],
  [Neovim, helix, vscode],
)

#subsection(" Metric Scala / Kardinal/Cardinal Scala")
This is an overall term for the 2 sub scales.\
- real numbers
- ordered depending on the value of the attribute
- quantitative values
- depending on the starting point -> either interval or context scala
- is the representation of an experiment

#subsubsection("Interval Scala")
On this scale, the *0 point is chosen*, this means that you will have to check
how the value relates to other values on that scale. E.g. *you can't just assume
that double scalar value means double the real world
value!* For example, 20db is not double the value of 10db, sound is a
logarithmic value!\
Measurable Values:
- #text(purple)[Difference(non scalar)/Verschiedenartigkeit]
- #text(purple)[rank]
- #text(purple)[scalar differences -> distance]
#grid(
  rows: (auto, auto, auto),
  columns: (auto, auto),
  gutter: 8pt,
  [Attribute],
  [Attribute value],
  [Sound],
  [10db , 20db , 30db],
  [Temperature (Celsius!)],
  [-10C, 0C, 20C],
)
#text(
  teal,
)[The reason we can't assume double the scalar value means double the real world
  value is in the 0 point. As soon as you change the 0 point, you can no longer
  compare values with each other. A good example is weight, if you randomly place
  the 0 value at 20kg, you will influence your evaluation of the average weight.]
#subsubsection("Verhältniss Skala/Context Scala")
In this scale, *the 0 point is exactly 0*. For this scale, *double the scalar
value is double the real world value*, aka 20kg is double the weight of 10kg.\
Measurable Values:
- #text(purple)[Difference(non scalar)/Verschiedenartigkeit]
- #text(purple)[rank]
- #text(purple)[scalar differences -> distance]
- #text(
    purple,
  )[relatives > a person in group x is 2 times as heavy as one in group y]
#grid(
  rows: (auto, auto, auto),
  columns: (auto, auto),
  gutter: 8pt,
  [Attribute],
  [Attribute value],
  [Weight],
  [10kg , 20kg , 40kg],
  [Temperature (Kelvin!)],
  [0K, 10K, 200K],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_05_09_05_15.png", width: 80%)],
)

#section("Statistical Investigation")
#subsection("Planning")
- choose attributes
- choose techniques
- choose visualization for data
- choose analysis technique

#subsection("Collecting data")
- choose Abgrenzunsgmerkmale/attribute categories
- choose attributes to investigate
- choose data spectrum -> has an effect on tolerable error
- specify what the expected result should be, what are the objectives?

#subsubsection("Primary statistics")
This means collecting data for this specific usecase, this means that the data
is specifically collected for our attributes, increasing our potential accuracy.
#columns(2, [
  #text(green)[Benefits]
  - accuracy
  #colbreak()
  #text(red)[Downsides]
  - more work
  - more time needed
  - more expensive
])
#subsubsection("Secondary statistics")
This means using existing data, which is then converted for our experiment.
#columns(2, [
  #text(green)[Benefits]
  - less work
  - less time needed
  - cheaper
  #colbreak()
  #text(red)[Downsides]
  - accuracy
])

#subsubsection("Teil/VollErhebung")
This is just *sampling* or the full dataset.

#subsubsection("Urliste")
#align(center, [#image("../../Screenshots/2023_10_05_09_38_48.png", width: 80%)])

#subsubsection("Häufigkeitsverteilung / Frequencyspread")
- defines how many times $x_i$ appears)
- can either be *absolute* or *relative* values
- $h_i$ = *absolute* frequency (amount of measurements with value x)
- $f_i$ = *relative* frequency (all measurements with value x divided by all measurements)
- n = amount of all measurements
- v = amount of different attributes
#align(center, [#image("../../Screenshots/2023_10_05_09_43_29.png", width: 60%)])

#subsubsection("kumulierte Häufigkeitsverteilung / Accumulated Frequencyspread")
- $H_i$ = absolute accumulated frequency
- $F_i$ = relative accumulated frequency
- n = amount of all measurements
- v = amount of different attributes
#align(center, [#image("../../Screenshots/2023_10_05_09_44_41.png", width: 60%)])

#subsubsection("Last tipps")
If you have too many attributes, then the table is no longer clear, in this case you should group these attributes:
#align(center, [#image("../../Screenshots/2023_10_05_09_48_42.png", width: 60%)])



