# ocaml-lxc
OCaml binding to LXC with idiomatic OCaml error handling

## Technical description & design
Ctypes is used for stubs generation, and additional C "glue" code is used where necessary

The design of the high level exposed API (`Lxc`) is largely derived from
[go-lxc](https://github.com/lxc/go-lxc),
and utilise OCaml types extensively to make semantics of returned value clear and
allow better error handling

The low level internal API (`Lxc_c`) follows the LXC C API and added glue code closely

There are two C FFI code generation "backends" to allow `Lxc_c` module to access `lxc_container` function pointer fields
- "Wrapper" backend generates OCaml wrappers (which use Ctypes's `coerce`) in `src/lxc_c.ml` and access function pointer fields on OCaml side
- "Glue" backend generates C code in `code_gen/lxc_glue.c` which access function pointer fields on C side

The library uses the glue backend right now

But since interface of `Lxc_c` remains unchanged between two backends, backend can always be changed easily.
This also means there should be no functional differences between the two backends.

## Index
- `code_gen/`
    - `ffi_bindings.ml`
        - FFI bindings to C functions
    - `ffi_types.ml`
        - FFI bindings to C types
    - `gen.cinaps`
        - Main cinaps code for code generation
    - `lxc_glue.c`, `lxc_glue.h`
        - C "glue" code for working around things not supported by Ctypes like anonymous structs
    - `stubs_gen.ml`
        - Main stubs generator code
    - `types.ml`
        - Top level C types declaration, shared by `ffi_bindings.ml`, `ffi_types.ml` and other files
- `lxc_files/`
    - Copies of files from LXC project, used only as reference during development
- `src/`
    - `lxc.ml`, `lxc.mli`
        - High level API
    - `lxc_c.ml`, `lxc_c.mli`
        - Low level internal API
    - `misc_utils.ml`
        - miscellaneous helper functions
    - `stubs.ml`
        - Central module for importing of FFI stubs

## Acknowledgement
I'd like to thank the following people for their help
- [Stéphane Graber](https://github.com/stgraber) for answering my questions w.r.t. binding and design of go-lxc [here](https://discuss.linuxcontainers.org/t/creating-an-ocaml-binding-to-lxc-seeking-advice-on-api-design/5929)
- [Jeremy Yallop](https://github.com/yallop) for answering my questions w.r.t. Ctypes [here](https://discuss.ocaml.org/t/questions-about-ctypes-funptr-and-const-pointer/4534)

## License
LGPL v2.1 as specified in the LICENSE file
