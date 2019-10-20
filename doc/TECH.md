## Overall technical description & design
Ctypes is used for stubs generation, and additional C "glue" code is used where necessary

The design of the high level exposed API (`Lxc`) is largely derived from
[go-lxc](https://github.com/lxc/go-lxc),
and utilise OCaml modules and types extensively to make semantics of returned value clear and
functions ergonomic to use

The low level internal API (`Lxc_c`) follows the LXC C API and added glue code closely

There are two C FFI code generation "backends" to allow `Lxc_c` module to access `lxc_container` function pointer fields
- "Wrapper" backend generates OCaml wrappers (which use Ctypes's `coerce`) in `src/lxc_c.ml` and access function pointer fields on OCaml side
- "Glue" backend generates C code in `code_gen/lxc_glue.c` which access function pointer fields on C side

The library uses the glue backend right now.
But since interface of `Lxc_c` remains unchanged between two backends, backend can always be changed easily.
This also means there should be no functional differences between the two backends.
