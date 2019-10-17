open Misc_utils
open Ctypes
module Bigstring = Core.Bigstring

type container =
  {lxc_container : Types.lxc_container Ctypes.structure Ctypes.ptr}

module Helpers = struct
  let free = Stubs.Fun_stubs.free

  let strlen ptr =
    let len = Stubs.Fun_stubs.strlen ptr in
    coerce long int len

  let string_from_string_ptr (ptr : char ptr) =
    let length = strlen ptr in
    string_from_ptr ptr ~length

  let bigstring_from_string_ptr ptr : Bigstring.t =
    let length = strlen ptr in
    bigarray_of_ptr array1 length Bigarray.Char ptr

  let string_list_from_string_ptr_arr_ptr (ptr : char ptr ptr ptr)
      ~(count : int) =
    assert (count >= 0);
    CArray.from_ptr ptr count |> CArray.to_list
    |> List.map (fun ptr -> string_from_string_ptr !@ptr)
end

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
  let str = Helpers.string_from_string_ptr ret_ptr in
  Helpers.free ret_ptr; str

let get_version () = Lxc_c.lxc_get_version ()

(*$
     List.iter
       (fun name ->
          Printf.printf "let %s_names ~(lxcpath : string) =\n" name;
          Printf.printf "  let name_arr_ptr_typ = ptr (ptr char) in\n";
          Printf.printf
            "  let name_arr_ptr_init = coerce (ptr void) name_arr_ptr_typ null in\n";
          Printf.printf
            "  let struct_arr_ptr_typ = ptr (ptr Types.lxc_container) in\n";
          Printf.printf
            "  let name_arr_ptr = allocate name_arr_ptr_typ name_arr_ptr_init in";
          Printf.printf
            "  let struct_arr_ptr_null = coerce (ptr void) (ptr \
             struct_arr_ptr_typ) null in\n";
          Printf.printf "  let count =\n";
          Printf.printf
            "    Lxc_c.%ss lxcpath name_arr_ptr struct_arr_ptr_null in\n" name;
          Printf.printf
            "  Helpers.string_list_from_string_ptr_arr_ptr name_arr_ptr ~count\n")
       ["list_defined_container"; "list_active_container"; "list_all_container"]
*)

let list_defined_container_names ~(lxcpath : string) =
  let name_arr_ptr_typ = ptr (ptr char) in
  let name_arr_ptr_init = coerce (ptr void) name_arr_ptr_typ null in
  let struct_arr_ptr_typ = ptr (ptr Types.lxc_container) in
  let name_arr_ptr = allocate name_arr_ptr_typ name_arr_ptr_init in
  let struct_arr_ptr_null = coerce (ptr void) (ptr struct_arr_ptr_typ) null in
  let count =
    Lxc_c.list_defined_containers lxcpath name_arr_ptr struct_arr_ptr_null
  in
  Helpers.string_list_from_string_ptr_arr_ptr name_arr_ptr ~count

let list_active_container_names ~(lxcpath : string) =
  let name_arr_ptr_typ = ptr (ptr char) in
  let name_arr_ptr_init = coerce (ptr void) name_arr_ptr_typ null in
  let struct_arr_ptr_typ = ptr (ptr Types.lxc_container) in
  let name_arr_ptr = allocate name_arr_ptr_typ name_arr_ptr_init in
  let struct_arr_ptr_null = coerce (ptr void) (ptr struct_arr_ptr_typ) null in
  let count =
    Lxc_c.list_active_containers lxcpath name_arr_ptr struct_arr_ptr_null
  in
  Helpers.string_list_from_string_ptr_arr_ptr name_arr_ptr ~count

let list_all_container_names ~(lxcpath : string) =
  let name_arr_ptr_typ = ptr (ptr char) in
  let name_arr_ptr_init = coerce (ptr void) name_arr_ptr_typ null in
  let struct_arr_ptr_typ = ptr (ptr Types.lxc_container) in
  let name_arr_ptr = allocate name_arr_ptr_typ name_arr_ptr_init in
  let struct_arr_ptr_null = coerce (ptr void) (ptr struct_arr_ptr_typ) null in
  let count =
    Lxc_c.list_all_containers lxcpath name_arr_ptr struct_arr_ptr_null
  in
  Helpers.string_list_from_string_ptr_arr_ptr name_arr_ptr ~count

  (*$*)
module Container = struct end
