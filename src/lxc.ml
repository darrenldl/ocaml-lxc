open Misc_utils
open Ctypes
module Bigstring = Core.Bigstring
module C = Lxc_c

type container =
  {lxc_container : Types.lxc_container Ctypes.structure Ctypes.ptr}

module Helpers = struct
  let free_ptr (typ : 'a ptr typ) ret_ptr =
    let ret_ptr = coerce typ (ptr char) ret_ptr in
    Stubs.Fun_stubs.free ret_ptr

  let free_char_ptr ret_ptr = free_ptr (ptr char) ret_ptr

  let strlen ptr =
    let len = Stubs.Fun_stubs.strlen ptr in
    coerce long int len

  let elements_from_null_term_ptr (ptr : 'a ptr) : 'a list =
    let rec aux acc ptr =
      if is_null ptr then List.rev acc else aux (!@ptr :: acc) (ptr +@ 1)
    in
    aux [] ptr

  let string_from_string_ptr ?(free = false) (ptr : char ptr) =
    let length = strlen ptr in
    let ret = string_from_ptr ptr ~length in
    if free then free_char_ptr ptr;
    ret

  let string_from_carray (arr : char CArray.t) =
    string_from_string_ptr (CArray.start arr)

  let bigstring_from_string_ptr ptr : Bigstring.t =
    let length = strlen ptr in
    bigarray_of_ptr array1 length Bigarray.Char ptr

  let string_list_from_string_ptr_arr_ptr (p : char ptr ptr ptr)
      ?(free = false) ~(count : int) =
    assert (count >= 0);
    let ret =
      CArray.from_ptr p count |> CArray.to_list
      |> List.map (fun ptr -> string_from_string_ptr ~free !@ptr)
    in
    if free then free_ptr (ptr (ptr (ptr char))) p;
    ret

  let string_list_from_string_ptr_null_term_arr_ptr ?(free = false)
      (p : char ptr ptr ptr) =
    let ret =
      elements_from_null_term_ptr p
      |> List.map (fun p -> string_from_string_ptr !@p)
    in
    if free then free_ptr (ptr (ptr (ptr char))) p;
    ret

  let string_list_from_string_null_term_arr_ptr ?(free = false)
      (p : char ptr ptr) =
    let ret =
      elements_from_null_term_ptr p
      |> List.map (fun p -> string_from_string_ptr p)
    in
    if free then free_ptr (ptr (ptr char)) p;
    ret

  let make_null_ptr typ = coerce (ptr void) typ null

  let allocate_ptr_init_to_null typ = allocate typ (make_null_ptr typ)

  let string_carray_from_string_list l =
    l
    |> List.map (fun s -> s |> CArray.of_string |> CArray.start)
    |> CArray.of_list (ptr char)

  let string_arr_ptr_from_string_list l =
    l |> string_carray_from_string_list |> CArray.start

  let string_carray_from_string_arr arr =
    string_carray_from_string_list (Array.to_list arr)

  let string_arr_ptr_from_string_arr arr =
    string_arr_ptr_from_string_list (Array.to_list arr)
end

module Bdev_specs__glue = struct
  module B = Stubs.Type_stubs.Bdev_specs__glue
  open B

  module Zfs__glue = struct
    let make ~zfsroot =
      let zfs = Ctypes.make Zfs__glue.t in
      setf zfs Zfs__glue.zfsroot zfsroot;
      zfs
  end

  module Lvm__glue = struct
    let make ~vg ~lv ~thinpool =
      let lvm = Ctypes.make Lvm__glue.t in
      setf lvm Lvm__glue.vg vg;
      setf lvm Lvm__glue.lv lv;
      setf lvm Lvm__glue.thinpool thinpool;
      lvm
  end

  module Rbd__glue = struct
    let make ~rbdname ~rbdpool =
      let rbd = Ctypes.make Rbd__glue.t in
      setf rbd Rbd__glue.rbdname rbdname;
      setf rbd Rbd__glue.rbdpool rbdpool;
      rbd
  end

  (* let make ~fstype ~fssize ~zfs ~lvm ~dir =
   *   let t = Ctypes.make t in
   *   setf t B.fstype fstype;
   *   setf t B.fssize (Unsigned.UInt64.of_int64 fssize); *)
end

let new_container ?config_path ~name =
  match C.lxc_container_new name config_path with
  | None ->
    Error ()
  | Some lxc_container ->
    Ok {lxc_container}

let acquire t =
  C.lxc_container_get t.lxc_container
  |> int_to_bool |> bool_to_unit_result_true_is_ok

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
  C.lxc_get_global_config_item key |> Helpers.string_from_string_ptr ~free:true

let get_version () = C.lxc_get_version ()

let list_container_names_internal f ~(lxcpath : string option) =
  let name_arr_typ = ptr (ptr char) in
  let name_arr_ptr = Helpers.allocate_ptr_init_to_null name_arr_typ in
  let struct_ptr_arr_typ = ptr (ptr Types.lxc_container) in
  let struct_ptr_arr_ptr_null =
    Helpers.make_null_ptr (ptr struct_ptr_arr_typ)
  in
  let count = f lxcpath name_arr_ptr struct_ptr_arr_ptr_null in
  let ret =
    Helpers.string_list_from_string_ptr_arr_ptr name_arr_ptr ~free:true ~count
  in
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
  let count = f lxcpath name_arr_ptr struct_ptr_arr_ptr in
  let names =
    Helpers.string_list_from_string_ptr_arr_ptr name_arr_ptr ~free:true ~count
  in
  let struct_ptr_list =
    CArray.from_ptr struct_ptr_arr_ptr count |> CArray.to_list
  in
  let containers =
    List.map (fun ptr -> {lxc_container = !@ptr}) struct_ptr_list
  in
  Helpers.free_ptr (ptr struct_ptr_arr_typ) struct_ptr_arr_ptr;
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

let config_item_is_supported s = C.lxc_config_item_is_supported s

let has_api_extension s = C.lxc_has_api_extension s

module Container = struct
  let is_defined c = C.is_defined c.lxc_container

  let state c = C.state c.lxc_container |> Option.get |> C.State.of_string

  let is_running c = C.is_running c.lxc_container

  let freeze c = C.freeze c.lxc_container |> bool_to_unit_result_true_is_ok

  let unfreeze c = C.unfreeze c.lxc_container |> bool_to_unit_result_true_is_ok

  let init_pid c = C.init_pid c.lxc_container

  let load_config ?alt_file c =
    C.load_config c.lxc_container alt_file |> bool_to_unit_result_true_is_ok

  let start c ~use_init ~argv =
    C.start c.lxc_container (bool_to_int use_init)
      (Helpers.string_arr_ptr_from_string_arr argv)
    |> bool_to_unit_result_true_is_ok

  let stop c = C.stop c.lxc_container |> bool_to_unit_result_true_is_ok

  let want_daemonize c (want : [`Yes | `No]) =
    C.want_daemonize c.lxc_container (want_to_bool want)
    |> bool_to_unit_result_true_is_ok

  let want_close_all_fds c (want : [`Yes | `No]) =
    C.want_close_all_fds c.lxc_container (want_to_bool want)
    |> bool_to_unit_result_true_is_ok

  let config_file_name c =
    let ret_ptr = C.config_file_name c.lxc_container in
    let ret = Helpers.string_from_string_ptr ret_ptr in
    Helpers.free_char_ptr ret_ptr;
    ret

  let wait c state =
    let state = Some (C.State.to_string state) in
    C.wait c.lxc_container state

  let set_config_item c ~key ~value =
    C.set_config_item c.lxc_container (Some key) (Some value)

  let destroy c = C.destroy c.lxc_container

  let save_config ~alt_file c = C.save_config c.lxc_container (Some alt_file)

  let create c ?(template = "download") =
    C.create__glue c.lxc_container template None None 0
      (Helpers.make_null_ptr (ptr (ptr char)))
    |> bool_to_unit_result_true_is_ok

  let rename c ~new_name =
    C.rename c.lxc_container new_name |> bool_to_unit_result_true_is_ok

  let reboot c = C.reboot c.lxc_container |> bool_to_unit_result_true_is_ok

  let shutdown c ~timeout =
    C.shutdown c.lxc_container timeout |> bool_to_unit_result_true_is_ok

  let clear_config c = C.clear_config c.lxc_container

  let clear_config_item c ~key =
    C.clear_config_item c.lxc_container key |> bool_to_unit_result_true_is_ok

  let get_config_item c ~key =
    let len =
      C.get_config_item c.lxc_container key
        (Helpers.make_null_ptr (ptr char))
        0
    in
    let ret = CArray.make char len in
    let new_len =
      C.get_config_item c.lxc_container key (CArray.start ret) len
    in
    if len <> new_len then raise C.Unexpected_value_from_C;
    Helpers.string_from_carray ret

  let get_running_config_item c ~key =
    let ret_ptr = C.get_running_config_item c.lxc_container key in
    Helpers.string_from_string_ptr ~free:true ret_ptr

  let get_keys c ~prefix =
    let len =
      C.get_keys c.lxc_container prefix (Helpers.make_null_ptr (ptr char)) 0
    in
    let ret = CArray.make char len in
    let new_len = C.get_keys c.lxc_container prefix (CArray.start ret) len in
    if len <> new_len then raise C.Unexpected_value_from_C;
    Helpers.string_from_carray ret
    |> String.split_on_char '\n'
    |> List.filter (fun s -> s <> "")

  let get_interfaces c =
    let ret_ptr = C.get_interfaces c.lxc_container in
    if is_null ret_ptr then Error ()
    else
      let strings =
        Helpers.string_list_from_string_null_term_arr_ptr ~free:true ret_ptr
      in
      Ok strings

  let get_ips c ~interface ~family ~scope =
    let ret_ptr =
      C.get_ips c.lxc_container (Some interface) (Some family) scope
    in
    if is_null ret_ptr then Error ()
    else
      let strings =
        Helpers.string_list_from_string_null_term_arr_ptr ~free:true ret_ptr
      in
      Ok strings

  let get_cgroup_item c ~subsys =
    let len =
      C.get_cgroup_item c.lxc_container subsys
        (Helpers.make_null_ptr (ptr char))
        0
    in
    let ret = CArray.make char len in
    let new_len =
      C.get_cgroup_item c.lxc_container subsys (CArray.start ret) len
    in
    if len <> new_len then raise C.Unexpected_value_from_C;
    Helpers.string_from_carray ret

  let set_config_item c ~subsys ~value =
    C.set_config_item c.lxc_container (Some subsys) (Some value)
    |> bool_to_unit_result_true_is_ok

  let get_config_path c = C.get_config_path c.lxc_container |> Option.get

  let set_config_path c path =
    C.set_config_path c.lxc_container (Some path)
    |> bool_to_unit_result_true_is_ok

  let clone c ~new_name ~lxcpath ~flags ~bdevtype ~bdevdata ~new_size
      ~hook_args =
    let new_size = Unsigned.UInt64.of_int64 new_size in
    let hook_args = Helpers.string_carray_from_string_list hook_args in
    C.clone c.lxc_container (Some new_name) (Some lxcpath) flags
      (Some bdevtype) (Some bdevdata) new_size (CArray.start hook_args)
end
