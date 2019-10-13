let gen_ffi_types_stubs () =
  let c_out = open_out "ffi_types_ml_stubs_gen.c" in
  let c_fmt = Format.formatter_of_out_channel c_out in
  Fun.protect
    ~finally:(fun () -> close_out c_out)
    (fun () ->
       let c_in = open_in "lxc_glue.c" in
       Fun.protect
         ~finally:(fun () -> close_in c_in)
         (fun () ->
            try
              while true do
                let line = input_line c_in in
                output_string c_out line; output_string c_out "\n"
              done
            with End_of_file -> ());
       Cstubs.Types.write_c c_fmt (module Ffi_types.Types_stubs))

let gen_ffi_binding_stubs () =
  begin
    let c_out = open_out "ffi_bindings_c_stubs.c" in
    let c_fmt = Format.formatter_of_out_channel c_out in
    Fun.protect
      ~finally:(fun () -> close_out c_out)
      (fun () ->
         Cstubs.write_c c_fmt ~prefix:"ffi_" (module Ffi_bindings.Fun_stubs)
      );
  end;
  begin
    let ml_out = open_out "ffi_bindings_ml_stubs.ml" in
    let ml_fmt = Format.formatter_of_out_channel ml_out in
    Fun.protect
      ~finally:(fun () -> close_out ml_out)
      (fun () ->
         Cstubs.write_ml ml_fmt ~prefix:"ffi_" (module Ffi_bindings.Fun_stubs);
      )
  end

let () = gen_ffi_types_stubs (); gen_ffi_binding_stubs ()
