#import "../../utils.typ": *

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
#align(center, [#image("../../Screenshots/2023_09_28_02_38_07.png", width: 80%)])

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
  #align(center, [#image("../../Screenshots/2023_09_28_04_34_13.png", width: 70%)])

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
