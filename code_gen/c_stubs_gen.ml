let () =
  let c_out = stdout in
  let c_fmt = Format.formatter_of_out_channel c_out in
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
  Cstubs_structs.write_c c_fmt (module Ffi_bindings.Stubs)
