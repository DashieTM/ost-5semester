#import "../../utils.typ": *

#section("React Context")
By default, react uses the same context over everything. This means that
everything will be stored in one, which is not very scalable. Instead, we can
use react contexts, which solve this issue by providing a way to selectively
store and use "contexts" aka storages.//typstfmt::off
```js
// object to store
const themes = {
  light: {
    foreground: "#000000",
    background: "#eeeeee",
  },
  dark: {
    foreground: "#ffffff",
    background: "#222222",
  },
};
// create context
const ThemeContext = React.createContext(themes.light);
function App() {
  return (
    <ThemeContext.Provider value={themes.dark}>
    <Toolbar />
    </ThemeContext.Provider>
  );
}
function ThemedButton() {
  // use context in another component
  const theme = useContext(ThemeContext);
  return (
    <button style={{
        background: theme.background,
        color: theme.foreground }}>
      {" "}I am styled by theme context!{" "}
    </button>
  );
}
```
//typstfmt::on
Problems with this design, the contexts are still global, meaning you now have multiple global contexts which everyone can change. This leads to rather unmaintainable code.

#section("Redux: Predictable State Container")
- makes server side rendering possible -> only a possibility
- not a dependency of react -> can be used without
- tree based -> each state is a node of the tree
- changes cause a new tree to be created -> like haskell lists -> immutability, no
  side effects, but slower performance
Example:\
#align(
  center,
  [#image("../../Screenshots/2023_10_12_01_40_21.png", width: 70%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_12_02_34_24.png", width: 70%)],
)

//typstfmt::off
```js
function balance(state = 0, action) {
  switch (action.type) {
    case 'TRANSFER’:
      return (
        state + action.amount
      )
    default:
      return state
  }
}
```
//typstfmt::on
#subsection("Reducer")
Reducer always has a slice of states, this means that you can run the reducer on multiple states at once.\
- multiple reducers allowed
- reducer always works on a slice of states, can be the entire tree -> root
  Reducer, 1 state, or multiple
- root reducer needed in order to create the entire tree  //typstfmt::off
  ```js
    // create an empty object at the start
    function rootReducer(state = {}, action) {
      return {
        balance: balance(state.balance, action),
        transactions: transactions(state.transactions, action)
      }
    }
  ```
  //typstfmt::on
  Can also be done like this:
  //typstfmt::off
  ```js
    const rootReducer = combineReducers({
      balance,
      transactions
    })
  ```
  //typstfmt::on

#subsection("Store")
- rerenders components
- invoked by actions
- handles reducers
//typstfmt::off
```js
// create store with root reducer
const store = createStore(rootReducer);

// listen to changes on state
store.subscribe(() => console.log(store.getState()));
```
//typstfmt::on
#text(teal)[Note, this causes react to rerender the page on each state update.]
#align(center, [#image("../../Screenshots/2023_10_12_03_18_06.png", width: 50%)])

#subsection("Redux Example")
//typstfmt::off
```js
import { createStore } from 'redux'

/**
 * This is a reducer - a function that takes a current state value and an
 * action object describing "what happened", and returns a new state value.
 * A reducer's function signature is: (state, action) => newState
 *
 * The Redux state should contain only plain JS objects, arrays, and primitives.
 * The root state value is usually an object. It's important that you should
 * not mutate the state object, but return a new object if the state changes.
 *
 * You can use any conditional logic you want in a reducer. In this example,
 * we use a switch statement, but it's not required.
 */
function counterReducer(state = { value: 0 }, action) {
  switch (action.type) {
    case 'counter/incremented':
      return { value: state.value + 1 }
    case 'counter/decremented':
      return { value: state.value - 1 }
    default:
      return state
  }
}

// Create a Redux store holding the state of your app.
// Its API is { subscribe, dispatch, getState }.
let store = createStore(counterReducer)

// You can use subscribe() to update the UI in response to state changes.
// Normally you'd use a view binding library (e.g. React Redux) rather than subscribe() directly.
// There may be additional use cases where it's helpful to subscribe as well.

store.subscribe(() => console.log(store.getState()))

// The only way to mutate the internal state is to dispatch an action.
// The actions can be serialized, logged or stored and later replayed.
store.dispatch({ type: 'counter/incremented' })
// {value: 1}
store.dispatch({ type: 'counter/incremented' })
// {value: 2}
store.dispatch({ type: 'counter/decremented' })
// {value: 1}
```
//typstfmt::on

#subsection("React-Redux")
- library to combine react and redux
  - mapping of react props to redux states
- dispatch actions to redux store from react
- components need to rerender on change
  - therefore have multiple stores etc, so that only select components rerender

#subsubsection("(Deprecated!) Get data from react to redux (Deprecated!)")
//typstfmt::off
```js
// only template
// mapStateToProps: (state) => props
const ConnectedDashboard = connect(mapStateToProps)(Dashboard)
// call mapstate, which is just a function -> maps dashboard components state to connectDashboard -> which are props
```
//typstfmt::on

