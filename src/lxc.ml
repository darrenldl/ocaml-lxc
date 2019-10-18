open Misc_utils
open Ctypes
module Bigstring = Core.Bigstring
module C = Lxc_c

type container =
  {lxc_container : Types.lxc_container Ctypes.structure Ctypes.ptr}

type getfd_result =
  { ttynum : int
  ; masterfd : int
  ; tty_fd : int }

module Helpers = struct
  let free_ptr (typ : 'a ptr typ) ret_ptr =
    let ret_ptr = coerce typ (ptr char) ret_ptr in
    Stubs.Fun_stubs.free ret_ptr

  let free_char_ptr ret_ptr = free_ptr (ptr char) ret_ptr

  let strlen ptr =
    let len = Stubs.Fun_stubs.strlen ptr in
    Signed.Long.to_int len

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

  let string_list_from_string_ptr_arr_ptr ?(free = false)
      ?(free_each_ptr_in_arr = false) ~(count : int) (p : char ptr ptr ptr) =
    assert (count >= 0);
    let ret =
      CArray.from_ptr p count |> CArray.to_list
      |> List.map (fun ptr ->
          string_from_string_ptr ~free:free_each_ptr_in_arr !@ptr)
    in
    if free then free_ptr (ptr (ptr (ptr char))) p;
    ret

  let string_list_from_string_ptr_null_term_arr_ptr ?(free = false)
      ?(free_each_ptr_in_arr = false) (p : char ptr ptr ptr) =
    let ret =
      elements_from_null_term_ptr p
      |> List.map (fun p ->
          string_from_string_ptr ~free:free_each_ptr_in_arr !@p)
    in
    if free then free_ptr (ptr (ptr (ptr char))) p;
    ret

  let string_list_from_string_null_term_arr_ptr ?(free = false)
      ?(free_each_ptr_in_arr = false) (p : char ptr ptr) =
    let ret =
      elements_from_null_term_ptr p
      |> List.map (fun p ->
          string_from_string_ptr ~free:free_each_ptr_in_arr p)
    in
    if free then free_ptr (ptr (ptr char)) p;
    ret

  let make_null_ptr (typ : 'a ptr typ) : 'a ptr = coerce (ptr void) typ null

  let allocate_ptr_init_to_null (typ : 'a ptr typ) : 'a ptr ptr =
    allocate typ (make_null_ptr typ)

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

  let string_ptr_from_string s = s |> CArray.of_string |> CArray.start
end

module Namespace_flags = Lxc_c.Namespace_flags
module Lxc_attach_flags = Lxc_c.Lxc_attach_flags

module Lxc_attach_options_t = struct
  module L = Stubs.Type_stubs.Lxc_attach_options_t

  type t = {t : Types.Lxc_attach_options_t.t structure}

  let make ?(personality = -1L) ?initial_cwd ?(uid = -1) ?(gid = -1)
      (attach_flags : Lxc_attach_flags.t list)
      (namespace_flags : Namespace_flags.t list) env_policy ~extra_env_vars
      ~extra_keep_env ~stdin_fd ~stdout_fd ~stderr_fd ~log_fd =
    let t = make L.t in
    setf t L.attach_flags (lor_flags C.Lxc_attach_flags.to_c_int attach_flags);
    setf t L.namespaces (lor_flags C.Namespace_flags.to_c_int namespace_flags);
    setf t L.personality (Signed.Long.of_int64 personality);
    setf t L.initial_cwd initial_cwd;
    setf t L.uid (Posix_types.Uid.of_int uid);
    setf t L.gid (Posix_types.Gid.of_int gid);
    setf t L.env_policy env_policy;
    setf t L.extra_env_vars extra_env_vars;
    setf t L.extra_keep_env extra_keep_env;
    setf t L.stdin_fd stdin_fd;
    setf t L.stdout_fd stdout_fd;
    setf t L.stderr_fd stderr_fd;
    setf t L.log_fd log_fd;
    {t}

  let default () =
    let t = Ctypes.make L.t in
    setf t L.attach_flags
      (lor_flags C.Lxc_attach_flags.to_c_int [Lxc_attach_flags.Attach_default]);
    setf t L.namespaces (-1);
    setf t L.personality (Signed.Long.of_int (-1));
    setf t L.initial_cwd None;
    setf t L.uid (Posix_types.Uid.of_int (-1));
    setf t L.gid (Posix_types.Gid.of_int (-1));
    setf t L.env_policy
      Stubs.Type_stubs.Lxc_attach_env_policy_t.Lxc_attach_keep_env;
    setf t L.extra_env_vars (Helpers.make_null_ptr (ptr (ptr char)));
    setf t L.extra_keep_env (Helpers.make_null_ptr (ptr (ptr char)));
    setf t L.stdin_fd 0;
    setf t L.stdout_fd 1;
    setf t L.stderr_fd 2;
    setf t L.log_fd (-Stubs.Type_stubs.Errno.ebadf);
    {t}
end

module Snapshot = struct
  module L = Stubs.Type_stubs.Lxc_snapshot
  open L

  type t = {t : Types.Lxc_snapshot.t structure ptr}

  let get_name t = getf !@(t.t) L.name

  let get_comment_path_name t = getf !@(t.t) L.comment_pathname

  let get_timestamp t = getf !@(t.t) L.timestamp

  let get_lxcpath t = getf !@(t.t) L.lxcpath

  let free t =
    let c_field = getf !@(t.t) L.free in
    let f =
      coerce
        (static_funptr (ptr L.t @-> returning void))
        (Foreign.funptr (ptr L.t @-> returning void))
        c_field
    in
    f t.t
end

module Bdev_specs = struct
  module B = Stubs.Type_stubs.Bdev_specs__glue
  open B

  type t = {t : Types.Bdev_specs__glue.t structure}

  module Zfs = struct
    type t = {zfs : Types.Bdev_specs__glue.Zfs__glue.t structure}

    let make ~zfsroot =
      let zfs = Ctypes.make Zfs__glue.t in
      setf zfs Zfs__glue.zfsroot zfsroot;
      {zfs}
  end

  module Lvm = struct
    type t = {lvm : Types.Bdev_specs__glue.Lvm__glue.t structure}

    let make ~vg ~lv ~thinpool =
      let lvm = Ctypes.make Lvm__glue.t in
      setf lvm Lvm__glue.vg vg;
      setf lvm Lvm__glue.lv lv;
      setf lvm Lvm__glue.thinpool thinpool;
      {lvm}
  end

  module Rbd = struct
    type t = {rbd : Types.Bdev_specs__glue.Rbd__glue.t structure}

    let make ~rbdname ~rbdpool =
      let rbd = Ctypes.make Rbd__glue.t in
      setf rbd Rbd__glue.rbdname rbdname;
      setf rbd Rbd__glue.rbdpool rbdpool;
      {rbd}
  end

  let make ~fstype ~(fssize : int64) ~dir ~(zfs : Zfs.t) ~(lvm : Lvm.t)
      ~(rbd : Rbd.t) =
    let t = Ctypes.make t in
    setf t B.fstype fstype;
    setf t B.fssize (Unsigned.UInt64.of_int64 fssize);
    setf t B.dir dir;
    setf t B.zfs zfs.zfs;
    setf t B.lvm lvm.lvm;
    setf t B.rbd rbd.rbd;
    {t}
end

module Feature_checks = Lxc_c.Feature_checks

module Migrate_cmd = Lxc_c.Migrate_cmd

module Migrate_opts = struct
  module M = Stubs.Type_stubs.Migrate_opts

  type t = {t : Types.Migrate_opts.t structure}

  let make ?predump_dir ?page_server_addr ?page_server_port ?action_script
      ?(disable_skip_in_flight = false) ?(ghost_limit = 0L)
      ?(features_to_check = []) ~dir ~verbose ~stop ~preserves_inodes =
    let t = Ctypes.make Stubs.Type_stubs.Migrate_opts.t in
    setf t Stubs.Type_stubs.Migrate_opts.directory (Some dir);
    setf t Stubs.Type_stubs.Migrate_opts.verbose verbose;
    setf t Stubs.Type_stubs.Migrate_opts.stop stop;
    setf t Stubs.Type_stubs.Migrate_opts.predump_dir predump_dir;
    setf t Stubs.Type_stubs.Migrate_opts.pageserver_address page_server_addr;
    setf t Stubs.Type_stubs.Migrate_opts.pageserver_port page_server_port;
    setf t Stubs.Type_stubs.Migrate_opts.preserves_inodes preserves_inodes;
    setf t Stubs.Type_stubs.Migrate_opts.action_script action_script;
    setf t Stubs.Type_stubs.Migrate_opts.disable_skip_in_flight
      disable_skip_in_flight;
    setf t Stubs.Type_stubs.Migrate_opts.ghost_limit
      (Unsigned.UInt64.of_int64 ghost_limit);
    setf t Stubs.Type_stubs.Migrate_opts.features_to_check
      ( lor_flags C.Feature_checks.to_c_int features_to_check
        |> Unsigned.UInt64.of_int );
    {t}
end

module State = Lxc_c.State

let new_container ?config_path ~name () =
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
    Helpers.string_list_from_string_ptr_arr_ptr name_arr_ptr
      ~free_each_ptr_in_arr:true ~count
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
    Helpers.string_list_from_string_ptr_arr_ptr name_arr_ptr
      ~free_each_ptr_in_arr:true ~count
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

  let start ~use_init ~argv c =
    C.start c.lxc_container (bool_to_int use_init)
      (Helpers.string_arr_ptr_from_string_arr argv)
    |> bool_to_unit_result_true_is_ok

  let stop c = C.stop c.lxc_container |> bool_to_unit_result_true_is_ok

  let want_daemonize ~(want : [`Yes | `No]) c =
    C.want_daemonize c.lxc_container (want_to_bool want)
    |> bool_to_unit_result_true_is_ok

  let want_close_all_fds ~(want : [`Yes | `No]) c =
    C.want_close_all_fds c.lxc_container (want_to_bool want)
    |> bool_to_unit_result_true_is_ok

  let config_file_name c =
    let ret_ptr = C.config_file_name c.lxc_container in
    Helpers.string_from_string_ptr ~free:true ret_ptr

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

  let create ?(template = "download") ?bdev_type
      ?(bdev_specs : Bdev_specs.t option) ?(flags = 0) c ~(argv : string array)
    =
    let bdev_specs =
      Option.map (fun (x : Bdev_specs.t) -> addr x.t) bdev_specs
    in
    C.create__glue c.lxc_container template bdev_type bdev_specs flags
      (Helpers.string_arr_ptr_from_string_arr argv)
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
      C.get_config_item c.lxc_container (Some key)
        (Helpers.make_null_ptr (ptr char))
        0
    in
    if len < 0 then Error ()
    else
      let ret = CArray.make char len in
      let new_len =
        C.get_config_item c.lxc_container (Some key) (CArray.start ret) len
      in
      if len <> new_len then raise C.Unexpected_value_from_C;
      Ok (Helpers.string_from_carray ret)

  let get_running_config_item ~key c =
    let ret_ptr = C.get_running_config_item c.lxc_container (Some key) in
    if is_null ret_ptr then Error ()
    else Helpers.string_from_string_ptr ~free:true ret_ptr |> Result.ok

  let get_keys ~prefix c =
    let len =
      C.get_keys c.lxc_container (Some prefix)
        (Helpers.make_null_ptr (ptr char))
        0
    in
    if len < 0 then Error ()
    else
      let ret = CArray.make char len in
      let new_len =
        C.get_keys c.lxc_container (Some prefix) (CArray.start ret) len
      in
      if len <> new_len then raise C.Unexpected_value_from_C;
      Helpers.string_from_carray ret
      |> String.split_on_char '\n'
      |> List.filter (fun s -> s <> "")
      |> Result.ok

  let get_interfaces c =
    let ret_ptr = C.get_interfaces c.lxc_container in
    if is_null ret_ptr then Error ()
    else
      Helpers.string_list_from_string_null_term_arr_ptr
        ~free_each_ptr_in_arr:true ret_ptr
      |> Result.ok

  let get_ips ~interface ~family ~scope c =
    let ret_ptr =
      C.get_ips c.lxc_container (Some interface) (Some family) scope
    in
    if is_null ret_ptr then Error ()
    else
      let strings =
        Helpers.string_list_from_string_null_term_arr_ptr
          ~free_each_ptr_in_arr:true ret_ptr
      in
      Ok strings

  let get_cgroup_item ~subsys c =
    let len =
      C.get_cgroup_item c.lxc_container (Some subsys)
        (Helpers.make_null_ptr (ptr char))
        0
    in
    if len < 0 then Error ()
    else
      let ret = CArray.make char len in
      let new_len =
        C.get_cgroup_item c.lxc_container (Some subsys) (CArray.start ret) len
      in
      if len <> new_len then raise C.Unexpected_value_from_C;
      Helpers.string_from_carray ret |> Result.ok

  let set_cgroup_item ~subsys ~value c =
    C.set_cgroup_item c.lxc_container (Some subsys) (Some value)
    |> bool_to_unit_result_true_is_ok

  let get_config_path c = C.get_config_path c.lxc_container |> Option.get

  let set_config_path ~path c =
    C.set_config_path c.lxc_container (Some path)
    |> bool_to_unit_result_true_is_ok

  let clone c ~new_name ~lxcpath ~flags ~bdevtype ~bdevdata ~new_size
      ~hook_args =
    let new_size = Unsigned.UInt64.of_int64 new_size in
    let hook_args = Helpers.string_carray_from_string_list hook_args in
    C.clone c.lxc_container (Some new_name) (Some lxcpath) flags
      (Some bdevtype) (Some bdevdata) new_size (CArray.start hook_args)

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

  let attach_run_wait (options : Types.Lxc_attach_options_t.t structure)
      ~program ~argv c =
    let options_ptr =
      allocate Stubs.Type_stubs.Lxc_attach_options_t.t options
    in
    C.attach_run_wait c.lxc_container options_ptr (Some program)
      (Helpers.string_arr_ptr_from_string_arr argv)

  let create_snapshot ~comment_file c =
    match C.snapshot c.lxc_container (Some comment_file) with
    | -1 ->
      Error ()
    | n ->
      Ok n

  let list_snapshots c =
    let snapshot_arr_ptr =
      Helpers.allocate_ptr_init_to_null (ptr Types.Lxc_snapshot.t)
    in
    let count = C.snapshot_list c.lxc_container snapshot_arr_ptr in
    if count < 0 then Error ()
    else
      let snapshot_arr = CArray.from_ptr snapshot_arr_ptr count in
      let ret = CArray.to_list snapshot_arr in
      Helpers.free_ptr (ptr (ptr Types.Lxc_snapshot.t)) snapshot_arr_ptr;
      ret |> List.map (fun t -> Snapshot.{t}) |> Result.ok

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
    C.checkpoint c.lxc_container
      (Helpers.string_ptr_from_string dir)
      stop verbose
    |> bool_to_unit_result_true_is_ok

  let restore_from_checkpoint ~dir ~verbose c =
    C.restore c.lxc_container (Helpers.string_ptr_from_string dir) verbose
    |> bool_to_unit_result_true_is_ok

  let destroy_with_snapshots c =
    C.destroy_with_snapshots c.lxc_container |> bool_to_unit_result_true_is_ok

  let destroy_all_snapshots c =
    C.snapshot_destroy_all c.lxc_container |> bool_to_unit_result_true_is_ok

  let migrate c (cmd : C.Migrate_cmd.t) (opts : Migrate_opts.t) =
    let cmd = C.Migrate_cmd.to_c_int cmd |> Unsigned.UInt.of_int64 in
    C.migrate c.lxc_container cmd (addr opts.t)
      (Unsigned.UInt.of_int (Ctypes.sizeof Types.Migrate_opts.t))
    |> int_to_unit_result_zero_is_ok

  let console_log c log = C.console_log c.lxc_container log
end
