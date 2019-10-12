let headers = ["#include <lxc/lxccontainer.h>"]

let () =
  let c_out = stdout in
  let c_fmt = Format.formatter_of_out_channel c_out in
  List.iter (fun h ->
      Format.fprintf c_fmt "%s\n" h
    ) headers;
  Cstubs_structs.write_c c_fmt (module Ffi_bindings.Bindings)
