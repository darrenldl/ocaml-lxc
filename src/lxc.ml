open Misc_utils
open Ctypes
module C = Lxc_c

type container =
  {lxc_container : Types.lxc_container Ctypes.structure Ctypes.ptr}

type getfd_result =
  { ttynum : int
  ; masterfd : int
  ; tty_fd : int }

module Attach = Attach
module Backing_store = Backing_store
module Console_log = Console_log
module Create_options = Create_options
module Namespace_flags = C.Namespace_flags
module Feature_checks = C.Feature_checks
module State = C.State
module Migrate = Migrate
module Snapshot = Snapshot

let new_container ?config_path name =
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
  C.lxc_get_global_config_item key |> string_from_string_ptr ~free:true

let get_version () = C.lxc_get_version ()

let list_container_names_internal f ~(lxcpath : string option) =
  let name_arr_typ = ptr (ptr char) in
  let name_arr_ptr = allocate_ptr_init_to_null name_arr_typ in
  let struct_ptr_arr_typ = ptr (ptr Types.lxc_container) in
  let struct_ptr_arr_ptr_null = make_null_ptr (ptr struct_ptr_arr_typ) in
  let count = f lxcpath name_arr_ptr struct_ptr_arr_ptr_null in
  let ret =
    string_list_from_string_ptr_arr_ptr name_arr_ptr ~free_each_ptr_in_arr:true
      ~count
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
  let name_arr_ptr = allocate_ptr_init_to_null name_arr_typ in
  let struct_ptr_arr_typ = ptr (ptr Types.lxc_container) in
  let struct_ptr_arr_ptr = allocate_ptr_init_to_null struct_ptr_arr_typ in
  let count = f lxcpath name_arr_ptr struct_ptr_arr_ptr in
  let names =
    string_list_from_string_ptr_arr_ptr name_arr_ptr ~free_each_ptr_in_arr:true
      ~count
  in
  let struct_ptr_list =
    CArray.from_ptr struct_ptr_arr_ptr count |> CArray.to_list
  in
  let containers =
    List.map (fun ptr -> {lxc_container = !@ptr}) struct_ptr_list
  in
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

let config_item_is_supported ~key = C.lxc_config_item_is_supported key

let has_api_extension ~extension = C.lxc_has_api_extension extension

