open Ctypes
open Misc_utils
  module L = Stubs.Type_stubs.Lxc_snapshot

type t = {
  name : string;
  comment_path_name : string;
  timestamp : string;
  lxcpath : string;
}

type c_struct = Types.Lxc_snapshot.t structure

let free c_struct_ptr =
  let c_field = getf !@(c_struct_ptr) L.free in
  let f =
    coerce
      (static_funptr (ptr L.t @-> returning void))
      (Foreign.funptr (ptr L.t @-> returning void))
      c_field
  in
  f c_struct_ptr

let t_of_c_struct_ptr c_struct_ptr =
  let finaliser = (fun () ->
      free c_struct_ptr
    )
  in
  let name = getf !@c_struct_ptr L.name in
  let comment_path_name = getf !@c_struct_ptr L.comment_pathname in
  let timestamp = getf !@c_struct_ptr L.timestamp in
  let lxcpath = getf !@c_struct_ptr L.lxcpath in
  let ret = {
    name; comment_path_name; timestamp; lxcpath
  } in
  Gc.finalise_last finaliser ret;
  ret
