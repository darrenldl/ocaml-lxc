open Ctypes
open Types

module Fun_stubs (F : Cstubs.FOREIGN) = struct
  open F

  let free = foreign "free" (ptr char @-> returning void)

  let strlen = foreign "strlen" (ptr char @-> returning long)

  let create__glue =
    foreign "create__glue"
      ( ptr lxc_container @-> string @-> string_opt
        @-> ptr_opt Bdev_specs__glue.t @-> int
        @-> ptr (ptr char)
        @-> returning bool )

  let attach_run_command__glue =
    foreign "attach_run_command__glue"
      ( ptr lxc_container @-> ptr Lxc_attach_options_t.t
        @-> ptr Lxc_attach_command_t.t @-> ptr Posix_types.pid_t
        @-> returning int )

  let attach_run_shell__glue =
    foreign "attach_run_shell__glue"
      ( ptr lxc_container @-> ptr Lxc_attach_options_t.t
        @-> ptr Posix_types.pid_t @-> returning int )

  let lxc_container_new =
    foreign "lxc_container_new"
      (string @-> string_opt @-> returning (ptr_opt Types.lxc_container))

  let lxc_container_get =
    foreign "lxc_container_get" (ptr Types.lxc_container @-> returning int)

  let lxc_container_put =
    foreign "lxc_container_put" (ptr Types.lxc_container @-> returning int)

  let lxc_get_wait_states =
    foreign "lxc_get_wait_states" (ptr string @-> returning int)

  let lxc_get_global_config_item =
    foreign "lxc_get_global_config_item" (string @-> returning (ptr char))

  let lxc_get_version = foreign "lxc_get_version" (void @-> returning string)

  let list_defined_containers =
    foreign "list_defined_containers"
      ( string_opt
        @-> ptr (ptr (ptr char))
        @-> ptr (ptr (ptr Types.lxc_container))
        @-> returning int )

  let list_active_containers =
    foreign "list_active_containers"
      ( string_opt
        @-> ptr (ptr (ptr char))
        @-> ptr (ptr (ptr Types.lxc_container))
        @-> returning int )

  let list_all_containers =
    foreign "list_all_containers"
      ( string_opt
        @-> ptr (ptr (ptr char))
        @-> ptr (ptr (ptr Types.lxc_container))
        @-> returning int )

  let lxc_log_init =
    foreign "lxc_log_init" (ptr Types.Lxc_log.t @-> returning int)

  let lxc_log_close = foreign "lxc_log_close" (void @-> returning void)

  let lxc_config_item_is_supported__glue =
    foreign "lxc_config_item_is_supported__glue" (string @-> returning bool)

  let lxc_has_api_extension__glue =
    foreign "lxc_has_api_extension__glue" (string @-> returning bool)

  (*$ #use "code_gen/gen.cinaps";;

       For_ffi_bindings_dot_ml.gen_lxc_container_funptr_field_ml_glue_all ()
  *)

  let is_defined =
    foreign "is_defined__glue" (ptr lxc_container @-> returning bool)

  let state = foreign "state__glue" (ptr lxc_container @-> returning string_opt)

  let is_running =
    foreign "is_running__glue" (ptr lxc_container @-> returning bool)

  let freeze = foreign "freeze__glue" (ptr lxc_container @-> returning bool)

  let unfreeze = foreign "unfreeze__glue" (ptr lxc_container @-> returning bool)

  let init_pid =
    foreign "init_pid__glue" (ptr lxc_container @-> returning Posix_types.pid_t)

  let load_config =
    foreign "load_config__glue"
      (ptr lxc_container @-> string_opt @-> returning bool)

  let start =
    foreign "start__glue"
      (ptr lxc_container @-> int @-> ptr (ptr char) @-> returning bool)

  let stop = foreign "stop__glue" (ptr lxc_container @-> returning bool)

  let want_daemonize =
    foreign "want_daemonize__glue"
      (ptr lxc_container @-> bool @-> returning bool)

  let want_close_all_fds =
    foreign "want_close_all_fds__glue"
      (ptr lxc_container @-> bool @-> returning bool)

  let config_file_name =
    foreign "config_file_name__glue"
      (ptr lxc_container @-> returning (ptr char))

  let wait =
    foreign "wait__glue"
      (ptr lxc_container @-> string_opt @-> int @-> returning bool)

  let set_config_item =
    foreign "set_config_item__glue"
      (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool)

  let destroy = foreign "destroy__glue" (ptr lxc_container @-> returning bool)

  let save_config =
    foreign "save_config__glue"
      (ptr lxc_container @-> string_opt @-> returning bool)

  let rename =
    foreign "rename__glue" (ptr lxc_container @-> string_opt @-> returning bool)

  let reboot = foreign "reboot__glue" (ptr lxc_container @-> returning bool)

  let shutdown =
    foreign "shutdown__glue" (ptr lxc_container @-> int @-> returning bool)

  let clear_config =
    foreign "clear_config__glue" (ptr lxc_container @-> returning void)

  let clear_config_item =
    foreign "clear_config_item__glue"
      (ptr lxc_container @-> string_opt @-> returning bool)

  let get_config_item =
    foreign "get_config_item__glue"
      (ptr lxc_container @-> string_opt @-> ptr char @-> int @-> returning int)

  let get_running_config_item =
    foreign "get_running_config_item__glue"
      (ptr lxc_container @-> string_opt @-> returning (ptr char))

  let get_keys =
    foreign "get_keys__glue"
      (ptr lxc_container @-> string_opt @-> ptr char @-> int @-> returning int)

  let get_interfaces =
    foreign "get_interfaces__glue"
      (ptr lxc_container @-> returning (ptr (ptr char)))

  let get_ips =
    foreign "get_ips__glue"
      ( ptr lxc_container @-> string_opt @-> string_opt @-> int
        @-> returning (ptr (ptr char)) )

  let get_cgroup_item =
    foreign "get_cgroup_item__glue"
      (ptr lxc_container @-> string_opt @-> ptr char @-> int @-> returning int)

  let set_cgroup_item =
    foreign "set_cgroup_item__glue"
      (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool)

  let get_config_path =
    foreign "get_config_path__glue" (ptr lxc_container @-> returning string_opt)

  let set_config_path =
    foreign "set_config_path__glue"
      (ptr lxc_container @-> string_opt @-> returning bool)

  let clone =
    foreign "clone__glue"
      ( ptr lxc_container @-> string_opt @-> string_opt @-> int @-> string_opt
        @-> string_opt @-> uint64_t
        @-> ptr (ptr char)
        @-> returning (ptr lxc_container) )

  let console_getfd =
    foreign "console_getfd__glue"
      (ptr lxc_container @-> ptr int @-> ptr int @-> returning int)

  let console =
    foreign "console__glue"
      ( ptr lxc_container @-> int @-> int @-> int @-> int @-> int
        @-> returning int )

  let attach_run_wait =
    foreign "attach_run_wait__glue"
      ( ptr lxc_container @-> ptr Lxc_attach_options_t.t @-> string_opt
        @-> ptr (ptr char)
        @-> returning int )

  let snapshot =
    foreign "snapshot__glue"
      (ptr lxc_container @-> string_opt @-> returning int)

  let snapshot_list =
    foreign "snapshot_list__glue"
      (ptr lxc_container @-> ptr (ptr Lxc_snapshot.t) @-> returning int)

  let snapshot_restore =
    foreign "snapshot_restore__glue"
      (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool)

  let snapshot_destroy =
    foreign "snapshot_destroy__glue"
      (ptr lxc_container @-> string_opt @-> returning bool)

  let may_control =
    foreign "may_control__glue" (ptr lxc_container @-> returning bool)

  let add_device_node =
    foreign "add_device_node__glue"
      (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool)

  let remove_device_node =
    foreign "remove_device_node__glue"
      (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool)

  let attach_interface =
    foreign "attach_interface__glue"
      (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool)

  let detach_interface =
    foreign "detach_interface__glue"
      (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool)

  let checkpoint =
    foreign "checkpoint__glue"
      (ptr lxc_container @-> ptr char @-> bool @-> bool @-> returning bool)

  let restore =
    foreign "restore__glue"
      (ptr lxc_container @-> ptr char @-> bool @-> returning bool)

  let destroy_with_snapshots =
    foreign "destroy_with_snapshots__glue"
      (ptr lxc_container @-> returning bool)

  let snapshot_destroy_all =
    foreign "snapshot_destroy_all__glue" (ptr lxc_container @-> returning bool)

  let console_log =
    foreign "console_log__glue"
      (ptr lxc_container @-> ptr Lxc_console_log.t @-> returning int)

  let reboot2 =
    foreign "reboot2__glue" (ptr lxc_container @-> int @-> returning bool)

    (*$*)
end
