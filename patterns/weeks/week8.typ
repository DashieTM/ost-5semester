#import "../../utils.typ": *

#section("Meta Patterns 2")
#subsection([Anything (Fancy Property List)])
#set text(size: 14pt)

Problem | We need to represent *any* data that can include sequences of data and
should be stored recursively and should be easily extendable.\
Solution | Create a datastructure that can be casted to or casted from(usually
implemented as trait -> toAny, fromAny), see dbus-rs with dyn RefArg. Simple
types usually have a direct representation like integers booleans etc. While
structs and maps have to be broken down and then rebuilt -> cast.\
#set text(size: 11pt)
// images
#align(
  center,
  [#image("../../Screenshots/2023_11_10_09_33_45.png", width: 100%)],
)
Example with JSON:
#align(
  center,
  [#image("../../Screenshots/2023_11_10_09_38_47.png", width: 70%)],
)

existing implemenation:
- any type in typescript

#columns(
  2,
  [
    #text(green)[Benefits]
    - readable streaming format and appropriate for configuration data
    - universally applicable, flexible interchange across class/object boundaries
    #colbreak()
    #text(red)[Liabilities]
    - less type safety than regular structs
    - intent of parameter elements not always obvious
    - overhead for value lookup and access / or cast
    - no real object, everything is just data without interpretation
  ],
)

#section("Frameworkers Dilemma")
#subsection("Framework Lock-in")
How do you as a developer guarantee the following points despite usinga
framework that will pre-define certain things:
- portability: framework dependent... -> how to create an application that can use
  multiple frameworks?
  - frameworks usually use inheritance -> strongest coupling out there -> very hard
    to create portable application
- testability: framework dependent... -> how to test only your code and not the
  framework code?
- longevity: framework dependent... -> what happens when framework is abandoned
Quite frankly, you don't, because of coupling with the framework, you are bound
with these properties, e.g. you can't port your application to platform x when
your framework doesn't support that platform, hence you would need a new
framework, but you are already *locked-in* as you have spent x amount of time
using it and getting to know it.\
In other words, MAUI -> wanna make a linux app, well too bad... Or GTK -> wanna
make a windows app, well ... it "works" but not that well\
#text(
  red,
)[Check out your functional and non-functional requirements and evaluate your
  Framework (and its vendor) with care, before you get locked-in.]

#subsection("Framework Evaluation Delta")
This defines a value that makes the difference(advantage/disadvantage) between
frameworks clear via benchmarks -> aka how does framework a differ from
framework b:
- Key idea behind the technology evaluation framework is:
  - Presumes «well-defined goals before starting the evaluation»
  - Defines a three-phase model
+ understanding how the evaluated technology differs from other technologies
+ understanding how these differences address the needs of specific usage
  contexts.
#align(
  center,
  [#image("../../Screenshots/2023_11_10_09_53_28.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_10_09_53_46.png", width: 100%)],
)

#subsection("Developing Frameworks")
Frameworks essentially should always recieve updates as developers might
otherwise look for alternatives -> see the meme, if the library doesn't get an
update every 14 minutes the library is considered abandoned. Change the 14
minutes to hald a year, and suddenly people see this as true, and hence they
will try something else. Other reasons to change frameworks:
- performance
- new architecture
- simplicity
- development progress
- stability

#subsection("Frameworkers Dilemma")
#text(
  teal,
)[There is a problem with creating a framework and trying to update it constantly:\
  Once you have an application that uses the framework, this application is
  interested in having a stable framework that doesn't make drastic changes to
  it's base. E.g. The application would like you to not create breaking changes,
  while developers that might want to use your framework later would like to see
  major (often breaking) features before using it.]

#subsubsection("Avoiding the dilemma")
+ Think very hard up-front
  - invest now, reap rewards later
  - requires experience
  - hard to decide without concrete applications and needs -> see xorg problem
  - can lead to expensive or over-engineered frameworks
  - might take too long to hit the market -> create react clone in 2023 ... wowie
    you just played yourself
+ don't care too much about framework users
  - Lay the burden of porting applications to the application's developer
  - Provide many good and useful new features to make porting a "must"
  - Might require porting tools, training/guidelines and conventions
  - fight hard to keep backwards compatibility -> keeps existing users
+ let users participate
  - Social process can help, e.g. by giving users time to migrate -> deprecation
  - Tendency for infinite backward compatibility
  - open source
+ use helping technology
  - Configurability
    - less direct code-dependencies
  - Simple and flexible interfaces
    - tendency to be more stable
- Patterns
  - Encapsulate Context, Extension Interface
  - already known: Reflection, Property List, Anything

#subsubsubsection("Configuration")
- Use configuration to reduce code-dependencies
  - Let the framework do as much as possible without writing code
  - Apply Reflection to identify interfaces, classes (extension points) and methods
    (hooks)
- Rely on annotations (attributes) which configures application wiring
  - and can be extended later-on without breaking user’s code
  - e.g. Angular Dependency Injection (\@Injectable / InjectionToken)
  - or just use traits like a normal person?
- Reflection allows using Conventions over Configuration paradigm
  - Completely eliminates the need of directly coupling the framework API
  - but introduces black magic

#subsubsubsection("Flexibility")
- composition over inheritance
  - frameworks using composition allow users to create whatever they want and to
    more easily break coupling where they don't need it.
- trait usage
  - traits can be implemented on user defined structs and can be used more
    generically -> exactly what we want
- Encapsulate the parameters/properties into another object
