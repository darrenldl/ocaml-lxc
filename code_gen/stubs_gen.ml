(* let write_glue_c c_out =
 *   let c_in = open_in "lxc_glue.h" in
 *   Fun.protect
 *     ~finally:(fun () -> close_in c_in)
 *     (fun () ->
 *        try
 *          while true do
 *            let line = input_line c_in in
 *            output_string c_out line; output_string c_out "\n"
 *          done
 *        with End_of_file -> ()) *)

let headers =
  [ (* "#include <lxc/lxccontainer.h>"; *)
    (* "#include <lxc/attach_options.h>"; *)
    "#include <string.h>"
  ; "#include \"lxc_glue.h\"" ]

let write_headers c_out =
  List.iter (fun s -> output_string c_out s; output_string c_out "\n") headers

let gen_ffi_types_stubs () =
  let c_out = open_out "ffi_types_ml_stubs_gen.c" in
  let c_fmt = Format.formatter_of_out_channel c_out in
  Fun.protect
    ~finally:(fun () -> close_out c_out)
    (fun () ->
       write_headers c_out;
       (* write_glue_c c_out; *)
       Cstubs_structs.write_c c_fmt (module Ffi_types.Types_stubs))

let gen_ffi_binding_stubs () =
  (let c_out = open_out "ffi_bindings_c_stubs.c" in
   let c_fmt = Format.formatter_of_out_channel c_out in
   Fun.protect
     ~finally:(fun () -> close_out c_out)
     (fun () ->
        write_headers c_out;
        (* write_glue_c c_out; *)
        Cstubs.write_c c_fmt ~prefix:"ffi_" (module Ffi_bindings.Fun_stubs)));
  let ml_out = open_out "ffi_bindings_ml_stubs.ml" in
  let ml_fmt = Format.formatter_of_out_channel ml_out in
  Fun.protect
    ~finally:(fun () -> close_out ml_out)
    (fun () ->
       Cstubs.write_ml ml_fmt ~prefix:"ffi_" (module Ffi_bindings.Fun_stubs))

let () = gen_ffi_types_stubs (); gen_ffi_binding_stubs ()
