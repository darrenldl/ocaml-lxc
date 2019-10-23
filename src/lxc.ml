open Misc_utils
open Ctypes
module C = Lxc_c

type container =
  {lxc_container : Types.lxc_container Ctypes.structure Ctypes.ptr}

type getfd_result =
  { tty_num : int
  ; masterfd : int
  ; tty_fd : int }

module Backing_store = Backing_store
module Console_log_options = Console_log_internal.Options
module Console_options = Console_options
module Create_options = Create_options
module Namespace_flags = C.Namespace_flags
module Feature_checks = C.Feature_checks
module State = C.State

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

let config_item_is_supported ~key = C.lxc_config_item_is_supported__glue key

let has_api_extension ~extension = C.lxc_has_api_extension__glue extension

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

  let set_want_daemonize c ~(want : [`Yes | `No]) =
    C.want_daemonize c.lxc_container (want_to_bool want)
    |> bool_to_unit_result_true_is_ok

  let set_want_close_all_fds c ~(want : [`Yes | `No]) =
    C.want_close_all_fds c.lxc_container (want_to_bool want)
    |> bool_to_unit_result_true_is_ok

  let config_file_name c =
    let ret_ptr = C.config_file_name c.lxc_container in
    string_from_string_ptr ~free:true ret_ptr

  let wait ?(timeout = -1) c ~wait_for =
    let state = Some (C.State.to_string wait_for) in
    C.wait c.lxc_container state timeout |> bool_to_unit_result_true_is_ok

  let set_config_item c ~key ~value =
    C.set_config_item c.lxc_container (Some key) (Some value)
    |> bool_to_unit_result_true_is_ok

  let destroy c = C.destroy c.lxc_container |> bool_to_unit_result_true_is_ok

  let save_config c ~alt_file =
    C.save_config c.lxc_container (Some alt_file)
    |> bool_to_unit_result_true_is_ok

  let create c (options : Create_options.t) =
    let template = Option.value ~default:"download" options.template in
    let backing_store_type =
      Option.map Backing_store.store_type_to_string options.backing_store_type
    in
    let backing_store_specs =
      Option.map
        (fun x -> addr (Backing_store.Specs.c_struct_of_t x))
        options.backing_store_specs
    in
    let args =
      let queue = Queue.create () in
      let add s = Queue.push s queue in
      if template = "download" then (
        Option.iter (fun s -> add "--dist"; add s) options.distro;
        Option.iter (fun s -> add "--release"; add s) options.release;
        Option.iter (fun s -> add "--arch"; add s) options.arch;
        Option.iter (fun s -> add "--variant"; add s) options.variant;
        Option.iter (fun s -> add "--server"; add s) options.server;
        Option.iter (fun s -> add "--keyid"; add s) options.key_id;
        Option.iter (fun s -> add "--keyserver"; add s) options.key_server;
        Option.iter
          (fun b -> if b then add "--no-validate")
          options.disable_gpg_validation;
        Option.iter
          (fun b -> if b then add "--flush-cache")
          options.flush_cache;
        Option.iter
          (fun b -> if b then add "--force-cache")
          options.force_cache )
      else (
        Option.iter (fun s -> add "--release"; add s) options.release;
        Option.iter (fun s -> add "--arch"; add s) options.arch;
        Option.iter
          (fun b -> if b then add "--flush-cache")
          options.flush_cache );
      Queue.to_seq queue |> Array.of_seq
    in
    let extra_args = Option.value ~default:[||] options.extra_args in
    let args = Array.append args extra_args in
    let argv =
      match args with
      | [||] ->
        make_null_ptr (ptr (ptr char))
      | _ ->
        string_arr_ptr_from_string_arr args
    in
    C.create__glue c.lxc_container template backing_store_type
      backing_store_specs 0 argv
    |> bool_to_unit_result_true_is_ok

  let rename c ~new_name =
    C.rename c.lxc_container (Some new_name) |> bool_to_unit_result_true_is_ok

  let reboot ?timeout c =
    match timeout with
    | None ->
      C.reboot c.lxc_container |> bool_to_unit_result_true_is_ok
    | Some timeout ->
      C.reboot2 c.lxc_container timeout |> bool_to_unit_result_true_is_ok

  let shutdown c ~timeout =
    C.shutdown c.lxc_container timeout |> bool_to_unit_result_true_is_ok

  let clear_config c = C.clear_config c.lxc_container

  let clear_config_item c ~key =
    C.clear_config_item c.lxc_container (Some key)
    |> bool_to_unit_result_true_is_ok

  let get_config_item c ~key =
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

  let get_running_config_item c ~key =
    let ret_ptr = C.get_running_config_item c.lxc_container (Some key) in
    if is_null ret_ptr then Error ()
    else string_from_string_ptr ~free:true ret_ptr |> Result.ok

  let get_keys c ~prefix =
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

  let get_ips c ~interface ~family ~scope =
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

  let get_config_path c = C.get_config_path c.lxc_container |> Option.get

  let set_config_path c ~path =
    C.set_config_path c.lxc_container (Some path)
    |> bool_to_unit_result_true_is_ok

  module Clone = struct
    module Flags = Clone_internal.Flags
    module Options = Clone_internal.Options

    let clone c ~(options : Options.t) =
      let new_size = Unsigned.UInt64.of_int64 options.new_size in
      let backing_store_type =
        Option.map Backing_store.store_type_to_string
          options.backing_store_type
      in
      let flags = lor_flags Flags.to_c_int options.flags in
      let hook_args = string_carray_from_string_list options.hook_args in
      let ret_ptr =
        C.clone c.lxc_container options.new_name options.lxcpath flags
          backing_store_type None new_size (CArray.start hook_args)
      in
      if is_null ret_ptr then Error () else Ok {lxc_container = ret_ptr}
  end

  let console_getfd ?(tty_num : int = -1) c =
    let tty_num_ptr_init = tty_num in
    let tty_num_ptr = allocate int tty_num_ptr_init in
    let masterfd_ptr = allocate int 0 in
    let tty_fd = C.console_getfd c.lxc_container tty_num_ptr masterfd_ptr in
    if tty_fd = -1 then Error ()
    else Ok {tty_num = !@tty_num_ptr; masterfd = !@masterfd_ptr; tty_fd}

  let console ?(options : Console_options.t = Console_options.default) c =
    let escape = Char.code options.escape_char - Char.code 'a' in
    match
      C.console c.lxc_container options.tty_num options.stdin_fd
        options.stdout_fd options.stderr_fd escape
    with
    | 0 ->
      Ok ()
    | -1 ->
      Error ()
    | _ ->
      raise C.Unexpected_value_from_C

  module Run = struct
    module Flags = Run_internal.Flags
    module Env_policy = Run_internal.Env_policy
    module Options = Run_internal.Options
    module Command = Run_internal.Command

    let shell ?(options = Options.default) c =
      let options = Options.c_struct_of_t options in
      let pid_t_ptr = allocate Posix_types.pid_t (Posix_types.Pid.of_int 0) in
      match
        C.attach_run_shell__glue c.lxc_container (addr options) pid_t_ptr
      with
      | 0 ->
        Ok (Posix_types.Pid.to_int !@pid_t_ptr)
      | -1 ->
        Error ()
      | _ ->
        raise C.Unexpected_value_from_C

    let command_no_wait ?(options = Options.default) c ~argv =
      let options = Options.c_struct_of_t options in
      let command = Command.c_struct_of_string_array argv in
      let pid_t_ptr = allocate Posix_types.pid_t (Posix_types.Pid.of_int 0) in
      match
        C.attach_run_command__glue c.lxc_container (addr options)
          (addr command) pid_t_ptr
      with
      | 0 ->
        Ok (Posix_types.Pid.to_int !@pid_t_ptr)
      | -1 ->
        Error ()
      | _ ->
        raise C.Unexpected_value_from_C

    let command_ret_status ?(options = Options.default) c ~argv =
      let options = Options.c_struct_of_t options in
      match
        C.attach_run_wait c.lxc_container (addr options)
          (Some argv.(0))
          (string_arr_ptr_from_string_arr argv)
      with
      | -1 ->
        Error ()
      | n ->
        Ok n
  end

  module Snapshot = struct
    type t = Snapshot_internal.t

    let create c ~comment_file =
      match C.snapshot c.lxc_container (Some comment_file) with
      | -1 ->
        Error ()
      | n ->
        Ok n

    let list c =
      let snapshot_arr_ptr =
        allocate_ptr_init_to_null (ptr Types.Lxc_snapshot.t)
      in
      let count = C.snapshot_list c.lxc_container snapshot_arr_ptr in
      if count < 0 then Error ()
      else
        let snapshot_arr = CArray.from_ptr snapshot_arr_ptr count in
        let ret =
          CArray.to_list snapshot_arr
          |> List.map Snapshot_internal.t_of_c_struct_ptr
          |> Result.ok
        in
        Snapshot_internal.free_arr_ptr snapshot_arr_ptr ~count;
        ret

    let restore c ~snap_name ~new_container_name =
      C.snapshot_restore c.lxc_container (Some snap_name)
        (Some new_container_name)
      |> bool_to_unit_result_true_is_ok

    let destroy c ~snap_name =
      C.snapshot_destroy c.lxc_container (Some snap_name)
      |> bool_to_unit_result_true_is_ok

    let destroy_all c =
      C.snapshot_destroy_all c.lxc_container |> bool_to_unit_result_true_is_ok
  end

  let may_control c = C.may_control c.lxc_container

  module Device = struct
    let add_node c ~src_path ~dst_path =
      C.add_device_node c.lxc_container (Some src_path) (Some dst_path)
      |> bool_to_unit_result_true_is_ok

    let remove_node c ~src_path ~dst_path =
      C.remove_device_node c.lxc_container (Some src_path) (Some dst_path)
      |> bool_to_unit_result_true_is_ok
  end

  module Interface = struct
    let attach c ~src_dev ~dst_dev =
      C.attach_interface c.lxc_container (Some src_dev) (Some dst_dev)
      |> bool_to_unit_result_true_is_ok

    let detach c ~src_dev =
      C.detach_interface c.lxc_container (Some src_dev) None
      |> bool_to_unit_result_true_is_ok
  end

  module Checkpoint = struct
    let checkpoint c ~dir ~stop ~verbose =
      C.checkpoint c.lxc_container (string_ptr_from_string dir) stop verbose
      |> bool_to_unit_result_true_is_ok

    let restore c ~dir ~verbose =
      C.restore c.lxc_container (string_ptr_from_string dir) verbose
      |> bool_to_unit_result_true_is_ok
  end

  let destroy_with_snapshots c =
    C.destroy_with_snapshots c.lxc_container |> bool_to_unit_result_true_is_ok

  module Migrate = struct
    module Command = Migrate_internal.Command
    module Options = Migrate_internal.Options

    let migrate c (cmd : Command.t) (options : Options.t) =
      let cmd = Command.to_c_int cmd |> Unsigned.UInt.of_int64 in
      C.migrate__glue c.lxc_container cmd
        (addr (Options.c_struct_of_t options))
      |> int_to_unit_result_zero_is_ok
  end

  let console_log c (options : Console_log_options.t) =
    let c_struct = Console_log_internal.c_struct_of_options options in
    match C.console_log c.lxc_container (addr c_struct) with
    | 0 ->
      Ok (Console_log_internal.result_of_c_struct (addr c_struct))
    | _ ->
      Error ()

  module Cgroup = struct
    let get c ~key =
      let len =
        C.get_cgroup_item c.lxc_container (Some key)
          (make_null_ptr (ptr char))
          0
      in
      if len < 0 then Error ()
      else
        let ret = CArray.make char len in
        let new_len =
          C.get_cgroup_item c.lxc_container (Some key) (CArray.start ret) len
        in
        if len <> new_len then raise C.Unexpected_value_from_C;
        string_from_carray ret |> String.split_on_char '\n'
        |> List.filter (fun s -> s <> "")
        |> Result.ok

    let set c ~key ~value =
      C.set_cgroup_item c.lxc_container (Some key) (Some value)
      |> bool_to_unit_result_true_is_ok

    module Helpers = struct
      let get_mem_usage_bytes c =
        get c ~key:"memory.usage_in_bytes"
        |> Result.map List.hd |> Result.map int_of_string

      let get_mem_limit_bytes c =
        get c ~key:"memory.limit_in_bytes"
        |> Result.map List.hd |> Result.map int_of_string

      let set_mem_limit_bytes c limit =
        set c ~key:"memory.limit_in_bytes" ~value:(string_of_int limit)

      let get_soft_mem_limit_bytes c =
        get c ~key:"memory.soft_limit_in_bytes"
        |> Result.map List.hd |> Result.map int_of_string

      let set_soft_mem_limit_bytes c limit =
        set c ~key:"memory.soft_limit_in_bytes" ~value:(string_of_int limit)

      let get_kernel_mem_usage_bytes c =
        get c ~key:"memory.kmem.usage_in_bytes"
        |> Result.map List.hd |> Result.map int_of_string

      let get_kernel_mem_limit_bytes c =
        get c ~key:"memory.kmem.limit_in_bytes"
        |> Result.map List.hd |> Result.map int_of_string

      let set_kernel_mem_limit_bytes c limit =
        set c ~key:"memory.kmem.limit_in_bytes" ~value:(string_of_int limit)

      let get_mem_swap_usage_bytes c =
        get c ~key:"memory.memsw.usage_in_bytes"
        |> Result.map List.hd |> Result.map int_of_string

      let get_mem_swap_limit_bytes c =
        get c ~key:"memory.memsw.limit_in_bytes"
        |> Result.map List.hd |> Result.map int_of_string

      let set_mem_swap_limit_bytes c limit =
        set c ~key:"memory.memsw.limit_in_bytes" ~value:(string_of_int limit)
    end
  end
end
