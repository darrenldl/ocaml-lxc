# ocaml-lxc
OCaml binding to LXC with idiomatic OCaml error handling

## Description
This library aims to provide 100% coverage of LXC C API

Ctypes is used for stubs generation, and additional C "glue" code is used where necessary

## Design
The high level exposed API follows the design of go-lxc and python-lxc roughly,
and utilise OCaml types extensively to make semantics of returned value clear and
allow better error handling

The low level internal API follows the C API closely

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
I'd like to thank [Stéphane Graber](https://github.com/stgraber) for answering my questions w.r.t. binding and design of go-lxc

## License
LGPL v2.1 as specified in the LICENSE file
