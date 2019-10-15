open Misc_utils
open Ctypes
module Bigstring = Core.Bigstring

type t = {lxc_container : Types.lxc_container Ctypes.structure Ctypes.ptr}

let free = Stubs.Fun_stubs.free

let strlen ptr =
  let len = Stubs.Fun_stubs.strlen ptr in
  coerce long int len

let new_container ~name ~config_path =
  match Lxc_c.lxc_container_new name config_path with
  | None ->
    Error ()
  | Some lxc_container ->
    Ok {lxc_container}

let acquire t =
  Lxc_c.lxc_container_get t.lxc_container |> int_to_bool |> bool_to_unit_result

let release t =
  Lxc_c.lxc_container_put t.lxc_container |> int_to_bool |> bool_to_unit_result

let get_global_config_item ~key =
  let ret_ptr = Lxc_c.lxc_get_global_config_item key in
  let length = strlen ret_ptr in
  let str = string_from_ptr ret_ptr ~length in
  free ret_ptr; str

let get_version () = Lxc_c.lxc_get_version ()

module Container = struct end
