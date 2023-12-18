#import "../../utils.typ": *

#section("JIT part 2")

#subsection("Native Code")
For CSharp, when trying to run native code, you need to copy the code into
memory and mark the page as executable. Then you need to wrap the code within
the Marshal.GetDelegateForFunctionPointer<>() and call this delegate.

The System.Runtime.InteropServices is required to be implemented.

#subsection("Code Optimization")
Just like a general compiler, certain operations can be shortened or changed in
order to provide faster execution.

For example, you can use bit operations instead of regular multiplication,
division and modulo.
#align(
  center, [#image("../../Screenshots/2023_12_18_08_22_36.png", width: 50%)],
)

Or you can replace unnecessary operations with simpler static calls: e.g. 1 + 2
-> both constants, will always be 3. Replace with constant 3.
#align(
  center, [#image("../../Screenshots/2023_12_18_08_24_54.png", width: 70%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_18_08_25_12.png", width: 70%)],
)

```rs
// N and M are constant, this can be replaced with a variable
while (x < N * M) {
  // y doesn't change within this loop,
  // can therefore be changed to a constant within this loop
  // e.g. put in variable
  k = y * M;
  x = x + k;
}

// new code
k = y * M;
temp = N * M;
while (x < temp) {
  x = x + k;
}
```

#subsection("Dead Code")
Code that is never run, can simply be removed.
#align(
  center, [#image("../../Screenshots/2023_12_18_08_28_05.png", width: 100%)],
)

#subsection("Redundant variables")
Similarly to the repeated writing in the loop example, you can also create code
that needlessy allocates variables. In this case, you can simply remove the
write and use the temporary value of a result.
```rs
t = x + y;
// this is useless
u = t;
writeInt(u);

//new code
writeInt(x + y);
```

#align(
  center, [#image("../../Screenshots/2023_12_18_08_30_24.png", width: 100%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_18_08_30_49.png", width: 100%)],
)

#subsection("Constant Propagation/Folding")
This is simply the check for a variable that will always result in a particular
value, e.g. if your code evaluates that variable x will always be of value 2,
then x can be replaced to be a constant 2. (aka x removed, replaced with 2 in
code)
```rs
a = 1;
if (something) {
  a = a + 1;
  // b is still 2 here
  b = a;
} else {
  b = 2;
}
// c will always be 3
c = b + 1;

// new code
a = 1;
if (something) {
  a = 2;
  b = 2;
} else {
  b = 2;
}
c = 3;
```

#subsection("Partial Redundancy")
This is code that is evaluated twice depending on the branch:
```rs
if (something) {
  y = x + 4;
} else {
  // ...
}
// this was already executed in the if statement if it evaluated to true
z = x + 4;

// new code
if (something) {
  // note the code still needs to be here
  // otherwise you might change the code meaning!
  t = x + 4;
  y = t;
} else {
  // ...
  t = x + 4;
}
z = t;
```

#subsection("Detection Methods")
How to detect that you can optimize anything.

#subsubsection("Static Single Assignment")
An old principle -> most used in the 90s. This ensures that variables are only
allocated once, aka the compiler will use a different variable if you reuse a
variable in your code for something new.

```rs
// old
x = 1;
x = 2;
y = x;

// new
x1 = 1;
x2 = 2;
y1 = x2;
```

Dead Code:

```rs
// redundant, can be deleted
x1 = 1;
x2 = 2;
y1 = x2 + 1;
writeInt(y1);
```

With this method, you will encounter problems however, for example how do you
ensure this works with a loop?

```rs
if (something) {
  x = 1;
} else {
  x = 2;
}
y = x;

if (something) {
  x1 = 1;
} else {
  x2 = 2;
}
// which version?
y1 = x??;
```

#subsubsubsection("Phi")
With phi, the correct x will be chosen.
#align(
  center, [#image("../../Screenshots/2023_12_18_08_41_52.png", width: 100%)],
)

summary:
- complex
- powerful changes
- needs time
  - especially PHI
- not viable for JIT

#subsubsection("Peephole Optimization")
Only a subsectiong of code is analyzed, e.g. the next 3 instructions.
#align(
  center, [#image("../../Screenshots/2023_12_18_08_45_49.png", width: 70%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_18_08_46_08.png", width: 100%)],
)

#subsection("Overall Summary")
#align(
  center, [#image("../../Screenshots/2023_12_18_08_46_24.png", width: 100%)],
)

