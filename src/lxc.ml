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

let new_container ~name ~lxcpath =
  match C.lxc_container_new name lxcpath with
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

(*$
     List.iter
       (fun name ->
          Printf.printf "let %s_names ~(lxcpath : string option) =\n" name;
          Printf.printf "  let name_arr_typ = ptr (ptr char) in\n";
          Printf.printf
            "  let struct_arr_ptr_typ = ptr (ptr Types.lxc_container) in\n";
          Printf.printf
            "  let name_arr_ptr = Helpers.allocate_ptr_init_to_null name_arr_typ in";
          Printf.printf
            "  let struct_arr_ptr_null = Helpers.make_null_ptr (ptr \
             struct_arr_ptr_typ) in\n";
          Printf.printf "  let count =\n";
          Printf.printf "    C.%ss lxcpath name_arr_ptr struct_arr_ptr_null in\n"
            name;
          Printf.printf
            "  let ret = Helpers.string_list_from_string_ptr_arr_ptr name_arr_ptr \
             ~count in\n";
          Printf.printf "  Helpers.free (ptr name_arr_typ) name_arr_ptr;\n";
          Printf.printf "  ret\n")
       ["list_defined_container"; "list_active_container"; "list_all_container"]
*)

let list_defined_container_names ~(lxcpath : string option) =
  let name_arr_typ = ptr (ptr char) in
  let struct_arr_ptr_typ = ptr (ptr Types.lxc_container) in
  let name_arr_ptr = Helpers.allocate_ptr_init_to_null name_arr_typ in
  let struct_arr_ptr_null = Helpers.make_null_ptr (ptr struct_arr_ptr_typ) in
  let count =
    C.list_defined_containers lxcpath name_arr_ptr struct_arr_ptr_null
  in
  let ret = Helpers.string_list_from_string_ptr_arr_ptr name_arr_ptr ~count in
  Helpers.free (ptr name_arr_typ) name_arr_ptr;
  ret

let list_active_container_names ~(lxcpath : string option) =
  let name_arr_typ = ptr (ptr char) in
  let struct_arr_ptr_typ = ptr (ptr Types.lxc_container) in
  let name_arr_ptr = Helpers.allocate_ptr_init_to_null name_arr_typ in
  let struct_arr_ptr_null = Helpers.make_null_ptr (ptr struct_arr_ptr_typ) in
  let count =
    C.list_active_containers lxcpath name_arr_ptr struct_arr_ptr_null
  in
  let ret = Helpers.string_list_from_string_ptr_arr_ptr name_arr_ptr ~count in
  Helpers.free (ptr name_arr_typ) name_arr_ptr;
  ret

let list_all_container_names ~(lxcpath : string option) =
  let name_arr_typ = ptr (ptr char) in
  let struct_arr_ptr_typ = ptr (ptr Types.lxc_container) in
  let name_arr_ptr = Helpers.allocate_ptr_init_to_null name_arr_typ in
  let struct_arr_ptr_null = Helpers.make_null_ptr (ptr struct_arr_ptr_typ) in
  let count = C.list_all_containers lxcpath name_arr_ptr struct_arr_ptr_null in
  let ret = Helpers.string_list_from_string_ptr_arr_ptr name_arr_ptr ~count in
  Helpers.free (ptr name_arr_typ) name_arr_ptr;
  ret

  (*$*)

let list_defined_containers ~lxcpath =
  let names = list_defined_container_names ~lxcpath in
  List.map (fun name -> new_container ~name ~lxcpath) names

module Container = struct end
