#import "../../utils.typ": *

#section("Components Advanced")
#subsection("Component lifecycle")
- same as react with hooks
- ngOnInit
  - hydration -> same as react
- ngOnDestroy
  - dehydration -> same as react
- ngAfter events are mainly for control developers to handle sub-components and
  their DOM
  #align(
    center,
    [#image("../../Screenshots/2023_11_09_04_42_01.png", width: 50%)],
  )

```ts
@Component({
  // do something here
})
export class CounterComponent implements OnInit, OnDestroy {
  ngOnInit() {
    console.log("OnInit");
  }
  ngOnDestroy() {
    console.log("OnDestroy");
  }
}
```
#subsection("Component Projection")
- also called *component transclusion*
- angular components consist of HTML and class components -> the html part needs
  to act like a proper HTML tag
- how to allow inserting other html tags inside of this component?
This allows users to add content to the component without acessing the
javascript or typescript code:
#align(
  center,
  [#image("../../Screenshots/2023_11_09_04_46_03.png", width: 100%)],
)
Aka, as one can see, it is the tag in HTML, into which we can enter our content,
e.g. text or more tags.
#subsubsection("HTML Expansion")
While inserting tags is nice, we also want the component to provide its own HTML
-> see vue for an easier version.\
E.g. we want our own navigation component, which adds a header and a nav, this
is handled with a different html -> the navigation.component.html for our
navigation component. This will then be called before and after our tags that we
insert into the component.
#align(
  center,
  [#image("../../Screenshots/2023_11_09_04_48_43.png", width: 100%)],
)
#text(
  teal,
)[Note, the amount of ng-content defines how many tags we can insert! 1 ng-content
  -> 1 tag]

#subsubsection("Multi Shot Expansion")
#text(
  teal,
)[This is the same as above with the addition that we check for the select title,
  this makes us able to only insert specific tags:]
#align(
  center,
  [#image("../../Screenshots/2023_11_09_04_51_25.png", width: 100%)],
)

#section("Async Services")
- intention: don't block UI...
- data streams via *RxJS*
  - can be very complex to use for everything
  - events are easier for simple data
- EventEmitter in Angular
  - implementation corresponds to the Observer Pattern
  - compoments need to register to the desired events on the respective service
  - can be bound to UI to automatically update UI

Example: ```ts
@Injectable({providedIn: 'root'})
export class SampleService {
 private samples: SampleModel[] = []; // simple cache
 public samplesChanged: EventEmitter<SampleModel[]> =
 // create new event emitter
 // data inside event emitter is the type that will be passed to the subscribers
of the event
 new EventEmitter<SampleModel[]>();
 constructor( /* inject data resource service */ ) {}
 load(): void {
 /* in real word app, invoke data resource service here */
 this.samples = [ new SampleModel() ];
 this.samplesChanged.emit(this.samples);
 }
}
export class SampleModel {}
``` Example Usage: ```ts
@Component({ ... })
export class SampleComponent implements OnInit, OnDestroy {
 private samples: SampleModel[];
 private samplesSubscription: Subscription;
 constructor(private sampleService: SampleService) {}
 ngOnInit() {
 this.samplesSubscription = this.sampleService.samplesChanged.subscribe(
 (data: SampleModel[]) => { this.samples = data; });
 }
 ngOnDestroy() {
 this.sampleSubscription.unsubscribe();
 }
}
```

#section("Data Access")
- implemented as RxJS
- uses cold observables
  - observables start running on subscription
  - not shared among subscribers
  - are automatically closed after task is finished
- why obersables and not promises? They didn't exist yet...

Using subscribe: ```ts
const subscription = this.http.get('api/samples').subscribe({
 next: (x) => { /* onNext -> data received (in x) */ },
 error: (e) => { /* onError -> the error (e) has been thrown */ },
 complete: () => { /* onCompleted -> the stream is closing down */ }
});
```

Example Service: ```ts
@Injectable({providedIn: 'root')
export class SampleDataResourceService {
 private samplesUrl = 'api/samples'; // web API URL
 constructor(private http: HttpClient) {}
 // the "subscription"

 get(): Observable<SampleModel[]> {
 return this.http.get(this.samplesUrl)
 .pipe(
 map((data) => this.extractData(data)),
 catchError((err) => this.handleError(err)));
 }
 //handle the subscription

 private extractData(data: any): SampleModel[] {
 return SampleModel.fromDto(data);
 }

 private handleError(err: HttpErrorResponse) {
 if (err.error instanceof ErrorEvent) {
 // a client-side or network error occurred
 } else {
 // the backend returned an unsuccessful response code
 }
 // in a real-world app, you might delegate the
 // error to a system state/error service or
 // override the gobal ErrorHandler
 return throwError(err.message);
 }
}
```

Example Service Usage: ```ts
@Injectable({providedIn: 'root')
export class SampleService {
 private samples: SampleModel[] = []; // simple cache
 public sampleChanged:EventEmitter<SampleModel[]> = new
EventEmitter<SampleModel[]>();
 constructor(private dataResource: SampleDataResourceService) {}
 load(): void {
 this.dataResource.get().subscribe(
 (samples: SampleModel[]) => { // update cache, emit change event, ...
 this.samples = samples;
 this.sampleChanged.emit(this.samples);
 });
 }
}
export class SampleModel { }
```

#subsection("Intercept HTTP request")
- Often, we must set the same HTTP headers on every request
  - For example: For security reasons, it may be required to insert the
    Authorization header (bearer-token) on every request
  - There are more headers to be written into every request, such as content-type
- angular provides hook to inercept HTTP calls

#align(
  center,
  [#image("../../Screenshots/2023_11_09_06_29_37.png", width: 100%)],
)

#section("Routing")
- optional module: RouterModule
- combination of services
  - RouterOutlet
  - RouterLink
  - RouterLinkActive
- each definition maps a route (URL path segment to a component)
- top-most routes are registered on forRoot()
  - .forRoot(): use forRoot()-import EXACTLY once to declare routes on root (top)
    level
  - .forChild(): use forChild()-import when declaring sub-routings (on all
    sub-levels)
- Each ngModule (Feature Module) defines its own routes
  - Routes should be defined within their own Routing Modules
- Routes can reference a module which can be loaded on-demand (lazy load)
  - Use the import()-Syntax for that purpose

Example:
#align(
  center,
  [#image("../../Screenshots/2023_11_09_06_27_53.png", width: 100%)],
)