#subsubsection("Redux-Toolkit")
- standard for redux-react
- easy integration of redux into react
- usage
  - create reducers and actions via *createSlice*
  - initialize stores via *configureStore*
  - embed stores into react root-components via *Provider*
  - Dispatch of actions via *useDispatch*
  - Access to state of objects via *useSelector*
  - AsyncThunk
  - npx command to create a new redux-toolkit template:
    //typstfmt::off
    ```sh
    npx create-react-app hello-ost --template redux
    ```
    //typstfmt::on

#subsubsubsection("createSlice")
#text(teal)[creates state objects, reduce-functions and actions in one step.]
//typstfmt::off
```js
const balanceSlice = createSlice({
  name: "balance", // action name
  initialState: { value: 0 },
  reducers: {
    transfer: (state, action) => { // name is transfer -> action/transfer
      state.value += action.payload.amount; // payload.amount needs to be set when creating an action
    },
  },
});

export const {transfer} = balanceSlice.actions;
```
//typstfmt::on
#set text(teal)
- transfer reducer can now be used in components
- "balance/transfer" is the actiontype
- state is immutable -> we do not update the actual state, that will still be done according to redux -> create new tree
#set text(black)

#subsubsubsection("configureStore")
Initializes the redux store with reducers.\
Default initialization contains:\
- redux-thunk for async actions
- redux dev tools
//typstfmt::off
```js
import { configureStore } from "@reduxjs/toolkit";
import { balanceReducer } from "./redux/balanceSlice";

const store = configureStore({
  reducer: { balance: balanceReducer}
});

export default store;
```
//typstfmt::on
different file:
//typstfmt::off
```js
import store from "./store";

// makes the store usable in this component and it's children
render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
)
```
//typstfmt::on

#subsubsection("useDispatch")
Used to dispatch actions to the store. Store then runs reducer functions on the state.
```js
import { useDispatch } from "react-redux";

const dispatch = useDispatch()
// ...
// create a new action and push it to the store
// note according to the action defined in createSlice, the action needs the amount value
dispatch(transfer({ amount: 10 }))
```

#subsubsubsection("useSelector")
Used to get values of the state.
//typstfmt::off
```js
import { useSelector } from "react-redux";

// get the value variable from the state with name balance
// note that the name is a string -> not a variable in createSlice
const balance = useSelector(state => state.balance.value);
```
//typstfmt::on

#subsubsubsection("Async actions")
- made possible with Redux-Thunk, which is a middleware
- configured automatically with configureStore
#align(center, [Create slice])
//typstfmt::off
```js
const balanceSlice = createSlice({
  name: "balance", // action name
  initialState: { value: 0, status: "idle" },
  extraReducers: (builder) => {
    builder
      .addCase(transferAsync.pending, (state) => {
        state.status = "loading";
      })
      .addCase(transferAsync.fulfilled, (state, action) => {
        state.status = "idle";
        state.value += action.payload.amount;
      });
  },
});
```
//typstfmt::on
#align(center, [Use reducer])
//typstfmt::off
```js
import { createAsyncThunk, createSlice } from '@reduxjs/toolkit';
import api from "./api";
// First, create the thunk
export const transferAsync = createAsyncThunk(
  "balance/transferApiRequest",
  async (amount) => {
    // function transfer is a reducer!
    const response = await api.transfer(amount);
    return response.data;
    // note the data
  }
);
// ...
dispatch(transferAsync({ amount: 10 }))
```
//typstfmt::on

#subsubsubsection("example")
//typstfmt::off
```js
import { createSlice, configureStore } from '@reduxjs/toolkit';

const counterSlice = createSlice({
  name: 'counter',
  initialState: {
    value: 0,
  },
  reducers: {
    incremented: (state) => {
      // Redux Toolkit allows us to write "mutating" logic in reducers. It
      // doesn't actually mutate the state because it uses the Immer library,
      // which detects changes to a "draft state" and produces a brand new
      // immutable state based off those changes
      state.value += 1;
    },
    decremented: (state) => {
      state.value -= 1;
    },
  },
});

export const { incremented, decremented } = counterSlice.actions;

const store = configureStore({
  reducer: counterSlice.reducer,
});

// Can still subscribe to the store
store.subscribe(() => console.log(store.getState()));

// Still pass action objects to `dispatch`, but they're created for us
store.dispatch(incremented());
// {value: 1}
store.dispatch(incremented());
// {value: 2}
store.dispatch(decremented());
// {value: 1}
```
//typstfmt::on


#subsubsection("When to use Redux")
- when multiple components need to access state
- when state is unreasonably big for one single global state
- e.g. this has overhead and said overhead needs to be valuable
