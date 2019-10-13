open Misc_utils
open Ctypes

type t = {lxc_container : Lxc_c.Stubs.lxc_container Ctypes.structure Ctypes.ptr}

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