module Container = struct
  let is_defined c = C.is_defined c.lxc_container

  let state c = C.state c.lxc_container |> Option.get |> C.State.of_string

  let is_running c = C.is_running c.lxc_container

  let freeze c = C.freeze c.lxc_container |> bool_to_unit_result_true_is_ok

  let unfreeze c = C.unfreeze c.lxc_container |> bool_to_unit_result_true_is_ok

  let init_pid c = C.init_pid c.lxc_container |> Posix_types.Pid.to_int

  let load_config ?alt_file c =
    C.load_config c.lxc_container alt_file |> bool_to_unit_result_true_is_ok

  let start ?(use_init = false) ?(argv = [||]) c =
    let argv =
      match argv with
      | [||] ->
        make_null_ptr (ptr (ptr char))
      | _ ->
        string_arr_ptr_from_string_arr argv
    in
    C.start c.lxc_container (bool_to_int use_init) argv
    |> bool_to_unit_result_true_is_ok

  let stop c = C.stop c.lxc_container |> bool_to_unit_result_true_is_ok

  let set_want_daemonize ~(want : [`Yes | `No]) c =
    C.want_daemonize c.lxc_container (want_to_bool want)
    |> bool_to_unit_result_true_is_ok

  let want_close_all_fds ~(want : [`Yes | `No]) c =
    C.want_close_all_fds c.lxc_container (want_to_bool want)
    |> bool_to_unit_result_true_is_ok

  let config_file_name c =
    let ret_ptr = C.config_file_name c.lxc_container in
    string_from_string_ptr ~free:true ret_ptr

  let wait ?(timeout = -1) ~wait_for c =
    let state = Some (C.State.to_string wait_for) in
    C.wait c.lxc_container state timeout |> bool_to_unit_result_true_is_ok

  let set_config_item ~key ~value c =
    C.set_config_item c.lxc_container (Some key) (Some value)
    |> bool_to_unit_result_true_is_ok

  let destroy c = C.destroy c.lxc_container |> bool_to_unit_result_true_is_ok

  let save_config ~alt_file c =
    C.save_config c.lxc_container (Some alt_file)
    |> bool_to_unit_result_true_is_ok

  let create (opts : Create_options.t) c =
    Printf.eprintf "test - start\n";
    let template = Option.value ~default:"download" opts.template in
    Printf.eprintf "test - before store_type_to_string\n";
    let backing_store_type =
      Option.map Backing_store.store_type_to_string opts.backing_store_type
    in
    Printf.eprintf "test - before c_struct_of_t\n";
    let backing_store_specs =
      Option.map
        (fun x -> addr (Backing_store.Specs.c_struct_of_t x))
        opts.backing_store_specs
    in
    Printf.eprintf "test - before args construction\n";
    let args =
      let queue = Queue.create () in
      let add s = Queue.push s queue in
      if template = "download" then (
        Option.iter (fun s -> add "--dist"; add s) opts.distro;
        Option.iter (fun s -> add "--variant"; add s) opts.variant;
        Option.iter (fun s -> add "--server"; add s) opts.server;
        Option.iter (fun s -> add "--keyid"; add s) opts.key_id;
        Option.iter (fun s -> add "--keyserver"; add s) opts.key_server;
        Option.iter
          (fun b -> if b then add "--no-validate")
          opts.disable_gpg_validation;
        Option.iter (fun b -> if b then add "--flush-cache") opts.flush_cache;
        Option.iter (fun b -> if b then add "--force-cache") opts.force_cache )
      else (
        Option.iter (fun s -> add "--release"; add s) opts.release;
        Option.iter (fun s -> add "--arch"; add s) opts.arch;
        Option.iter (fun b -> if b then add "--flush-cache") opts.flush_cache );
      Queue.to_seq queue |> Array.of_seq
    in
    Printf.eprintf "test - before extra_args construction\n";
    let extra_args = Option.value ~default:[||] opts.extra_args in
    let args = Array.append args extra_args in
    Printf.eprintf "test - before args pointer construction\n";
    let argv =
      match args with
      | [||] ->
        make_null_ptr (ptr (ptr char))
      | _ ->
        string_arr_ptr_from_string_arr args
    in
    Printf.eprintf "test - before create__glue call\n";
    C.create__glue c.lxc_container template backing_store_type
      backing_store_specs 0 argv
    |> bool_to_unit_result_true_is_ok

  let rename ~new_name c =
    C.rename c.lxc_container (Some new_name) |> bool_to_unit_result_true_is_ok

  let reboot ?timeout c =
    match timeout with
    | None ->
      C.reboot c.lxc_container |> bool_to_unit_result_true_is_ok
    | Some timeout ->
      C.reboot2 c.lxc_container timeout |> bool_to_unit_result_true_is_ok

  let shutdown ~timeout c =
    C.shutdown c.lxc_container timeout |> bool_to_unit_result_true_is_ok

  let clear_config c = C.clear_config c.lxc_container

  let clear_config_item ~key c =
    C.clear_config_item c.lxc_container (Some key)
    |> bool_to_unit_result_true_is_ok

  let get_config_item ~key c =
    let len =
      C.get_config_item c.lxc_container (Some key) (make_null_ptr (ptr char)) 0
    in
    if len < 0 then Error ()
    else
      let ret = CArray.make char len in
      let new_len =
        C.get_config_item c.lxc_container (Some key) (CArray.start ret) len
      in
      if len <> new_len then raise C.Unexpected_value_from_C;
      Ok (string_from_carray ret)

  let get_running_config_item ~key c =
    let ret_ptr = C.get_running_config_item c.lxc_container (Some key) in
    if is_null ret_ptr then Error ()
    else string_from_string_ptr ~free:true ret_ptr |> Result.ok

  let get_keys ~prefix c =
    let len =
      C.get_keys c.lxc_container (Some prefix) (make_null_ptr (ptr char)) 0
    in
    if len < 0 then Error ()
    else
      let ret = CArray.make char len in
      let new_len =
        C.get_keys c.lxc_container (Some prefix) (CArray.start ret) len
      in
      if len <> new_len then raise C.Unexpected_value_from_C;
      string_from_carray ret |> String.split_on_char '\n'
      |> List.filter (fun s -> s <> "")
      |> Result.ok

  let get_interfaces c =
    let ret_ptr = C.get_interfaces c.lxc_container in
    if is_null ret_ptr then Error ()
    else
      string_list_from_string_null_term_arr_ptr ~free_each_ptr_in_arr:true
        ret_ptr
      |> Result.ok

  let get_ips ~interface ~family ~scope c =
    let ret_ptr =
      C.get_ips c.lxc_container (Some interface) (Some family) scope
    in
    if is_null ret_ptr then Error ()
    else
      let strings =
        string_list_from_string_null_term_arr_ptr ~free_each_ptr_in_arr:true
          ret_ptr
      in
      Ok strings

  let get_cgroup_item ~subsys c =
    let len =
      C.get_cgroup_item c.lxc_container (Some subsys)
        (make_null_ptr (ptr char))
        0
    in
    if len < 0 then Error ()
    else
      let ret = CArray.make char len in
      let new_len =
        C.get_cgroup_item c.lxc_container (Some subsys) (CArray.start ret) len
      in
      if len <> new_len then raise C.Unexpected_value_from_C;
      string_from_carray ret |> Result.ok

  let set_cgroup_item ~subsys ~value c =
    C.set_cgroup_item c.lxc_container (Some subsys) (Some value)
    |> bool_to_unit_result_true_is_ok

  let get_config_path c = C.get_config_path c.lxc_container |> Option.get

  let set_config_path ~path c =
    C.set_config_path c.lxc_container (Some path)
    |> bool_to_unit_result_true_is_ok

  let clone ~new_name ~lxcpath ~flags ~bdevtype ~bdevdata ~new_size ~hook_args
      c =
    let new_size = Unsigned.UInt64.of_int64 new_size in
    let hook_args = string_carray_from_string_list hook_args in
    let ret_ptr =
      C.clone c.lxc_container (Some new_name) (Some lxcpath) flags
        (Some bdevtype) (Some bdevdata) new_size (CArray.start hook_args)
    in
    if is_null ret_ptr then Error () else Ok {lxc_container = ret_ptr}

  let console_getfd ?(ttynum : int = -1) c =
    let ttynum_ptr_init = ttynum in
    let ttynum_ptr = allocate int ttynum_ptr_init in
    let masterfd_ptr = allocate int 0 in
    let tty_fd = C.console_getfd c.lxc_container ttynum_ptr masterfd_ptr in
    if tty_fd = -1 then Error ()
    else Ok {ttynum = !@ttynum_ptr; masterfd = !@masterfd_ptr; tty_fd}

  let console ?(ttynum : int = -1) ~stdin_fd ~stdout_fd ~stderr_fd
      ~(escape_char : char) c =
    let escape = Char.code escape_char - Char.code 'a' in
    match
      C.console c.lxc_container ttynum stdin_fd stdout_fd stderr_fd escape
    with
    | 0 ->
      Ok ()
    | -1 ->
      Error ()
    | _ ->
      raise C.Unexpected_value_from_C

  let attach_run_wait (opts : Attach.Options.t) ~program ~argv c =
    let opts_ptr =
      allocate Stubs.Type_stubs.Lxc_attach_options_t.t
        (Attach.Options.c_struct_of_t opts)
    in
    match
      C.attach_run_wait c.lxc_container opts_ptr (Some program)
        (string_arr_ptr_from_string_arr argv)
    with
    | -1 ->
      Error ()
    | n ->
      Ok n

  let create_snapshot ~comment_file c =
    match C.snapshot c.lxc_container (Some comment_file) with
    | -1 ->
      Error ()
    | n ->
      Ok n

  let list_snapshots c =
    let snapshot_arr_ptr =
      allocate_ptr_init_to_null (ptr Types.Lxc_snapshot.t)
    in
    let count = C.snapshot_list c.lxc_container snapshot_arr_ptr in
    if count < 0 then Error ()
    else
      let snapshot_arr = CArray.from_ptr snapshot_arr_ptr count in
      let ret = CArray.to_list snapshot_arr in
      ret |> List.map Snapshot.t_of_c_struct_ptr |> Result.ok

  let restore_snapshot ~snap_name ~new_container_name c =
    C.snapshot_restore c.lxc_container (Some snap_name)
      (Some new_container_name)
    |> bool_to_unit_result_true_is_ok

  let destroy_snapshot ~snap_name c =
    C.snapshot_destroy c.lxc_container (Some snap_name)
    |> bool_to_unit_result_true_is_ok

  let may_control c = C.may_control c.lxc_container

  let add_device_node ~src_path ~dst_path c =
    C.add_device_node c.lxc_container (Some src_path) (Some dst_path)
    |> bool_to_unit_result_true_is_ok

  let remove_device_node ~src_path ~dst_path c =
    C.remove_device_node c.lxc_container (Some src_path) (Some dst_path)
    |> bool_to_unit_result_true_is_ok

  let attach_interface ~src_dev ~dst_dev c =
    C.attach_interface c.lxc_container (Some src_dev) (Some dst_dev)
    |> bool_to_unit_result_true_is_ok

  let detach_interface ~src_dev c =
    C.detach_interface c.lxc_container (Some src_dev) None
    |> bool_to_unit_result_true_is_ok

  let checkpoint ~dir ~stop ~verbose c =
    C.checkpoint c.lxc_container (string_ptr_from_string dir) stop verbose
    |> bool_to_unit_result_true_is_ok

  let restore_from_checkpoint ~dir ~verbose c =
    C.restore c.lxc_container (string_ptr_from_string dir) verbose
    |> bool_to_unit_result_true_is_ok

  let destroy_with_snapshots c =
    C.destroy_with_snapshots c.lxc_container |> bool_to_unit_result_true_is_ok

  let destroy_all_snapshots c =
    C.snapshot_destroy_all c.lxc_container |> bool_to_unit_result_true_is_ok

  let migrate (cmd : Migrate.Cmd.t) (opts : Migrate.Options.t) c =
    let cmd = Migrate.Cmd.to_c_int cmd |> Unsigned.UInt.of_int64 in
    C.migrate c.lxc_container cmd
      (addr (Migrate.Options.c_struct_of_t opts))
      (Unsigned.UInt.of_int (Ctypes.sizeof Types.Migrate_opts.t))
    |> int_to_unit_result_zero_is_ok

  let console_log (opts : Console_log.options) c =
    let c_struct = Console_log.c_struct_of_options opts in
    match C.console_log c.lxc_container (addr c_struct) with
    | 0 ->
      Ok (Console_log.result_of_c_struct (addr c_struct))
    | _ ->
      Error ()
end
