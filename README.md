# ocaml-lxc
OCaml binding to LXC with idiomatic OCaml error handling

## Description
This library aims to provide 100% coverage of LXC C API

Ctypes is used for stubs generation, and additional C "glue" code is used where necessary

The high level exposed API follows the design of go-lxc and python-lxc roughly,
and utilise OCaml types extensively to make semantics of returned value clear and
allow better error handling

The low level internal API (`lxc.ml`, `lxc.mli`) follows the C API closely

## License
LGPL v2.1 as specified in the LICENSE file
