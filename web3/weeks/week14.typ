#import "../../utils.typ": *

#section("Web Assembly")
- \*.WASM ( WebAssembly )
  - Compiled Web Assembly
  - Can be transformed back to WAT
- \*.WAT ( Web Assembly Text )
  - Text Based Web Assembly
  - Can be compiled to WASM
  - example code
```wasm
(module
(func (export "addTwo") (param i32 i32) (result i32)
// pop/load first param
local.get 0
// pop/load second param
local.get 1
// add both params and put result to stack
i32.add)
)
```
- Web Assembly
  - Stack Machine

#subsection("Module")
- export and import functions etc, from and to js
- has to be instantiated with a js function

```js
const wasmInstance =await WebAssembly
.instantiateStreaming(fetch("hello-world.wasm"), {});
console.log(wasmInstance.module); // contains the module
console.log(wasmInstance.instance); // contains the instance
```

#subsection("Memory")
This is a shared memory allocation shared between javascript and wasm.
- As of now, only 1 memory allication can be shared.
- allocation can be done in JS OR WASM
```js
const memory = new WebAssembly.Memory({
initial: 1, // Number of pages ( 1 * 64KiB )
maximum: 2 // Max number of pages
});
WebAssembly.instantiateStreaming(fetch("memory.wasm"), { js: { mem: memory } })
```
#align(
  center, [#image("../../Screenshots/2023_12_27_03_24_44.png", width: 100%)],
)
The reason for the 0x1 address is the overlap of an i32 -> 0x0 is the start and
0x3 the end of an i32, starting with 0x1 would overwrite partial allocations,
leaving you with 2 weird integers with unexpected values.

#subsection("Table")
A resizable typed array of references (e.g. to functions) that could not
otherwise be stored as raw bytes in Memory (for safety and portability reasons)
#align(
  center, [#image("../../Screenshots/2023_12_27_03_34_03.png", width: 100%)],
)

#subsection("Instance")
```js
const importObject = {
imports: {
imported_func(arg) {
console.log("v1", arg);
},
},
};
const importObject2 = {
imports: {
imported_func(arg) {
console.log("v2", arg);
},
},
};
fetch("simple.wasm")
.then((response) => response.arrayBuffer())
.then((bytes) => {
const mod = new WebAssembly.Module(bytes); // module
const instance = new WebAssembly.Instance(mod, importObject); // first instance
instance.exports.exported_func();
const instance2 = new WebAssembly.Instance(mod, importObject2); // second instance
instance2.exports.exported_func();
});
```

#section("Blazor")
Basic blazor allows for server side rendering with client side rendering
features via sockets.
#align(
  center, [#image("../../Screenshots/2023_12_27_03_42_33.png", width: 100%)],
)
#align(
  center, [#image("../../Screenshots/2023_12_27_03_42_56.png", width: 100%)],
)

- server side rendering
