open Ctypes
module Type_stubs = Ffi_types.Types_stubs (Ffi_types_ml_stubs)
module Fun_stubs = Ffi_bindings.Fun_stubs (Ffi_bindings_ml_stubs)

exception Unexpected_value

module Migrate_cmd = struct
  open Type_stubs.Migrate_cmd

  type t =
    | Migrate_pre_dump
    | Migrate_dump
    | Migrate_restore
    | Migrate_feature_check

  let to_c_int t =
    match t with
    | Migrate_pre_dump ->
      migrate_pre_dump
    | Migrate_dump ->
      migrate_dump
    | Migrate_restore ->
      migrate_restore
    | Migrate_feature_check ->
      migrate_feature_check
end

module State = struct
  type t =
    | Stopped
    | Starting
    | Running
    | Stopping
    | Aborting
    | Freezing
    | Frozen
    | Thawed

  let to_string t =
    match t with
    | Stopped ->
      "STOPPED"
    | Starting ->
      "STARTING"
    | Running ->
      "RUNNING"
    | Stopping ->
      "STOPPING"
    | Aborting ->
      "ABORTING"
    | Freezing ->
      "FREEZING"
    | Frozen ->
      "FROZEN"
    | Thawed ->
      "THAWED"

  let of_string t =
    match t with
    | "STOPPED" ->
      Stopped
    | "STARTING" ->
      Starting
    | "RUNNING" ->
      Running
    | "STOPPING" ->
      Stopping
    | "ABORTING" ->
      Aborting
    | "FREEZING" ->
      Freezing
    | "FROZEN" ->
      Frozen
    | "THAWED" ->
      Thawed
    | _ ->
      raise Unexpected_value
end

let lxc_container_new =
  Foreign.foreign "lxc_container_new"
    (string @-> string @-> returning (ptr_opt Types.lxc_container))

let lxc_container_get =
  Foreign.foreign "lxc_container_get"
    (ptr Types.lxc_container @-> returning int)

let lxc_container_put =
  Foreign.foreign "lxc_container_put"
    (ptr Types.lxc_container @-> returning int)

let lxc_get_wait_states =
  Foreign.foreign "lxc_get_wait_states" (ptr string @-> returning int)

let lxc_get_global_config_item =
  Foreign.foreign "lxc_get_global_item" (string @-> returning string)

let lxc_get_version =
  Foreign.foreign "lxc_get_version" (void @-> returning string)

let list_defined_containers =
  Foreign.foreign "list_defined_containers"
    ( string
      @-> ptr (ptr (ptr char))
      @-> ptr (ptr (ptr Types.lxc_container))
      @-> returning int )

let list_active_containers =
  Foreign.foreign "list_active_containers"
    ( string
      @-> ptr (ptr (ptr char))
      @-> ptr (ptr (ptr Types.lxc_container))
      @-> returning int )

let list_all_containers =
  Foreign.foreign "list_all_containers"
    ( string
      @-> ptr (ptr (ptr char))
      @-> ptr (ptr (ptr Types.lxc_container))
      @-> returning int )

(* let lxc_log_init =
 *   Foreign.foreign "lxc_log_init" (ptr Types.Lxc_log.t @-> returning int)
 * 
 * let lxc_log_close = Foreign.foreign "lxc_log_close" (void @-> returning void) *)

let lxc_config_item_is_supported =
  Foreign.foreign "lxc_config_item_is_supported" (string @-> returning bool)

let lxc_has_api_extension =
  Foreign.foreign "lxc_has_api_extension" (string @-> returning bool)

