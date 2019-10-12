let headers = ["#include <lxccontainer.h>"]

let () =
  let c_out = open_out "lxc_c_ffi_ml_file_gen.c" in
  Fun.protect ~finally:(fun () -> close_out c_out)
    (fun () ->
       let c_fmt = Format.formatter_of_out_channel c_out in
       List.iter (fun h ->
           Format.fprintf c_fmt "%s\n" h
         ) headers;
       Cstubs_structs.write_c c_fmt (module Ffi_bindings.Bindings)
    )
