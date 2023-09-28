#import "../template.typ": *

#show: doc => conf(author: "Fabio Lenherr", "Web Engineering 3", "summary", doc)

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

#align(center, [#image("../Screenshots/2023_09_21_02_47_52.png", width: 70%)])
Bundling: In order to not send unnecessary data to the client, and to obfuscate
code..., we bundle the entire page.
#align(center, [#image("../Screenshots/2023_09_21_02_52_14.png", width: 70%)])
#columns(
  2,
  [
    #align(center, [#image("../Screenshots/2023_09_21_02_56_45.png", width: 90%)])
    #colbreak()
    #align(center, [#image("../Screenshots/2023_09_21_02_57_24.png", width: 90%)])
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
#align(center, [#image("../Screenshots/2023_09_21_03_14_45.png", width: 70%)])
#columns(
  2,
  [
    #align(center, [#image("../Screenshots/2023_09_21_03_04_53.png", width: 90%)])
    #colbreak()
    #align(center, [#image("../Screenshots/2023_09_21_03_05_33.png", width: 90%)])
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
    #align(center, [#image("../Screenshots/2023_09_21_03_12_22.png", width: 90%)])
    #colbreak()
    #align(center, [#image("../Screenshots/2023_09_21_03_13_15.png", width: 90%)])
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
    #align(center, [#image("../Screenshots/2023_09_21_03_22_18.png", width: 90%)])
    #colbreak()
    #align(center, [#image("../Screenshots/2023_09_21_03_22_56.png", width: 90%)])
  ],
)
#align(center, [#image("../Screenshots/2023_09_21_03_23_17.png", width: 70%)])

#section("React")
- not a framework, it's a library
- made by meta...

#subsection("UI frameworks provide:")
- structure definition
- event handling
- view update

#subsection("Javascript and XML (JSX)")
#text(red)[*HTML in javascript*]
```tsx
function HenloBirb(props: any) {
  return (
    <div>
      Henlo {props.name}
    </div>
  )
}
function App() {
  return (
    <div>
      <HenloBirb name="Borb"/>
    </div>
  )
}
```
#subsubsection("Differentiation of JSX and regular JavaScript")
#text(
  teal,
)[JSX or TSX is just a preprocessor declaration that will be replaced with react
  library functions]
```tsx
import React from 'react'
function Container(props) {
  return <div
    className="container">
      {props.children}
    </div>
}
// will be turned into:
import React from 'react'
function Container(props) {
  return React.createElement("div",
    {className:"container"},
    props.children
  )
}
```
#align(center, [#image("../Screenshots/2023_09_28_02_38_07.png", width: 80%)])

#subsubsubsection("Limitations")
- class is a predefined identifier in Javascript, hence you need to use className
  instead for html tags. ```tsx
   function Container(props) {
   return (
   <div className="somehting">{}</div>
   )
   }
   ```
- react components are written with an uppercase letter in order to differentiate
  between HTML and react tags ```tsx
   // note the uppercase name
   function Whatever() {
   return (
   <div>lel</div>
   )
   }
   ```
- styles have to be defiend with an object in JS/TS *not* directly as css inside
  html:\
  CSS files are still preferred! This is just for inline ```tsx
   function Container(props) {
   const style = {
   display: 'flex’,
   width: '100%’,
   minHeight: 300,
   };
   return <div style={style}>{props.children}</div>;
   }
   ```
- conditional rendering: ```tsx
   // &&
   <Container>
   { error &&
   <Message>
   Error: {error}
   </Message>
   }
   </Container>
   // if else with ternary
   <Container>
   { error
   ? <span>
   Error: {error}
   </span>
   : <span>OK!</span>
   }
   </Container>
   ```
- parameter deconstruction: ```tsx
   const HelloMessage = (props) => <div>Hello {props.name}</div>;
   const HelloMessage = ({ name }) => <div>Hello {name}</div>;
   ```
- class components ```tsx
   class HelloMessage extends React.Component {
   render() {
   return <div>Hello {this.props.name}</div>
   }
   }
   ```
  - mostly unused, but will still work for a very long time
- #text(
    red,
  )[In order to show anything at all, you need to mount react components to root
    components:]
  ```tsx
      import React from 'react';
      import ReactDOM from 'react-dom/client';
      import App from './App';
      const root = ReactDOM.createRoot(document.getElementById('root'));
      root.render(<App />);
      ```
  - you can have multiple root components on a website

#subsubsubsection("Props")
- #text(purple)[Props are always read-only]
- #text(purple)[Props are always read-only]

#subsubsubsection("State")
This is used to manipulate the properties of the read-only props object. In
other words, we will re-render every time a state has changed! *We can do this
by using the _useState_ function* ```tsx
const [value, setValue] = useState(0);
// value is the variable to be used
// setValue is the setter
// useState(0) defines the initial value, which will be 0
// example:
import { useState } from 'react';
function Counter() {
 const [counter, setCounter] = useState(0);
 const increment = () => setCounter(counter + 1);
 return (
 <div>
 <p>{counter}</p>
 <button onClick={increment}>Increment Counter</button>
 </div>
 )
}
```
#text(
  red,
)[NOTE: *useState* may not be used within if statements! -> it manipulates the
  state itself, and therefore has to be the same no matter what.] However this
does not matter that much, as useState only creates a hook to be used when
needed, it has no functionality otherwise.

#subsection("Reconciliation")
- React component are rendered as virtual DOM
- each state change creates a new virtual DOM
- new and old DOM are compared
  - only then is the actual DOM in the browser created
  #align(center, [#image("../Screenshots/2023_09_28_04_34_13.png", width: 70%)])

#subsubsection("Explicit state for components")
This allows you to specify what the state should include during creation of the component.
```tsx
class Counter extends React.Component {
  constructor() {
    this.state = { count: 0 }
  }
  handleCounted = () => {
    this.setState(state => ({count: state.count + 1}))
  }
  render() {
    <div>
      <p>You clicked {this.state.count} times</p>
      <button onClick={this.handleCounted}>
        Click me
      </button>
    </div>
  }
}
```

#subsection("Fomular Example")
```tsx
function LoginForm() {
  const [password, setPassword] = useState("");
  const [username, setUsername] = useState("");
  return (
    <form>
      <div>
        <label>Username</label>
        <input value={username} type="text" onChange={e => setUsername(e.target.value)} />
      </div>
      <div>
        <label>Password</label>
        <input value={password} type="password" onChange={e => setPassword(e.target.value)}/>
      </div>
      <div>
        <button type="submit" onClick={handleSubmit}>Login</button>
      </div>
    </form>
  )
}
```
#text(red)[Components that are handled onChange are called *Controlled Components*.] 
Note the e.target.value that takes the event and puts the value into the state on each input the user makes.

#subsection("Widget Libraries")
- Semantic UI React
- Reactstrap (Bootstrap for React)
- Material-UI
- Atlaskit
