#import "../../utils.typ": *

#subsubsection("Combining exports")
#align(
  center,
  [#image("../../Screenshots/2023_11_02_02_16_09.png", width: 100%)],
)

#subsubsection("Combined example")
#align(
  center,
  [#image("../../Screenshots/2023_11_02_02_17_14.png", width: 100%)],
)

#section("Templates")
#subsection("Bindings")
- one-way source to view -> code to html\
  ```html
  <p>... {{counter.team}}</p><!-- interpolation -->
  <img [attr.alt]="counter.team" src="team.jpg">
  ```
  
- one-way view to source -> html to code\
  ```html
  <button (click)="counter.eventHandler($event)">
  ```
  
- to way: usefull for textboxes -> view to source: value of textbox changed\
  ```html
  <input type="text" [(ngModel)]="counter.team">
  ```
  
 #align(center, [#image("../../Screenshots/2023_11_02_02_23_40.png", width: 70%)])

 #subsubsection("Interpolation")
 This is the {{ geil }} syntax:
 - side effects not allowed -> no ++ -- etc
 - binary operators allowed -> ! & ? etc

 #subsubsection("Binding Input and Output properties")
- \@Output()\
  wed-navigation (click)="..."\
  Your component/directive fires bindable events(such as click).
- \@Input()\
  wed-navigation [globi]="..."\
  Your component/directive consumes bindable values(such as globi).

```ts
@Component({…})
export class NavigationComponent {
  @Output() click =
    new EventEmitter<any>();
  @Input() globi: string;
}
```


#subsection("Directives")
- Similar to a component but without a template.
- Defined as a typescript class with a \@Directive() decorator
- Two different kinds of directives exist:
  - Structural directives: Modifies the structure of your DOM
  - Attribute directives: Alter the appearance or behavior of an existing element

#subsubsection("Attribute Directives")
- Changes the appearance or behavior of an element, component, or another directive
- Applied to a host element as an attribute
NgStyle Directive
Sets the inline styles dynamically, based on the state of the component.

```html
<div [ngStyle]="{ 'font-size': isSpecial ? 'x-large' : 'smaller' }">
<!-- render element -->
</div>
```
NgClass Directive
Bind to the ngClass directive to add or remove several classes simultaneously.
```html
<div [ngClass]="hasWarning ? 'warning' : '' ">
<!-- render element -->
</div>
```


#subsubsection("Structural Directives")
- Responsible for HTML layout
- Reshape the DOM's structure, typically by adding, removing, or manipulating elements
- Applied to a host element as an attribute
- An asterisk (\*) precedes the directive attribute name
NgIf Directive
Takes a boolean value and makes an entire chunk of the DOM appear or disappear.

```html
<div *ngIf="hasTitle"><!-- shown if title available --></div>
```
The \* addition is just syntax sugar, expands to this:
```html
<ng-template [ngIf]="hasTitle">
  <div><!--conditional content--></div>
</ng-template>
```
NgFor Directive
Represents a way to present a list of items.
```html
<li *ngFor="let element of elements"><!-- render element --></li>
```
NgIf Else
```html
<!-- the reference is an id that is set -> we render the reference when else is chosen -->
<ng-template #toReference><!-- content --></ng-template>
<div *ngIf="hasTitle; else toReference"><!-- conditional content --></div>
```


#subsubsection("Template Reference Variables")
- References a DOM element within a template
- Can also be a reference to an Angular component or directive
- Reference variables can be used anywhere in the template
- A hash symbol (\#) declares a reference variabl

```html
<input placeholder="phone number" #phone>
<button (click)="callPhone(phone.value)">Call</button>
```

#subsubsection("Templates Demo")
#align(center, [#image("../../Screenshots/2023_11_02_02_39_48.png", width: 90%)])

#section("Services")
Provides any value, function, or feature that your application needs.\
Can be set as a root service or within a module with the forRoot/forChild module declaration -> later

#subsection("Example")
#align(center, [#image("../../Screenshots/2023_11_02_02_46_19.png", width: 90%)])
