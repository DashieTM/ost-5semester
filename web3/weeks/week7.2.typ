#import "../../utils.typ": *

#section("Forms")
Essentially just a usage of the templates from before -> enhances html5 form.
```html
<form>
 <input type="text" class="form-control" pattern="[a-zA-Z]{3,}">
</form>
```

Two-way data binding: ```html
<label for="login">Login Name</label>
<input type="text" class="form-control" id="login" required
 [(ngModel)]="model.login" name="login">
```

#subsection("Handle Validation Error Messages")
- The validation is automatically applied
- Reference the [ngModel] directive and check its valid property
- To reference the directive (as object) in the template, a specific syntax is
  used: − ngModel is the exported name of the directive, \#nameField represents
  the template reference variable
```html
<input type="text" class="form-control" id="name" required
    [(ngModel)]="model.name" name="name" #nameField="ngModel">
<div [hidden]="nameField.valid || nameField.pristine" class="alert alert-danger">
  Name is required
</div>
```
#subsection("Submitting the Form")
#align(
  center,
  [#image("../../Screenshots/2023_11_02_03_13_53.png", width: 80%)],
)

#subsection("Submitting the form with ngModel")
#align(
  center,
  [#image("../../Screenshots/2023_11_02_03_14_06.png", width: 80%)],
)
