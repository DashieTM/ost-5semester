#import "../../utils.typ": *

#section("Semantic Checker")
Checks language rules -> LSP
- each identifier is unique within its scope
- typerules are fulfilled
- method calls are compatible with parameters and return types
- no cyclic inheritance

#subsection("Tables and Scopes")
Per scope, we create a symbol table in order to quickly check later on whether
or not something already exists, and what type etc. it has.
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_10_16_08_21_07.png", width: 100%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_10_16_08_21_33.png", width: 100%)],
  )
])
#text(
  teal,
)[Note that inner scopes can have the same symbol as the outer scope -> in this
  case the inner scope shadows the outer scope symbol.]

#subsection("Type Hierarchy")
This hierarchy is defined for the abstract syntax tree (AST) that the semantic
checker is going to use.
#align(
  center,
  [#image("../../Screenshots/2023_10_16_08_23_24.png", width: 70%)],
)
inbuilt types:
- value types
  - int
  - boolean
  - Null-Type
- reference types
  - string

#subsubsection("Type Hierarchy for Classes")
#align(
  center,
  [#image("../../Screenshots/2023_10_16_08_25_07.png", width: 70%)],
)
Further inheritances of VariableSymbol:
#align(
  center,
  [#image("../../Screenshots/2023_10_16_08_28_49.png", width: 70%)],
)

#subsubsection("More builtin types for smallj")
- types
  - int, boolean, string
- constants
  - true, false
  - null
- this
- built-in methods
  - writeString
- fields
  - length -> readonly and only for arrays

#subsubsection("Arrays")
Arrays don't have a special class in the semantic checker for smallj, instead we
have to add the [] on the fly -> type [].

#subsection("Procedure")
+ create a symboltable with all declarations
  - you might need multiple ones -> multiple scopes
+ resolve types of declarations
+ resolve usage of declarations to abstract syntax tree (AST)
+ check types in AST

#subsubsection("Symbol Table Creation")
write each type in a table...

#subsubsection("Type Resolution")
Each declaration needs some sort of type, this means we now have to go back to
the previously created table and traverse through it. Each entry needs to have a
resolved type at the end of the table. Resolved type means that the declaration
is now represented with 2 symbol entries in the AST -> variable AND class symbol
instead of only variable symbol.
#align(
  center,
  [#image("../../Screenshots/2023_10_16_08_39_22.png", width: 70%)],
)
#subsubsubsection("Method for searching")
#align(
  center,
  [#image("../../Screenshots/2023_10_16_08_44_32.png", width: 70%)],
)
//typstfmt::off
```cs
bool TryFind<T>(string identifier, out T? declaration) where T : Symbol {
  Symbol? scope = this;
  do {
    foreach (var member in scope.Declarations) {
      if (member.Identifier == identifier) {
        declaration = member as T;
        return declaration != null;
      }
    }
    scope = scope.Scope;
  } while (scope != null);
  declaration = default;
  return false;
}
```
//typstfmt::on

#subsubsection("Type Usage")
Each usage of a declaration needs to be referenced to an entry in the symbol table.
#align(center, [#image("../../Screenshots/2023_10_16_08_46_44.png", width: 70%)])

#subsubsection("AST Check")
Check types of each node from bottom to top.
//typstfmt::off
```cs
TypeSymbol? ExpressionType { get; private set; }
override void Visit(BinaryExpressionNode node) {
  var left = node.Left;
  var right = node.Right;
  left.Accept(this);
  var leftType = ExpressionType;
  right.Accept(this);
  var rightType = ExpressionType;
  switch (node.Operator) {
  // case ...
  case Operator.DIVIDE or Operator.MINUS: // more ommitted
  CheckType(leftLocation, leftType, _intType);
  CheckType(rightLocation, rightType, _intType);
  ExpressionType = _intType;
  break;
  default: throw new ArgumentOutOfRangeException(nameof(node.Operator));
  }
}
```
//typstfmt::on

#subsection("Semantic Checks")
- all designators are connecte to a variable
- variables used with operators have the correct type
- types are compatible on assignments
- expression inside if statements are booleans
- return expression fits return type
- no multiple declarations within one scope
- no user defined identifier matches a built-in one
- one main method defined
- array length is read only

#subsubsection("More Checks")
These checks can't be generally be checked in one place -> might need multiple types of checks
- no exit without return other than in void methods
- reading of uninitialized variables
- null-dereferencing
- out-of-bounds array index
- division by 0
- out of memory on new

