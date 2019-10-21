open Ctypes
open Misc_utils
module L = Stubs.Type_stubs.Lxc_console_log

type c_struct = Types.Lxc_console_log.t structure

module Options = struct
  type t =
    { clear : bool
    ; read : bool
    ; read_max : int64 }
end

let c_struct_of_options (t : Options.t) =
  let c_struct = Ctypes.make Types.Lxc_console_log.t in
  setf c_struct L.clear t.clear;
  setf c_struct L.read t.read;
  setf c_struct L.read_max
    (allocate uint64_t (Unsigned.UInt64.of_int64 t.read_max));
  setf c_struct L.data (make_null_ptr (ptr char));
  c_struct

let result_of_c_struct c_struct_ptr =
  let read_max_ptr = getf !@c_struct_ptr L.read_max in
  let len_read = !@read_max_ptr |> Unsigned.UInt64.to_int in
  if len_read = 0 then ""
  else
    let data =
      getf !@c_struct_ptr L.data |> string_from_ptr ~length:len_read
    in
    data
