open Ctypes
open Types

module Fun_stubs (F : Cstubs.FOREIGN) = struct
  open F

  let create__glue =
    foreign "create__glue"
      ( ptr lxc_container @-> string @-> string @-> ptr_opt Bdev_specs_glue.t
        @-> int @-> ptr_opt string @-> returning bool )

  (*$ #use "code_gen/gen.cinaps";;

       gen_lxc_container_funptr_field_ml_glue_all ()
  *)

  let is_defined__glue =
    foreign "is_defined__glue" (ptr lxc_container @-> returning bool)

  let state__glue =
    foreign "state__glue" (ptr lxc_container @-> returning string)

  let is_running__glue =
    foreign "is_running__glue" (ptr lxc_container @-> returning bool)

  let freeze__glue =
    foreign "freeze__glue" (ptr lxc_container @-> returning bool)

  let unfreeze__glue =
    foreign "unfreeze__glue" (ptr lxc_container @-> returning bool)

  let init_pid__glue =
    foreign "init_pid__glue" (ptr lxc_container @-> returning Posix_types.pid_t)

  let load_config__glue =
    foreign "load_config__glue"
      (ptr lxc_container @-> string @-> returning bool)

  let start__glue =
    foreign "start__glue"
      (ptr lxc_container @-> int @-> ptr string @-> returning bool)

  let stop__glue = foreign "stop__glue" (ptr lxc_container @-> returning bool)

  let want_daemonize__glue =
    foreign "want_daemonize__glue"
      (ptr lxc_container @-> bool @-> returning bool)

  let want_close_all_fds__glue =
    foreign "want_close_all_fds__glue"
      (ptr lxc_container @-> bool @-> returning bool)

  let config_file_name__glue =
    foreign "config_file_name__glue"
      (ptr lxc_container @-> returning (ptr char))

  let wait__glue =
    foreign "wait__glue"
      (ptr lxc_container @-> string @-> int @-> returning bool)

  let set_config_item__glue =
    foreign "set_config_item__glue"
      (ptr lxc_container @-> string @-> string @-> returning bool)

  let destroy__glue =
    foreign "destroy__glue" (ptr lxc_container @-> returning bool)

  let save_config__glue =
    foreign "save_config__glue"
      (ptr lxc_container @-> string @-> returning bool)

  let rename__glue =
    foreign "rename__glue" (ptr lxc_container @-> string @-> returning bool)

  let reboot__glue =
    foreign "reboot__glue" (ptr lxc_container @-> returning bool)

  let shutdown__glue =
    foreign "shutdown__glue" (ptr lxc_container @-> int @-> returning bool)

  let clear_config__glue =
    foreign "clear_config__glue" (ptr lxc_container @-> returning void)

  let clear_config_item__glue =
    foreign "clear_config_item__glue"
      (ptr lxc_container @-> string @-> returning bool)

  let get_config_item__glue =
    foreign "get_config_item__glue"
      (ptr lxc_container @-> string @-> ptr char @-> int @-> returning int)

  let get_running_config_item__glue =
    foreign "get_running_config_item__glue"
      (ptr lxc_container @-> string @-> returning (ptr char))

  let get_keys__glue =
    foreign "get_keys__glue"
      (ptr lxc_container @-> string @-> ptr char @-> int @-> returning int)

  let get_interfaces__glue =
    foreign "get_interfaces__glue"
      (ptr lxc_container @-> returning (ptr (ptr char)))

  let get_ips__glue =
    foreign "get_ips__glue"
      ( ptr lxc_container @-> string @-> string @-> int
        @-> returning (ptr (ptr char)) )

  let get_cgroup_item__glue =
    foreign "get_cgroup_item__glue"
      (ptr lxc_container @-> string @-> ptr char @-> int @-> returning int)

  let set_cgroup_item__glue =
    foreign "set_cgroup_item__glue"
      (ptr lxc_container @-> string @-> string @-> returning bool)

  let get_config_path__glue =
    foreign "get_config_path__glue" (ptr lxc_container @-> returning string)

  let set_config_path__glue =
    foreign "set_config_path__glue"
      (ptr lxc_container @-> string @-> returning bool)

  let clone__glue =
    foreign "clone__glue"
      ( ptr lxc_container @-> string @-> string @-> int @-> string @-> string
        @-> uint64_t
        @-> ptr (ptr char)
        @-> returning (ptr lxc_container) )

  let console_getfd__glue =
    foreign "console_getfd__glue"
      (ptr lxc_container @-> ptr int @-> ptr int @-> returning int)

  let console__glue =
    foreign "console__glue"
      ( ptr lxc_container @-> int @-> int @-> int @-> int @-> int
        @-> returning int )

  let attach_run_wait__glue =
    foreign "attach_run_wait__glue"
      ( ptr lxc_container @-> ptr Lxc_attach_options_t.t @-> string
        @-> ptr string @-> returning int )

  let snapshot__glue =
    foreign "snapshot__glue" (ptr lxc_container @-> string @-> returning int)

  let snapshot_list__glue =
    foreign "snapshot_list__glue"
      (ptr lxc_container @-> ptr (ptr Lxc_snapshot.t) @-> returning int)

  let snapshot_restore__glue =
    foreign "snapshot_restore__glue"
      (ptr lxc_container @-> string @-> string @-> returning bool)

  let snapshot_destroy__glue =
    foreign "snapshot_destroy__glue"
      (ptr lxc_container @-> string @-> returning bool)

  let may_control__glue =
    foreign "may_control__glue" (ptr lxc_container @-> returning bool)

  let add_device_node__glue =
    foreign "add_device_node__glue"
      (ptr lxc_container @-> string @-> string @-> returning bool)

  let remove_device_node__glue =
    foreign "remove_device_node__glue"
      (ptr lxc_container @-> string @-> string @-> returning bool)

  let attach_interface__glue =
    foreign "attach_interface__glue"
      (ptr lxc_container @-> string @-> string @-> returning bool)

  let detach_interface__glue =
    foreign "detach_interface__glue"
      (ptr lxc_container @-> string @-> string @-> returning bool)

  let checkpoint__glue =
    foreign "checkpoint__glue"
      (ptr lxc_container @-> ptr char @-> bool @-> bool @-> returning bool)

  let restore__glue =
    foreign "restore__glue"
      (ptr lxc_container @-> ptr char @-> bool @-> returning bool)

  let destroy_with_snapshots__glue =
    foreign "destroy_with_snapshots__glue"
      (ptr lxc_container @-> returning bool)

  let snapshot_destroy_all__glue =
    foreign "snapshot_destroy_all__glue" (ptr lxc_container @-> returning bool)

  let migrate__glue =
    foreign "migrate__glue"
      ( ptr lxc_container @-> uint @-> ptr Migrate_opts.t @-> uint
        @-> returning int )

  let console_log__glue =
    foreign "console_log__glue"
      (ptr lxc_container @-> ptr Lxc_console_log.t @-> returning int)

  let reboot2__glue =
    foreign "reboot2__glue" (ptr lxc_container @-> int @-> returning bool)

  let mount__glue =
    foreign "mount__glue"
      ( ptr lxc_container @-> string @-> string @-> string @-> ulong
        @-> ptr void @-> ptr Lxc_mount.t @-> returning int )

  let umount__glue =
    foreign "umount__glue"
      ( ptr lxc_container @-> string @-> ulong @-> ptr Lxc_mount.t
        @-> returning int )

  let seccomp_notify_fd__glue =
    foreign "seccomp_notify_fd__glue" (ptr lxc_container @-> returning int)

    (*$*)
end
