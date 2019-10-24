# ocaml-lxc

[![Build Status](https://travis-ci.org/darrenldl/ocaml-lxc.svg?branch=master)](https://travis-ci.org/darrenldl/ocaml-lxc)

[Documentation](https://darrenldl.github.io/ocaml-lxc/)

OCaml binding to LXC with idiomatic (and opionated) OCaml API design

**Warning**: This is still WIP, do **NOT** use it for anything serious yet

## Notes
Huge portion of high level design of ocaml-lxc is derived from [go-lxc](https://github.com/lxc/go-lxc)
with adjustments to be closer to (hopefully) idomatic OCaml

The following elements are also derived/copied from go-lxc
- Code for conditional compilation (see `code_gen/lxc_glue.c` and `code_gen/lxc_glue.h`) for adapting to different LXC versions
- Large portion of the test suite (i.e. `tests/*`)

## TODO
- Add test code (copy go-lxc's test suite)
- Add examples
- API documentation
- Document build flow architecture (specifically how dune fits into it maybe)
- Document code architecture

## Examples
Following replicates the C example listed on
[linuxcontainers.org](https://linuxcontainers.org/lxc/documentation/). It is also available as a file [here](examples/main_demo.ml)

Also see [here](examples/) for other examples

**Note**: The following example is very roughly written and can definitely be improved. Feel free to contribute.

```ocaml
let clean_up_and_exit c =
  Option.iter (fun c -> Lxc.release c |> Result.get_ok) c;
  exit 1

let () =
  let c =
    match Lxc.new_container "apicontainer" with
    | Ok c ->
      c
    | Error _ ->
      Printf.eprintf "Failed to setup lxc_container\n";
      clean_up_and_exit None
  in
  if Lxc.Container.is_defined c then (
    Printf.eprintf "Container already exists\n";
    clean_up_and_exit (Some c) );
  (* Create the container *)
  let create_options =
    { Lxc.Create_options.blank with
      template = Some "download"
    ; distro = Some "ubuntu"
    ; release = Some "trusty"
    ; arch = Some "i386" }
  in
  Lxc.Container.create c create_options
  |> Result.iter_error (fun _ ->
      Printf.eprintf "Failed to create container rootfs\n";
      clean_up_and_exit (Some c));
  (* Start the container *)
  Lxc.Container.start c
  |> Result.iter_error (fun _ ->
      Printf.eprintf "Failed to start container rootfs\n";
      clean_up_and_exit (Some c));
  (* Query some information *)
  Printf.printf "Container state: %s\n"
    (Lxc.Container.state c |> Lxc.State.to_string);
  Printf.printf "Container PID: %d\n" (Lxc.Container.init_pid c);
  (* Stop the container *)
  Lxc.Container.shutdown c ~timeout:30
  |> Result.iter_error (fun _ ->
      Printf.printf "Failed to cleanly shutdown the container, forcing\n";
      Lxc.Container.stop c
      |> Result.iter_error (fun _ ->
          Printf.eprintf "Failed to kill the container\n";
          clean_up_and_exit (Some c)));
  (* Destroy the container *)
  Lxc.Container.destroy c
  |> Result.iter_error (fun _ ->
      Printf.eprintf "Failed to destroy the container\n";
      clean_up_and_exit (Some c))
```

## Contribution
Contributions are welcome. Note that by submitting contributions, you agree to license your work under the same license used by this project as stated in the LICENSE file.

#### Cinaps
Cinaps is used heavily in this project, please make sure your modifications are not overwritten by `make cinaps`

To do so, commit your changes (or save your changes outside of the repo in some way to avoid losing progress),
then run `make cinaps` and check if any of your modification was overwritten

#### Formatting
This project uses ocamlformat and ocp-indent for formatting OCaml code, and clang-format for formatting C code
- If your modification involves OCaml code, please make sure you have ocamlformat and ocp-indent, then run `make format` before submitting your work
- If your modification involves C code, please make sure you have clang-format, then run `make format_c` before submitting your work

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
    - There are roughly 53 function pointer fields in `lxc_container` - writing wrapper/glue code for each manually would be exceedingly tedious and error prone

## License
LGPL v2.1 as specified in the LICENSE file