let is_defined (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.is_defined__raw in
  let f =
    coerce
      (field_type Type_stubs.is_defined__raw)
      (Foreign.funptr (ptr Types.lxc_container @-> returning bool))
      c_field
  in
  f c

(*$ #use "code_gen/gen.cinaps";;

     For_lxc_c_dot_ml.gen_lxc_container_funptr_field_ml_wrapper_all ()
*)

let is_defined (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.is_defined__raw in
  let f =
    coerce
      (field_type Type_stubs.is_defined__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f clet state (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.state__raw in
  let f =
    coerce
      (field_type Type_stubs.state__raw)
      (Foreign.funptr (ptr lxc_container @-> returning string))
      c_field
  in
  f clet is_running (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.is_running__raw in
  let f =
    coerce
      (field_type Type_stubs.is_running__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f clet freeze (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.freeze__raw in
  let f =
    coerce
      (field_type Type_stubs.freeze__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f clet unfreeze (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.unfreeze__raw in
  let f =
    coerce
      (field_type Type_stubs.unfreeze__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f clet init_pid (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.init_pid__raw in
  let f =
    coerce
      (field_type Type_stubs.init_pid__raw)
      (Foreign.funptr (ptr lxc_container @-> returning Posix_types.pid_t))
      c_field
  in
  f clet load_config (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.load_config__raw in
  let f =
    coerce
      (field_type Type_stubs.load_config__raw)
      (Foreign.funptr (ptr lxc_container @-> string @-> returning bool))
      c_field
  in
  f clet start (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.start__raw in
  let f =
    coerce
      (field_type Type_stubs.start__raw)
      (Foreign.funptr
         (ptr lxc_container @-> int @-> ptr (ptr char) @-> returning bool))
      c_field
  in
  f clet stop (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.stop__raw in
  let f =
    coerce
      (field_type Type_stubs.stop__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f clet want_daemonize (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.want_daemonize__raw in
  let f =
    coerce
      (field_type Type_stubs.want_daemonize__raw)
      (Foreign.funptr (ptr lxc_container @-> bool @-> returning bool))
      c_field
  in
  f clet want_close_all_fds (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.want_close_all_fds__raw in
  let f =
    coerce
      (field_type Type_stubs.want_close_all_fds__raw)
      (Foreign.funptr (ptr lxc_container @-> bool @-> returning bool))
      c_field
  in
  f clet config_file_name (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.config_file_name__raw in
  let f =
    coerce
      (field_type Type_stubs.config_file_name__raw)
      (Foreign.funptr (ptr lxc_container @-> returning (ptr char)))
      c_field
  in
  f clet wait (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.wait__raw in
  let f =
    coerce
      (field_type Type_stubs.wait__raw)
      (Foreign.funptr (ptr lxc_container @-> string @-> int @-> returning bool))
      c_field
  in
  f clet set_config_item (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.set_config_item__raw in
  let f =
    coerce
      (field_type Type_stubs.set_config_item__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string @-> string @-> returning bool))
      c_field
  in
  f clet destroy (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.destroy__raw in
  let f =
    coerce
      (field_type Type_stubs.destroy__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f clet save_config (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.save_config__raw in
  let f =
    coerce
      (field_type Type_stubs.save_config__raw)
      (Foreign.funptr (ptr lxc_container @-> string @-> returning bool))
      c_field
  in
  f clet rename (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.rename__raw in
  let f =
    coerce
      (field_type Type_stubs.rename__raw)
      (Foreign.funptr (ptr lxc_container @-> string @-> returning bool))
      c_field
  in
  f clet reboot (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.reboot__raw in
  let f =
    coerce
      (field_type Type_stubs.reboot__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f clet shutdown (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.shutdown__raw in
  let f =
    coerce
      (field_type Type_stubs.shutdown__raw)
      (Foreign.funptr (ptr lxc_container @-> int @-> returning bool))
      c_field
  in
  f clet clear_config (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.clear_config__raw in
  let f =
    coerce
      (field_type Type_stubs.clear_config__raw)
      (Foreign.funptr (ptr lxc_container @-> returning void))
      c_field
  in
  f clet clear_config_item (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.clear_config_item__raw in
  let f =
    coerce
      (field_type Type_stubs.clear_config_item__raw)
      (Foreign.funptr (ptr lxc_container @-> string @-> returning bool))
      c_field
  in
  f clet get_config_item (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.get_config_item__raw in
  let f =
    coerce
      (field_type Type_stubs.get_config_item__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string @-> ptr char @-> int @-> returning int))
      c_field
  in
  f clet get_running_config_item (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.get_running_config_item__raw in
  let f =
    coerce
      (field_type Type_stubs.get_running_config_item__raw)
      (Foreign.funptr (ptr lxc_container @-> string @-> returning (ptr char)))
      c_field
  in
  f clet get_keys (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.get_keys__raw in
  let f =
    coerce
      (field_type Type_stubs.get_keys__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string @-> ptr char @-> int @-> returning int))
      c_field
  in
  f clet get_interfaces (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.get_interfaces__raw in
  let f =
    coerce
      (field_type Type_stubs.get_interfaces__raw)
      (Foreign.funptr (ptr lxc_container @-> returning (ptr (ptr char))))
      c_field
  in
  f clet get_ips (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.get_ips__raw in
  let f =
    coerce
      (field_type Type_stubs.get_ips__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> string @-> string @-> int
           @-> returning (ptr (ptr char)) ))
      c_field
  in
  f clet get_cgroup_item (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.get_cgroup_item__raw in
  let f =
    coerce
      (field_type Type_stubs.get_cgroup_item__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string @-> ptr char @-> int @-> returning int))
      c_field
  in
  f clet set_cgroup_item (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.set_cgroup_item__raw in
  let f =
    coerce
      (field_type Type_stubs.set_cgroup_item__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string @-> string @-> returning bool))
      c_field
  in
  f clet get_config_path (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.get_config_path__raw in
  let f =
    coerce
      (field_type Type_stubs.get_config_path__raw)
      (Foreign.funptr (ptr lxc_container @-> returning string))
      c_field
  in
  f clet set_config_path (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.set_config_path__raw in
  let f =
    coerce
      (field_type Type_stubs.set_config_path__raw)
      (Foreign.funptr (ptr lxc_container @-> string @-> returning bool))
      c_field
  in
  f clet clone (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.clone__raw in
  let f =
    coerce
      (field_type Type_stubs.clone__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> string @-> string @-> int @-> string @-> string
           @-> uint64_t
           @-> ptr (ptr char)
           @-> returning (ptr lxc_container) ))
      c_field
  in
  f clet console_getfd (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.console_getfd__raw in
  let f =
    coerce
      (field_type Type_stubs.console_getfd__raw)
      (Foreign.funptr
         (ptr lxc_container @-> ptr int @-> ptr int @-> returning int))
      c_field
  in
  f clet console (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.console__raw in
  let f =
    coerce
      (field_type Type_stubs.console__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> int @-> int @-> int @-> int @-> int
           @-> returning int ))
      c_field
  in
  f clet attach_run_wait (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.attach_run_wait__raw in
  let f =
    coerce
      (field_type Type_stubs.attach_run_wait__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> ptr Lxc_attach_options_t.t @-> string
           @-> ptr string @-> returning int ))
      c_field
  in
  f clet snapshot (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.snapshot__raw in
  let f =
    coerce
      (field_type Type_stubs.snapshot__raw)
      (Foreign.funptr (ptr lxc_container @-> string @-> returning int))
      c_field
  in
  f clet snapshot_list (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.snapshot_list__raw in
  let f =
    coerce
      (field_type Type_stubs.snapshot_list__raw)
      (Foreign.funptr
         (ptr lxc_container @-> ptr (ptr Lxc_snapshot.t) @-> returning int))
      c_field
  in
  f clet snapshot_restore (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.snapshot_restore__raw in
  let f =
    coerce
      (field_type Type_stubs.snapshot_restore__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string @-> string @-> returning bool))
      c_field
  in
  f clet snapshot_destroy (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.snapshot_destroy__raw in
  let f =
    coerce
      (field_type Type_stubs.snapshot_destroy__raw)
      (Foreign.funptr (ptr lxc_container @-> string @-> returning bool))
      c_field
  in
  f clet may_control (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.may_control__raw in
  let f =
    coerce
      (field_type Type_stubs.may_control__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f clet add_device_node (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.add_device_node__raw in
  let f =
    coerce
      (field_type Type_stubs.add_device_node__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string @-> string @-> returning bool))
      c_field
  in
  f clet remove_device_node (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.remove_device_node__raw in
  let f =
    coerce
      (field_type Type_stubs.remove_device_node__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string @-> string @-> returning bool))
      c_field
  in
  f clet attach_interface (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.attach_interface__raw in
  let f =
    coerce
      (field_type Type_stubs.attach_interface__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string @-> string @-> returning bool))
      c_field
  in
  f clet detach_interface (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.detach_interface__raw in
  let f =
    coerce
      (field_type Type_stubs.detach_interface__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string @-> string @-> returning bool))
      c_field
  in
  f clet checkpoint (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.checkpoint__raw in
  let f =
    coerce
      (field_type Type_stubs.checkpoint__raw)
      (Foreign.funptr
         (ptr lxc_container @-> ptr char @-> bool @-> bool @-> returning bool))
      c_field
  in
  f clet restore (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.restore__raw in
  let f =
    coerce
      (field_type Type_stubs.restore__raw)
      (Foreign.funptr
         (ptr lxc_container @-> ptr char @-> bool @-> returning bool))
      c_field
  in
  f clet destroy_with_snapshots (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.destroy_with_snapshots__raw in
  let f =
    coerce
      (field_type Type_stubs.destroy_with_snapshots__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f clet snapshot_destroy_all (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.snapshot_destroy_all__raw in
  let f =
    coerce
      (field_type Type_stubs.snapshot_destroy_all__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f clet migrate (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.migrate__raw in
  let f =
    coerce
      (field_type Type_stubs.migrate__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> uint @-> ptr Migrate_opts.t @-> uint
           @-> returning int ))
      c_field
  in
  f clet console_log (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.console_log__raw in
  let f =
    coerce
      (field_type Type_stubs.console_log__raw)
      (Foreign.funptr
         (ptr lxc_container @-> ptr Lxc_console_log.t @-> returning int))
      c_field
  in
  f clet reboot2 (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.reboot2__raw in
  let f =
    coerce
      (field_type Type_stubs.reboot2__raw)
      (Foreign.funptr (ptr lxc_container @-> int @-> returning bool))
      c_field
  in
  f clet mount (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.mount__raw in
  let f =
    coerce
      (field_type Type_stubs.mount__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> string @-> string @-> string @-> ulong
           @-> ptr void @-> ptr Lxc_mount.t @-> returning int ))
      c_field
  in
  f clet umount (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.umount__raw in
  let f =
    coerce
      (field_type Type_stubs.umount__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> string @-> ulong @-> ptr Lxc_mount.t
           @-> returning int ))
      c_field
  in
  f clet seccomp_notify_fd (c : Types.lxc_container structure ptr)
  =
  let c_field = getf !@c Type_stubs.seccomp_notify_fd__raw in
  let f =
    coerce
      (field_type Type_stubs.seccomp_notify_fd__raw)
      (Foreign.funptr (ptr lxc_container @-> returning int))
      c_field
  in
  f c

  (*$*)
