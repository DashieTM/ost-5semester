#import "../../utils.typ": *

#align(
  center,
  [#image("../../Screenshots/2023_11_16_03_56_28.png", width: 80%)],
)

#subsection("Base href")
- uses history.pushState() -> lmao
- HTML5 style navigation
  - can be overriden with \#navigation
  - Register provider for LocationStrategy as HashLocationStrategy class
    - or configure RouterModule with useHash: RouterModule.forRoot(routes, { useHash:
      true })
- HTML needs a base ref tag in order to access relative file paths:
```html
<html>
  <head>
    <base href="/">
  </head>
</html>
```
- or provide the base href in angular ts:
```ts
providers: [{provide: APP_BASE_HREF, useValue : '/' }]
```

#subsection("ForRoot")
With the forRoot directive, the given routes and the router service exist in one
singleton instance of the router. ```ts
@NgModule({
 imports: [ RouterModule.forRoot(appRoutes) ],
 exports: [ RouterModule ]
})
export class AppRoutingModule {}
```

#subsection("ForChild")
With the forChild directive, the given routes exist on this module, but not the
router service itself -> e.g. that needs to be done by the main forRoot router.
```ts
@NgModule({
 imports: [ RouterModule.forChild(welcomeRoutes) ],
 exports: [ RouterModule ]
})
export class WelcomeRoutingModule {}
```

#subsection("Routing example")
#align(
  center,
  [#image("../../Screenshots/2023_11_16_04_17_28.png", width: 80%)],
)

#subsection("Router Outlet")
- RouterOutlet is a directive from the Router module
- Defines where the router should display the views
- Can also be specified within a child component
```HTML
<h1>WE3 - App Component</h1>
  <nav>
    <a routerLink="/dashboard">Open Dashboard</a>
  </nav>
<router-outlet></router-outlet>
```
#align(
  center,
  [#image("../../Screenshots/2023_11_16_04_26_41.png", width: 80%)],
)

#subsection("Routing examples")
```ts
const appRoutes: Routes = [
  { path: 'crisis-center', component: CrisisListComponent },
  // Maps the /crisis-center path to the CrisisListComponent
  { path: 'hero/:id', component: HeroDetailComponent },
  // Maps the /hero/42 path to the HeroDetailComponent
  // "42" is variable, specifies the value of the id parameter; can be read out by code
  { path: '', redirectTo: '/heroes', pathMatch: 'full' },
  // Redirects the default route (/) path to the /heroes path. '' must be exactly matched.
  { path: '**', component: PageNotFoundComponent }
  // Specifies a wildcard route (two asterisks) which matches every URL.
  // Used if the requested URL doesn't match any of the defined routes.
];
```
- first route that matches wins -> enum like
- wildcard route on the last entry -> handle all routes that don't match otherwise
- guards for route activation -> authentication
- pathMatch: 'full' -> whether or not the path should exactly be matched and
  consumed
  - aka no further matching -> don't match on wildcard

#subsection("Child Route Example")
```ts
const routes: Routes = [
  { path: 'samples', component: SamplesComponent,
    // Maps /samples path to the SamplesComponent . This component also
    // contains a router outlet.
    // http://localhost:4200/samples
    children: [
      { path: ':id', component: SamplesDetailComponent },
      // Defines the router outlet of SamplesComponent should be filled with the
      // SamplesDetailComponent if an id has specified.
      // http://localhost:4200/samples/42
      { path: '', component: SamplesListComponent }
      // Defines the router outlet of SamplesComponent should be filled with the
      // SamplesListComponent if no sub-path given.
      // http://localhost:4200/samples/
    ]
  }
];
```
#align(
  center,
  [#image("../../Screenshots/2023_11_16_04_59_33.png", width: 90%)],
)

#subsubsection("Lazy Routes")
The issue with lazy routes is that if you use lazy components, you need to
define your models in routes like this(see below), as the components would
otherwise not be ready for the router on application start. (The solution is to
just use a function lmao)\
```ts
const routes: Routes = [
 { path: 'samples', component: SamplesComponent },
 {
 path: 'config',
 loadChildren: () => import('./cfg/cfg.module').then(m => m.CfgModule),
 canLoad: [ AuthGuard ]
 // authentication thing
 }
];
```

#section("Module Imports")
#subsection("Default Import")
- Imports all Components, Pipes, Directives from the given ForeignModule (by
  exports property)
  - Declarations will be re-instantiated on the current module level
- Providers are registered into the current DI container, if registration not yet
  made
- is a forChild import without options
```ts
@NgModule( { imports: [ ForeignModule ] })
```

#subsection("forChild Import")
- forChild(config?) represents a static method on a module class (by convention)
  - It returns an object with a providers property and a ngModule property
- basically same as default import
  - but allows you to configure services for the current Module level
```ts
@NgModule( { imports: [ ForeignModule.forChild( { } ) ] })
```

#subsection("forRoot Import")
```ts
@NgModule( { imports: [ ForeignModule.forRoot( { } ) ] })
```
- imports things
- configures services -> *hence can't be called by anyone other than the root
  module*
  - e.g. these services will be loaded for the entire application
- you can define forRoot and forChild yourself -> define what services your module
  needs

Example:\
#align(
  center,
  [#image("../../Screenshots/2023_11_16_05_38_24.png", width: 80%)],
)

#section("Module Types")
#align(
  center,
  [#image("../../Screenshots/2023_11_16_05_41_24.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_16_05_48_44.png", width: 80%)],
)

#subsection("Root Module")
- provides main view -> root component
- a root module has no reason to export anything
- by convention names AppModule in app.module.ts
- imports BrowserModule -> necessary
- bootstrapped by the main.ts
  - Accomplished according the used compilation mechanism (dynamic / AOT)
#subsection("Feature Modules")
- splits the application into a set of modules
- differentiation of responsibilities
- can expose or hide it's implementation from other modules

subcategories:
- Domain Modules
  - Deliver a UI dedicated to a particular application domain.
- Routing Modules
  - Specifies the routing specific configuration settings of the Feature (or Root)
    Module.
- Service Modules
  - Provides utility services such as data access and messaging.
- Widget Modules
  - Makes components, directives, and pipes available to external modules.
- Lazy Modules (Routed Modules)
  - Represents lazily loaded Feature Modules.

#subsection("Shared Module")
- provides *globally* used components/directives/pipes
- Do not specify app-wide singleton providers (services) in a shared module
  - A lazy-loaded module that imports that shared module makes its own copy of the
    service
  - Specify these providers in the Root Module instead

#subsection("Core Module")
- provides globally required services
- helps keep the root module clean
- only the root module should import the core module
  - guard against imports:
  ```ts
          constructor (@Optional() @SkipSelf() parentModule: CoreModule) {
            if (parentModule) {
              throw new Error(
                'CoreModule is already loaded. Import it in the AppModule only.');
            }
          }
          ```

#subsection("Lazy Modules")
- Provides similar features as Feature Modules but not loaded at start
- Angular creates a lazy-loaded module with its own Dependency Injection container
  - A child of the root injector
  - Required because the Root DI container mustn’t be modified after the
    initialization
- May cause some strange behavior if forRoot() rules are violated
