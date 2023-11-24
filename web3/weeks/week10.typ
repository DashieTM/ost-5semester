#import "../../utils.typ": *

#section("Angular Architectures")
- MVC (Model View Controller)
- MVC + S (Model View Controller + Services -> API abstracted as it can often
  change)
- Flux
  - Flux single store
    - unistore
  - Flux multi store
    - data is divided into multiple stores -> your transactions might not want to live
      in the accounts store
  - Redux -> while used with react, it's not bound to it!
    - implementation of multistore

#align(
  center,
  [#image("../../Screenshots/2023_11_24_05_24_25.png", width: 60%)],
)
#text(
  teal,
)[Note, angular does not come with a store! This is also why the assigment got a
  bit annoying with a missing store -> see new transaction added, how to inform
  the get transaction component.]

#subsection("Model View Controller")
#columns(2, [
  - Angular offers RxJS -> UI / Service / Data Resource
  - angular streams -> see pipes
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_11_24_05_26_17.png", width: 80%)],
  )

])

#subsubsection("Observables")
#align(
  center,
  [#image("../../Screenshots/2023_11_24_05_28_04.png", width: 100%)],
)
- Stream like
- stores and caches objects
- heart of observable is *Subject*
  - *subject represents a traditional multicast event bus, but more powerful*
    - provides all RxJS functional operators
    - EventEmitter<T> provided by Angular
  - hot observable
    - *does not provide the latest value*
    - reason: events can be lost if not accessed before next event

#set text(14pt)
Postfixing an observable with \$ will make it a hot observable! ```ts
// Behavior Subject
// used to store the last state and to notify subscribers about updates
// THIS CAN'T BE USED BY UI
private samples: BehaviorSubject<SampleModel[]> = new BehaviorSubject([ ]);
// hot obsersable
// USED BY UI!!
public samples$: Observable<SampleModel[]> = this.samples.asObservable();
```
#set text(11pt)

#subsubsubsection("Behavior Subject")
#text(
  red,
)[This can't be used by UI! The last state does not interest the UI, it is only
  interested in the latest state!]
#align(
  center,
  [#image("../../Screenshots/2023_11_24_05_37_33.png", width: 100%)],
)
This essentially caches events by providing the initial state when subscribing
and then the subsequent next state.\
#text(
  teal,
)[Note, as this caches events, the behaviorsubject can't expose the next()
  function for events. It would break the idea of it.]

#subsubsubsection("Cold to Hot")
As already explained, we use hot observables for events, which is what the UI
also wants.\
Before it was explained that things like a data request -> post or get return
cold observables, aka they give you the full stored data all the time.\
However, there is also a way to turn this cold observable into a hot observable!
->

- Data resources return cold observables
  - this should not be returned -> otherwhise makes the request again!
  - stores all data
- conversion from cold to hot possible
  - RxJS has a share() operator for this purpose

Example with a request in angular -> BehaviorSubject("warm observable" to hot
observable) ```ts
@Injectable({providedIn: 'root'})
export class SampleService {
 private samples: BehaviorSubject<SampleModel[]> = new BehaviorSubject([ ]);
 public samples$: Observable<SampleModel[]> = this.samples.asObservable();
 constructor(
 private resourceService: SampleResourceService) {
 }
 public addSample(newSample: SampleModel): Observable<any> {
 return this.resourceService
 // store value on server with post
 .post(newSample)
 .pipe(
 tap(res => {
 // notify subscribers about chagne with BehaviorSubject
 this.samples.next([...this.samples.getValue(), newSample]);
 }),
 catchError((err) => this.handleError(err)) );
 }
 private handleError(err: HttpErrorResponse) {
 return new ErrorObservable(err.message);
 }
}
```

#section("Flux Architecture")
The store solves the age old question of where do I store values to that
component X can access it, even though it is in a completely different spot in
the hierarchy?\
#text(
  teal,
)[Note, this is essentially a pattern, not really a framework -> Redux would be a
  framework]
#align(
  center,
  [#image("../../Screenshots/2023_11_24_05_52_18.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_05_53_22.png", width: 100%)],
)

#subsection("Redux in Angular (ngrx)")
#align(
  center,
  [#image("../../Screenshots/2023_11_24_05_55_31.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_05_55_46.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_24_05_56_03.png", width: 100%)],
)

#columns(2, [
  - Benefits
    - Enhanced debugging, testability and maintainability
    - Undo/redo can be implemented easily
    - Reduced code in Angular Components
    - Well known data flow (Component → Store → Component)
    - Reduces change detection overhead
    - Compatible with Redux DevTools
  #colbreak()
  - Liabilities
    - Additional 3rd party library required (ngrx)
    - More complex architecture
    - Lower cohesion, “Global State” may contain business and UI data
    - Data logic may be fragmented into numerous Effects/Reducers
])

#text(
  teal,
)[In short, today most applications use some sort of a flux store, angular with
  it's object oriented design does not offer a similarly fast and safe to
  implement pattern.]

#section("UI Advanced in Angular")
#subsection("Pipes (|)")
- can be applied within templates:\
```html
   <p>{{counter.team | uppercase}}</p>
```
- It is also possible to chain pipes:\
```html
  <p>{{counter.team | uppercase | lowercase}}</p>
  ```
- Multiple paramters with:\
```html
  <p>{{counter.date | date:'longDate'}}</p>
  <!-- results in "February 25, 1970" -->
```

