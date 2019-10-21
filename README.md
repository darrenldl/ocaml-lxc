# ocaml-lxc
OCaml binding to LXC with idiomatic OCaml API design

**Warning**: This is still WIP, do **NOT** use it for anything serious yet

## TODO
- Test code
- API documentation + Travis CI doc build for master
- Document build flow architecture (specifically how dune fits into it maybe)
- Document code architecture

## Documentation
WIP

## Examples
WIP

## Details
#### Index
See [here](doc/INDEX.md)

#### Technical details
See [here](doc/TECH.md)

The documentation includes following aspects and is mainly useful for people looking for a case study/example
- Using cinaps for both OCaml and C code and remain consistent
- Workflow of stubs generation for C types and functions, and tying them together in dune

#### Mapping from go-lxc
ocaml-lxc has roughly the same feature set as go-lxc, and fairly similar API design

If you are familiar with go-lxc and wonder how use of go-lxc translates over here,
you can see the documentation [here](doc/GO_LXC_COMPARISON.md)

## Acknowledgement

#### People
I'd like to thank the following people for their help
- [Stéphane Graber](https://github.com/stgraber) for answering my questions w.r.t. binding and design of go-lxc
- [Jeremy Yallop](https://github.com/yallop) for answering my questions w.r.t. Ctypes

#### Project teams
This library is made possible by various projects,
so following list is not exhaustive in whom I'd like to thank overall.
But I'd like to thank the teams behind the following two projects here due to the extensive use of them in this library.

- [Ctypes](https://github.com/ocamllabs/ocaml-ctypes)
    - Incredibly nice and powerful C FFI library to use, (obviously) crucial to this library
- [Cinaps](https://github.com/janestreet/cinaps)
    - There are 53 function pointer fields in `lxc_container` - writing wrapper/glue code for each manually would be exceedingly tedious and error prone

## License
LGPL v2.1 as specified in the LICENSE file
