# ocaml-lxc
OCaml binding to LXC with idiomatic OCaml API design

## Documentation
WIP

## Examples

## Details
#### Index
You can see the index [here](doc/INDEX.md)

#### Technical details
They are available [here](doc/TECH.md)

#### Mapping from go-lxc
ocaml-lxc has roughly the same feature set as go-lxc, and fairly similar API design

If you are familiar with go-lxc and wonder how use of go-lxc translates over here,
you can see the documentation [here](doc/GO_LXC_COMPARISON.md)

## Acknowledgement
I'd like to thank the following people for their help
- [Stéphane Graber](https://github.com/stgraber) for answering my questions w.r.t. binding and design of go-lxc
- [Jeremy Yallop](https://github.com/yallop) for answering my questions w.r.t. Ctypes

I'd also like to thank the team behind [Cinaps](https://github.com/janestreet/cinaps) for the wonderful tool,
as this project is close to impossible without its assistance.
(There are 53 function pointer fields in `lxc_container` -
writing wrapper/glue code for each manually would be exceedingly tedious and error prone.)

## License
LGPL v2.1 as specified in the LICENSE file
