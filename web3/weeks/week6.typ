#import "../../utils.typ": *

#section("Angular")
#align(
  center,
  [#image("../../Screenshots/2023_10_26_02_01_15.png", width: 70%)],
)
- typescript based
- reduces boilerplate code
- Comes with *dependency injection* mechanism
- increases testability and maintainability
- framework templating etc.

#subsection("CLI")
#align(
  center,
  [#image("../../Screenshots/2023_10_26_02_25_51.png", width: 80%)],
)
Much like creating something with a compiled language, the best way to create an
angular project is with the angular cli, which handles building, testing and
deploying the package.
- npm install \@angular/cli
- npx ng new my-app
- npx ng serve --open
- npx ng build
- npx ng test

#subsection("Architecture")
#align(
  center,
  [#image("../../Screenshots/2023_10_26_02_05_36.png", width: 80%)],
)
- ngModules
  - A cohesive block of code dedicated to closely related set of capabilities.
- Directives
  - Provides instructions to transform the DOM.
- Components
  - A component is a directive-with-a-template; it controls a section of the view.
- Templates
  - A template is a form of HTML that tells Angular how to render the component.
- Metadata
  - Metadata describes a class and tells Angular how to process it.
- Services
  - Provides logic of any value, function, or feature that your application needs.

#subsubsection("Angular Modules")
- logical block of typscript modules together
- may provide a \<\<barrel\>\> (intex.ts) which exports public API
- may contain multiple-sub modules
- contain and export classes, functions etc.
  - all public typscript memebers are exported as an overall \<\<barrel\>\>
- Angular provides library modules
  - \@angular/core
  - \@angular/common
  - \@angular/router
Example module declaration: ```ts
@NgModule({
 imports: [
 CommonModule
 ],
 declarations: []
})
export class CoreModule { }
``` Declarations and notation:
- declarations: [ Type1, Type2, Type3]
  - specifies what types will be used in this module ->
- exports: [ Type1, Type2, … Module1, Module2 ]
  - what exports
- imports: [ Module1, Module2, …]
  - what imports
- providers: [ Provider1, Provider2, …]
  - services that this module provides for the global application -> always visible
    and accessible
- bootstrap: [ Component ]
  - root component

#subsubsection("Components")
Consists of:
- A controller (MVC)
  - provides logic for the component
  - a typescript class with \@component annotation
- An additional HTML file
  - declares the visual interface in HTML and a mustache-based template expression
    syntax -> handlebars
- an scss file for styling

Components are similar to react with a few key differences like annotation
instead of inheritance -> likely because angular is older, lol.\
- components can be nested -> tree just like jsx
- reusability
- components are part of an ngModule which usually declare multiple components

#subsubsection("Code Example")
HTML://typstfmt::off
```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>WE3 Angular / [adv1-demo1-final] - Samples</title>
  <base href="/">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" type="image/x-icon" href="favicon.ico">
</head>
<body>
  <wed-root>Please wait while loading your angular app...</wed-root>
</body>
</html>
```
//typstfmt::on

main:
//typstfmt::off
```ts
import { enableProdMode } from '@angular/core';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';

import { AppModule } from './app/app.module';
import { environment } from './environments/environment';

if (environment.production) {
  enableProdMode();
}

platformBrowserDynamic().bootstrapModule(AppModule)
  .catch(err => console.error(err));
```
//typstfmt::on


Component:
//typstfmt::off
```ts
import {Component} from '@angular/core';
@Component({
  selector: 'wed-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
}
```
//typstfmt::on
Component HTML:
//typstfmt::off
```html
<router-outlet></router-outlet>
```
//typstfmt::on


Router:
//typstfmt::off
```ts
import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';

const appRoutes: Routes = [
  {path: '', redirectTo: '/welcome', pathMatch: 'full'}
];

@NgModule({
  imports: [
    RouterModule.forRoot(appRoutes)
  ],
  exports: [
    RouterModule
  ]
})
export class AppRoutingModule {
}
code
```
//typstfmt::on

BaseModule:
//typstfmt::off
```ts
import {BrowserModule} from '@angular/platform-browser';
import {NgModule} from '@angular/core';

import {CoreModule} from './core/core.module';
import {WelcomeModule} from './welcome/welcome.module';

import {AppComponent} from './app.component';
import {AppRoutingModule} from './app-routing.module';


@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    CoreModule.forRoot(),
    WelcomeModule.forRoot(),

    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule {
}
```
//typstfmt::on

#text(teal)[Note, scss files and environment ts files are omitted.]
