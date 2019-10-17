open Misc_utils
open Ctypes
module Bigstring = Core.Bigstring
module C = Lxc_c

type container =
  {lxc_container : Types.lxc_container Ctypes.structure Ctypes.ptr}

module Helpers = struct
  let free (typ : 'aa ptr typ) ret_ptr =
    let ret_ptr = coerce typ (ptr char) ret_ptr in
    Stubs.Fun_stubs.free ret_ptr

  let free_char_ptr ret_ptr = free (ptr char) ret_ptr

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

  let make_null_ptr typ = coerce (ptr void) typ null

  let allocate_ptr_init_to_null typ = allocate typ (make_null_ptr typ)
end

let new_container ?config_path ~name =
  match C.lxc_container_new name config_path with
  | None ->
    Error ()
  | Some lxc_container ->
    Ok {lxc_container}

let acquire t =
  C.lxc_container_get t.lxc_container |> int_to_bool |> bool_to_unit_result

let release t =
  match C.lxc_container_put t.lxc_container with
  | 0 ->
    Ok ()
  | 1 ->
    Ok ()
  | -1 ->
    Error ()
  | _ ->
    raise C.Unexpected_value_from_C

let get_global_config_item ~key =
  let ret_ptr = C.lxc_get_global_config_item key in
  let str = Helpers.string_from_string_ptr ret_ptr in
  Helpers.free_char_ptr ret_ptr;
  str

let get_version () = C.lxc_get_version ()

let list_container_names_internal f ~(lxcpath : string option) =
  let name_arr_typ = ptr (ptr char) in
  let name_arr_ptr = Helpers.allocate_ptr_init_to_null name_arr_typ in
  let struct_ptr_arr_typ = ptr (ptr Types.lxc_container) in
  let struct_ptr_arr_ptr_null =
    Helpers.make_null_ptr (ptr struct_ptr_arr_typ)
  in
  let count = f lxcpath name_arr_ptr struct_ptr_arr_ptr_null in
  let ret = Helpers.string_list_from_string_ptr_arr_ptr name_arr_ptr ~count in
  Helpers.free (ptr name_arr_typ) name_arr_ptr;
  ret

(*$
     List.iter
       (fun tag ->
          Printf.printf
            "let list_%s_container_names ?(lxcpath : string option) () =\n" tag;
          Printf.printf
            "  list_container_names_internal C.list_%s_containers ~lxcpath\n" tag)
       ["defined"; "active"; "all"]
*)

let list_defined_container_names ?(lxcpath : string option) () =
  list_container_names_internal C.list_defined_containers ~lxcpath

let list_active_container_names ?(lxcpath : string option) () =
  list_container_names_internal C.list_active_containers ~lxcpath

let list_all_container_names ?(lxcpath : string option) () =
  list_container_names_internal C.list_all_containers ~lxcpath

  (*$*)

let list_containers_internal f ~(lxcpath : string option) =
  let name_arr_typ = ptr (ptr char) in
  let name_arr_ptr = Helpers.allocate_ptr_init_to_null name_arr_typ in
  let struct_ptr_arr_typ = ptr (ptr Types.lxc_container) in
  let struct_ptr_arr_ptr =
    Helpers.allocate_ptr_init_to_null struct_ptr_arr_typ
  in
  let count =
    C.list_defined_containers lxcpath name_arr_ptr struct_ptr_arr_ptr
  in
  let names =
    Helpers.string_list_from_string_ptr_arr_ptr name_arr_ptr ~count
  in
  let struct_ptr_list =
    CArray.from_ptr struct_ptr_arr_ptr count |> CArray.to_list
  in
  let containers =
    List.map (fun ptr -> {lxc_container = !@ptr}) struct_ptr_list
  in
  Helpers.free (ptr name_arr_typ) name_arr_ptr;
  Helpers.free (ptr struct_ptr_arr_typ) struct_ptr_arr_ptr;
  List.combine names containers

(*$
     List.iter
       (fun tag ->
          Printf.printf "let list_%s_containers ?(lxcpath : string option) () =\n"
            tag;
          Printf.printf
            "  list_containers_internal C.list_%s_containers ~lxcpath\n" tag)
       ["defined"; "active"; "all"]
*)

let list_defined_containers ?(lxcpath : string option) () =
  list_containers_internal C.list_defined_containers ~lxcpath

let list_active_containers ?(lxcpath : string option) () =
  list_containers_internal C.list_active_containers ~lxcpath

let list_all_containers ?(lxcpath : string option) () =
  list_containers_internal C.list_all_containers ~lxcpath

  (*$*)

let config_item_is_supported key = C.lxc_config_item_is_supported key

module Container = struct end
