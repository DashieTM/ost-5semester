#import "../../utils.typ": *

#section("Single Page Application (SPA)")
Definition: *SPA is a website that fits on a single web page with the goal of
providing a
user experience similar to that of a desktop application.*\
In an SPA, either _all necessary code_ is retrieved with a _single page load_ or
the appropriate resources are _dynamically laoded_ and added to the page as
necessary.\
In short, no flickering or crazy reloads.

- used to offer native like experience via PWA or electron
  - can use notifications unlike webpages
  - can also use server side rendering -> for lower power clients
  - PWA and co. are what java wanted to be.
- Partitioning of client and server allows for *seperation of concerns* and
  *better maintainability*

#align(center, [#image("../../Screenshots/2023_09_21_02_47_52.png", width: 70%)])
Bundling: In order to not send unnecessary data to the client, and to obfuscate
code..., we bundle the entire page.
#align(center, [#image("../../Screenshots/2023_09_21_02_52_14.png", width: 70%)])
#columns(
  2,
  [
    #align(center, [#image("../../Screenshots/2023_09_21_02_56_45.png", width: 90%)])
    #colbreak()
    #align(center, [#image("../../Screenshots/2023_09_21_02_57_24.png", width: 90%)])
  ],
)

#subsection("Browser based application")
- can be provided as SaaS
- not efficient
  - restricted hardware access
  - ram usage
- no data sovereignity
- crossplatform (mostly)

#subsection("Webpack")
- page must be delivered even over slow metered connections
  - bundling reduces footprint
  - larger SPAs need a reliable package managing system
  - initial footprint can be reduced with lazy loading of data
- one of many solutions: others -> broccoli, bazel, rollup, and newest: vite

Example of webpack usage:
#align(center, [#image("../../Screenshots/2023_09_21_03_14_45.png", width: 70%)])
#columns(
  2,
  [
    #align(center, [#image("../../Screenshots/2023_09_21_03_04_53.png", width: 90%)])
    #colbreak()
    #align(center, [#image("../../Screenshots/2023_09_21_03_05_33.png", width: 90%)])
  ],
)

#subsection("Routing in SPA")
- routing is done solely on client
  - challange: how do we store URLs when we don't actually call anything?\
    - old way: hash page with window.location.hash()
    - HTML5: window.history.pushState()\
      both of these forces the browser to remember the state of the SPA in order to
      restore last page

Example routing:
#columns(
  2,
  [
    #align(center, [#image("../../Screenshots/2023_09_21_03_12_22.png", width: 90%)])
    #colbreak()
    #align(center, [#image("../../Screenshots/2023_09_21_03_13_15.png", width: 90%)])
  ],
)

#subsection("Dependency Injection")
The idea is that instead of calling functions directly, we pass in code, that
will later be called.\
Mostly this is done with other languages -> from JS we call html, from whatever
we call SQL, etc\
However, this can also be used in SPA by using frameworks that offer integrated
dependency injection.
#columns(
  2,
  [
    #align(center, [#image("../../Screenshots/2023_09_21_03_22_18.png", width: 90%)])
    #colbreak()
    #align(center, [#image("../../Screenshots/2023_09_21_03_22_56.png", width: 90%)])
  ],
)
#align(center, [#image("../../Screenshots/2023_09_21_03_23_17.png", width: 70%)])

