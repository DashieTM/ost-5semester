#import "../../utils.typ": *

#section("JHipster")
- Generator for complex applications
  - angular, react, vue supported
  - spring boot
  - maven/gradle, npm
  - postgres, mongodb, elasticsearch, cassandra, etc.
  - monolith or microservices
  - tsets, CI/CD, deployment
- User Management, Login, Registration
- CRUD for entities, pagination, etc.

#subsection("JDL: JHipster Domain Language")
//typstfmt::off
```rs
// entity Employee {
//  firstName String,
//  lastName String,
// }

// relationship ManyToOne {
//  Employee{manager} to Employee
// }
```
//typstfmt::on

#subsection("Experiences")
#columns(2, [
  #text(green)[Benefits:]
  - fast setup
  - most CRUD programming is done automatically via entity definition
  - with JDL, you can have a prototyp within minutes
  #colbreak()
  #text(red)[Downsides:]
  - round-trip engineering is not supported
  - re-generating the app after JDL change is possible, but must be merged -> *conflicts!*
  - user interface only supports bootstrap, not very flexible
  ])


#section("Testing with React (Jest)")
- comes with create-react-app
- interactive watch mode
- snapshot testing
- code coverage
- mocks for callbacks
- expect methods(what a feature...)
- with react testing library, you can test without browser
  - tests without needing a browser -> render and screen utilities included
  - also integrated into create-react-app

#subsection("Example")
//typstfmt::off
```tsx
// example app
function Fetch({url}) {
  const buttonText = buttonClicked ? 'Ok' : 'Load Greeting’
  return (
    <div>
      <button onClick={() => fetchGreeting(url)} disabled={buttonClicked}>
        {buttonText}
      </button>
      {greeting && <h1>{greeting}</h1>}
      {error && <p role="alert">Oops, failed to fetch!</p>}
    </div>
  )
}

// Test for app
import {render, screen} from '@testing-library/react'
import userEvent from '@testing-library/user-event'

test('loads and displays greeting', async () => {
  // ARRANGE
  // render the greeting page -> not really ofc
  render(<Fetch url="/greeting" />)
  // ACT
  // click the button, or rather simulate it
  await userEvent.click(screen.getByText('Load Greeting’))
  await screen.findByRole('heading’)
  // ASSERT
  // check if whatever was supposed to happen actually did happen
  expect(screen.getByRole('heading')).toHaveTextContent('hello there’)
  expect(screen.getByRole('button')).toBeDisabled()
})
```
//typstfmt::on

#text(teal)[End-to-End testing can be done with cypress.io -> (Jest and cypress.io)]
#align(center, [#image("../../Screenshots/2023_10_19_08_35_08.png", width: 70%)])