#subsubsection("Pure and Impure")
According to the functional paradigm, pipes can also be pure and unpure:
- pure means no side effects aka everything is immutable
- impure means mutable state

#subsubsubsection("Pure")
- run everytime the input of a pipe changes -> aka it's a closure with an input
  that is run each time the input is "new"
- changes of other components are ignored

#subsubsubsection("Impure")
- run on events -> keystroke event, mouse move event, other events
  - reduces time that impure pipe is running
  - impure pipes can often destroy user experience! -> you do not want continuous
    change on UI

#subsubsubsection("Predefined Pipes")
- AsyncPipe
  - observable_or_promise_expression | async
  - Impure - Unwraps a value from an asynchronous primitive.
- DecimalPipe
  - number_expression | number[:digitSInfo[:locale] ]
  - Pure - Formats a number according to locale rules.
- CurrencyPipe
  - number_expression | currency[:currencyCode [:display [:digitSInfo [:locale] ] ]
    ]
  - Pure - Formats a number as currency using locale rules. Deprecated
- DatePipe
  - date_expression | date[:format [:timezone [:locale] ] ]
  - Pure - Formats a date according to locale rules. Warning: It uses the
    Internationalization API
- PercentPipe
  - number_expression | percent[:digitsInfo [:locale] ]
  - Pure - Formats a number as a percentage according to locale rules.

#subsubsubsection("Filter and OrderBy Pipes")
- Angular does not provide these
  - instead implement filtering and sorting on component
  - filter and orderby pipes can perform poorly with massive amount of data
  - filter and orderby use "aggressive minification" -> this changes names of
    properties to something smaller -> something.count to something.a
    - done to improve performance
    - results in unexpected behavior -> something.count not found???

#subsubsubsection("Custom Pipes")
- class decorated with \@Pipe directive
  - specify name to identify pipe within template
- implement PipeTransform interface
  - each paramater passed will become additional argument for pipe
  - return transformed value
- add Pipe to current Module

Example: ```ts
// pure pipe or not
// name must be the same in template!
@Pipe({name: 'logo', pure: true})
export class LogoPipe implements PipeTransform {
 private logos = { /*...*/ };
 transform(value?: string, transformSettings?: string): string {
 if (value && transformSettings && this.logos[value]) {
 return (this.logos[value][transformSettings] || this.logos[value]['unspec']);
 }
 return value;
 }
}
``` ```html
 <!-- Make sure you use the same name as in TS! -->
 <img src="{{counter?.team | logo:'toImage'}}">
```

#subsubsection("Async Pipes")
- Observables can be bound to pipes
- changes are automatically tracked
- pipe subscribes and unsubscribes to bound observables
  - for change, the pipe must be given new values/references -> *same array results
    in no change*
  - on change pipe calls *markForCheck()* on the change detector
    - bound observable must be bound exactly once!
- *async pipes are impure!*

Example:\
```html
<h1>WE3 - Sample Component</h1>
<section>
<li *ngFor="let s of sampleService.samples$ | async">
<ul>{{s.name}}</ul>
</li>
</section>
```
```ts
@Component({...})
export class CounterComponent {
constructor(
public sampleService:SampleService) {
}
}
```

#subsection("SCSS")
- scss compiled to css
- per component scss
  - selectors only available within this component / or in root
  - no selector conflicts mean you can have the same name in multiple components!

#subsubsection("Special CSS selectors")
- :host
  - target styles in the element that hosts said component
  - :host{} -> targets host element
  - :host(.active){} -> targets host element when it has active class
- :host-context
  - looks for a css class in any ancestor of the component, up to document root
  - :host-context(.theme-light) h2 {} applies style to all h2 elements inside the
    component, if some ancestor has the theme-light class

#subsubsection("Link Styles to Components")
- Add a styles array property to the \@Component decorator\
  ```ts
      @Component({ /*...*/
      styles: ['h1 { font-weight: normal; }']
      // don't
      })
      ```
- Add styleUrls attribute into a components \@Component decorator\
  ```ts
      export class WedNavComponent { }
      @Component({ /*...*/
      styleUrls: ['app/nav.component.css']
      // yes
      })
      ```
- Template inline tags/styles\
  ```ts
      export class WedNavComponent { }
      @Component({ /*...*/
      template: `<style>…</style> … <link rel="stylesheet" href="app/nav.component.css">`
      // don't
      })
      export class WedNavComponent { }
      ```

#subsubsubsection("Encapsulation")
- styles are encapsulated into the component view
- encapsulation can be controlled on a per component basis ```ts
   @Component({
   // set your mode here
   encapsulation: ViewEncapsulation.Native
   })
   export class WedNavComponent { }
   ```
- The following modes exist:
  - Native -> Uses the browser's native shadow DOM implementation
  - Emulated(default) -> Emulates the behavior of shadow DOM by preprocessing and
    renaming the CSS code
  - None -> No view encapsulation (no scope rules) are applied. All css are added to
    the global style
  Example:
  #align(
    center,
    [#image("../../Screenshots/2023_11_24_06_37_08.png", width: 100%)],
  )

#section("Ahead-Of-Time Compilation (AOT))")
- meaningless name...
- Angular uses a compiler to translate components/services into browser executable code
- usually, compiler is delivered to the client
  - allows for dynamic JIT compilation
- compiler is about 60% of the angular package
- pre-compiling is possible to reduce size
- enabled by default


