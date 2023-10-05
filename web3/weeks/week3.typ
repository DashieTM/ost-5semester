#import "../../utils.typ": *

#section("Component Lifecycle")
The problem is, how do we update objects with time? E.g. if I have a clock, how
do I update the time each second.// typstfmt::off
```js
// logic to st date
tick = () => {
  this.setState({
    date: new Date()
  })
}

// set timer on object creation
componentDidMount() {
  this.timerID = setInterval(
    this.tick,
    1000
  )
}

// delete timer on object destruction
componentWillUnmount() {
  clearInterval(this.timerID)
}
```
// typstfmt::on

#subsection("3 Phases")
Components have 3 phases in react: Mounting, Updating and Unmounting
#align(center, [#image("../../Screenshots/2023_10_05_01_49_11.png", width: 50%)])

#subsubsection("Mounting with classes")
- *constructor(props)*
  - initialize state
  - if no state is needed, omit constructor
- static getDerivedStateFromProps(props, state)
  - initialize state dependent props
- *render()*
- *componentDidMount()*
  - whatever you put here happens on mount of object
  - builds DOM
  - good time to load async data
  - *setState() will re-render!*

#subsubsection("Updating with classes")
- static getDerivedStateFromProps(props, state)
  - initialize state dependent props
- shouldComponentUpdate(nextProps, nextState)
  - render will be skipped if result is false
  - used to omit re-rendering for special props
- *render()*
- getSnapshotBeforeUpdate(prevProps, prevState)
- *componentDidUpdate(prevProps, prevState, snapshot)*
  - DOM is updated

#subsubsection("Unmounting with classes")
- *componentWillUnmount()*
  - garbage collection

#subsubsection("Error Handling")
- static getDerivedStateFromError(error)
  - put error into state
- componentDidCatch(error, info)
  - logging
  - avoid propagation -> catch errors

#subsection("useEffect(), Hook for mount and unmount")
//typstfmt::off
```js
function ClockHooked() {
  const [date, setDate] = useState(new Date())
  // mount and unmount
  useEffect(() => {
    // set on mount
    const timerID = setInterval(() => setDate(new Date()), 1000)
    // set on unmount
    return () => {
      clearInterval(timerID)
    }
  }, [])
  return (
    <div>
      <h2>It is {date.toLocaleTimeString()}.</h2>
    </div>
  )
}
```
//typstfmt::on

E.g. the useEffect() hook is used to handle mounting and unmounting without needing to specify multiple functions, rather, you can just use one function.\
#text(purple)[Dependencies]:\
These are the parameters that will be in the [], as the second parameter to useEffect, this will specify that the function will be rerun when the depencency changes.
E.g. the value of a counter has changed, therefore it will re-render.
//typstfmt::off
```js
useEffect(() => {
  console.log('Counter is now: ', counter);
}, [counter]);
```
//typstfmt::on

#subsection("useEffect with async API and Errorhandling")
//typstfmt::off
```js
const [remoteData, setRemoteData] = useState(null);
const [error, setError] = useState(null);
const [isLoading, setIsLoading] = useState(false);

useEffect(() => {
  setIsLoading(true); // show loading ui
  fetch('https://jsonplaceholder.typicode.com/todos/' + id)
    .then((response) => {
      if (!response.ok) {
        throw new Error('Oops’);
      }
      setIsLoading(false); // show proper ui again
      return response.json();
    }
  ).then((data) => setRemoteData(data))
   .catch((error) => setError(error.message));
}, [id]); // use new id for next todo
```
//typstfmt::on


#section("React Router")
#text(red)[*Router for react is just a library*, it is not a built-in feature!]
//typstfmt::off
```js
const {
  BrowserRouter,
  Routes,
  Route,
  Link
} = ReactRouterDOM;

const root = ReactDOM.createRoot(
  document.getElementById("root")
);

const Home = () => "Home"
const About = () => "About"
const Dashboard = () => "Dashboard"

function App() {
  return (
    <BrowserRouter>
      <div>
        <ul>
          <li><Link to="/">Home</Link></li>
          <li><Link to="/about">About</Link></li>
          <li><Link to="/dashboard">Dashboard</Link></li>
        </ul>
        <hr />
        <Routes>
          <Route index             element={<Home/>} />
          <Route path="/about"     element ={<About/>} />
          <Route path="/dashboard" element={<Dashboard/>} />
        </Routes>
      </div>
    </BrowserRouter>
  )
}

root.render(
  <App/>
);
```
//typstfmt::on
- \<BrowserRouter\>
  - all routes must be part of the router
  - typically near the root component
- \<Route path="/about" element={\<About/\>}\>
  - Component About will only be rendered when path matches
  - routes can be boxed into each other
- \<Link to="/about"\>About\</Link>
  - react native links, don't use \<a\> for react!
  - *links would not work with the react router!*

#section("Typescript with React")
- flow can also be used
  - just annotations for js, doesn't stop the app from running
  - no proper language
  - just use ts...
#subsection("Function Components")
//typstfmt::off
```js
type Props = {
  accountNr: AccountNr;
  balance: number;
  onSubmit: (to: AccountNr, amount: number) => void;
  isValidTargetAccount: (to: AccountNr) => Promise<boolean>;
};
function TransferFundsForm({
  accountNr,
  balance,
  onSubmit,
  isValidTargetAccount,
}: Props) { // .... }
```
//typstfmt::on

#subsection("Class Components")
//typstfmt::off
```js
type Props = {
  token: string;
  user?: User;
};
type State = {
  transactions?: Transaction[];
  state: State = {
    transactions: undefined,
    // other parts of state
  };
  class Transactions extends React.Component<Props, State> {
  // ...
  // do something with transactions
  }
};
```
//typstfmt::on






