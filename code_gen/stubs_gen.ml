let gen_ffi_types_stubs () =
  let c_out = open_out "ffi_types_ml_stubs_gen.c" in
  let c_fmt = Format.formatter_of_out_channel c_out in
  let c_in = open_in "lxc_glue.c" in
  Fun.protect
    ~finally:(fun () ->  close_out c_out ;close_in c_in)
    (fun () ->
       try
         while true do
           let line = input_line c_in in
           output_string c_out line; output_string c_out "\n"
         done
       with End_of_file -> ();
         Cstubs.Types.write_c c_fmt (module Ffi_types.Types_stubs)
    )

(* let gen_ffi_binding_stubs =
 *   let c_out = open_out "ffi_bindings.c" in
 *   let c_fmt = Format.formatter_of_out_channel c_out in
 *   let ml_out = open_out "ffi_bindings.ml" in
 *   Fun.protect
 *     ~finally:(fun () -> close_out c_out)
 *     (fun () ->
 *     ) *)

let () = gen_ffi_types_stubs ()
