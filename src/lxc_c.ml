open Ctypes
open Types
open Stubs

exception Unexpected_value_from_C

exception Unexpected_value_from_ML

module Namespace_flags = struct
  open Type_stubs.Namespace_flags

  (*$
       let l =
         ["newcgroup"; "newipc"; "newnet"; "newns"; "newpid"; "newuser"; "newuts"]

       ;;
       print_endline "type t ="

       ;;
       List.iter (fun s -> Printf.printf "| Clone_%s\n" s) l

       ;;
       print_endline "let to_c_int t = match t with"

       ;;
       List.iter (fun s -> Printf.printf "| Clone_%s -> clone_%s\n" s s) l
  *)

  type t =
    | Clone_newcgroup
    | Clone_newipc
    | Clone_newnet
    | Clone_newns
    | Clone_newpid
    | Clone_newuser
    | Clone_newuts

  let to_c_int t =
    match t with
    | Clone_newcgroup ->
      clone_newcgroup
    | Clone_newipc ->
      clone_newipc
    | Clone_newnet ->
      clone_newnet
    | Clone_newns ->
      clone_newns
    | Clone_newpid ->
      clone_newpid
    | Clone_newuser ->
      clone_newuser
    | Clone_newuts ->
      clone_newuts

      (*$*)
end

module Lxc_attach_flags = struct
  open Type_stubs.Lxc_attach_flags

  (*$
       let l =
         [ "move_to_cgroup"
         ; "drop_capabilities"
         ; "set_personality"
         ; "lsm_exec"
         ; "remount_proc_sys"
         ; "lsm_now"
         ; "no_new_privs"
         ; "terminal"
         ; "default"
         ; "lsm" ]

       ;;
       print_endline "type t ="

       ;;
       List.iter (fun s -> Printf.printf "| Attach_%s\n" s) l

       ;;
       print_endline "let to_c_int t = match t with"

       ;;
       List.iter (fun s -> Printf.printf "| Attach_%s -> lxc_attach_%s\n" s s) l
  *)

  type t =
    | Attach_move_to_cgroup
    | Attach_drop_capabilities
    | Attach_set_personality
    | Attach_lsm_exec
    | Attach_remount_proc_sys
    | Attach_lsm_now
    | Attach_no_new_privs
    | Attach_terminal
    | Attach_default
    | Attach_lsm

  let to_c_int t =
    match t with
    | Attach_move_to_cgroup ->
      lxc_attach_move_to_cgroup
    | Attach_drop_capabilities ->
      lxc_attach_drop_capabilities
    | Attach_set_personality ->
      lxc_attach_set_personality
    | Attach_lsm_exec ->
      lxc_attach_lsm_exec
    | Attach_remount_proc_sys ->
      lxc_attach_remount_proc_sys
    | Attach_lsm_now ->
      lxc_attach_lsm_now
    | Attach_no_new_privs ->
      lxc_attach_no_new_privs
    | Attach_terminal ->
      lxc_attach_terminal
    | Attach_default ->
      lxc_attach_default
    | Attach_lsm ->
      lxc_attach_lsm

      (*$*)
end

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

module Feature_checks = struct
  open Stubs.Type_stubs.Feature_checks

  type t =
    | Feature_mem_track
    | Feature_lazy_pages

  let to_c_int t =
    match t with
    | Feature_mem_track ->
      feature_mem_track |> Unsigned.ULLong.to_int
    | Feature_lazy_pages ->
      feature_lazy_pages |> Unsigned.ULLong.to_int
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
      raise Unexpected_value_from_C
end

(*$
     List.iter
       (fun s -> Printf.printf "let %s = Fun_stubs.%s\n" s s)
       [ "create__glue"
       ; "lxc_container_new"
       ; "lxc_container_get"
       ; "lxc_container_put"
       ; "lxc_get_wait_states"
       ; "lxc_get_global_config_item"
       ; "lxc_get_version"
       ; "list_defined_containers"
       ; "list_active_containers"
       ; "list_all_containers"
       ; "lxc_log_init"
       ; "lxc_log_close"
       ; "lxc_config_item_is_supported"
       ; "lxc_has_api_extension" ]
*)

let create__glue = Fun_stubs.create__glue

let lxc_container_new = Fun_stubs.lxc_container_new

let lxc_container_get = Fun_stubs.lxc_container_get

let lxc_container_put = Fun_stubs.lxc_container_put

let lxc_get_wait_states = Fun_stubs.lxc_get_wait_states

let lxc_get_global_config_item = Fun_stubs.lxc_get_global_config_item

let lxc_get_version = Fun_stubs.lxc_get_version

let list_defined_containers = Fun_stubs.list_defined_containers

let list_active_containers = Fun_stubs.list_active_containers

let list_all_containers = Fun_stubs.list_all_containers

let lxc_log_init = Fun_stubs.lxc_log_init

let lxc_log_close = Fun_stubs.lxc_log_close

let lxc_config_item_is_supported = Fun_stubs.lxc_config_item_is_supported

let lxc_has_api_extension = Fun_stubs.lxc_has_api_extension

                            (*$*)

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
  f c

let state (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.state__raw in
  let f =
    coerce
      (field_type Type_stubs.state__raw)
      (Foreign.funptr (ptr lxc_container @-> returning string_opt))
      c_field
  in
  f c

let is_running (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.is_running__raw in
  let f =
    coerce
      (field_type Type_stubs.is_running__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f c

let freeze (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.freeze__raw in
  let f =
    coerce
      (field_type Type_stubs.freeze__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f c

let unfreeze (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.unfreeze__raw in
  let f =
    coerce
      (field_type Type_stubs.unfreeze__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f c

let init_pid (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.init_pid__raw in
  let f =
    coerce
      (field_type Type_stubs.init_pid__raw)
      (Foreign.funptr (ptr lxc_container @-> returning Posix_types.pid_t))
      c_field
  in
  f c

let load_config (c : Types.lxc_container structure ptr) a0 =
  let c_field = getf !@c Type_stubs.load_config__raw in
  let f =
    coerce
      (field_type Type_stubs.load_config__raw)
      (Foreign.funptr (ptr lxc_container @-> string_opt @-> returning bool))
      c_field
  in
  f c a0

let start (c : Types.lxc_container structure ptr) a0 a1 =
  let c_field = getf !@c Type_stubs.start__raw in
  let f =
    coerce
      (field_type Type_stubs.start__raw)
      (Foreign.funptr
         (ptr lxc_container @-> int @-> ptr (ptr char) @-> returning bool))
      c_field
  in
  f c a0 a1

let stop (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.stop__raw in
  let f =
    coerce
      (field_type Type_stubs.stop__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f c

let want_daemonize (c : Types.lxc_container structure ptr) a0 =
  let c_field = getf !@c Type_stubs.want_daemonize__raw in
  let f =
    coerce
      (field_type Type_stubs.want_daemonize__raw)
      (Foreign.funptr (ptr lxc_container @-> bool @-> returning bool))
      c_field
  in
  f c a0

let want_close_all_fds (c : Types.lxc_container structure ptr) a0 =
  let c_field = getf !@c Type_stubs.want_close_all_fds__raw in
  let f =
    coerce
      (field_type Type_stubs.want_close_all_fds__raw)
      (Foreign.funptr (ptr lxc_container @-> bool @-> returning bool))
      c_field
  in
  f c a0

let config_file_name (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.config_file_name__raw in
  let f =
    coerce
      (field_type Type_stubs.config_file_name__raw)
      (Foreign.funptr (ptr lxc_container @-> returning (ptr char)))
      c_field
  in
  f c

let wait (c : Types.lxc_container structure ptr) a0 a1 =
  let c_field = getf !@c Type_stubs.wait__raw in
  let f =
    coerce
      (field_type Type_stubs.wait__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string_opt @-> int @-> returning bool))
      c_field
  in
  f c a0 a1

let set_config_item (c : Types.lxc_container structure ptr) a0 a1 =
  let c_field = getf !@c Type_stubs.set_config_item__raw in
  let f =
    coerce
      (field_type Type_stubs.set_config_item__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool))
      c_field
  in
  f c a0 a1

let destroy (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.destroy__raw in
  let f =
    coerce
      (field_type Type_stubs.destroy__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f c

let save_config (c : Types.lxc_container structure ptr) a0 =
  let c_field = getf !@c Type_stubs.save_config__raw in
  let f =
    coerce
      (field_type Type_stubs.save_config__raw)
      (Foreign.funptr (ptr lxc_container @-> string_opt @-> returning bool))
      c_field
  in
  f c a0

let rename (c : Types.lxc_container structure ptr) a0 =
  let c_field = getf !@c Type_stubs.rename__raw in
  let f =
    coerce
      (field_type Type_stubs.rename__raw)
      (Foreign.funptr (ptr lxc_container @-> string_opt @-> returning bool))
      c_field
  in
  f c a0

let reboot (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.reboot__raw in
  let f =
    coerce
      (field_type Type_stubs.reboot__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f c

let shutdown (c : Types.lxc_container structure ptr) a0 =
  let c_field = getf !@c Type_stubs.shutdown__raw in
  let f =
    coerce
      (field_type Type_stubs.shutdown__raw)
      (Foreign.funptr (ptr lxc_container @-> int @-> returning bool))
      c_field
  in
  f c a0

let clear_config (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.clear_config__raw in
  let f =
    coerce
      (field_type Type_stubs.clear_config__raw)
      (Foreign.funptr (ptr lxc_container @-> returning void))
      c_field
  in
  f c

let clear_config_item (c : Types.lxc_container structure ptr) a0 =
  let c_field = getf !@c Type_stubs.clear_config_item__raw in
  let f =
    coerce
      (field_type Type_stubs.clear_config_item__raw)
      (Foreign.funptr (ptr lxc_container @-> string_opt @-> returning bool))
      c_field
  in
  f c a0

let get_config_item (c : Types.lxc_container structure ptr) a0 a1 a2 =
  let c_field = getf !@c Type_stubs.get_config_item__raw in
  let f =
    coerce
      (field_type Type_stubs.get_config_item__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> string_opt @-> ptr char @-> int
           @-> returning int ))
      c_field
  in
  f c a0 a1 a2

let get_running_config_item (c : Types.lxc_container structure ptr) a0 =
  let c_field = getf !@c Type_stubs.get_running_config_item__raw in
  let f =
    coerce
      (field_type Type_stubs.get_running_config_item__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string_opt @-> returning (ptr char)))
      c_field
  in
  f c a0

let get_keys (c : Types.lxc_container structure ptr) a0 a1 a2 =
  let c_field = getf !@c Type_stubs.get_keys__raw in
  let f =
    coerce
      (field_type Type_stubs.get_keys__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> string_opt @-> ptr char @-> int
           @-> returning int ))
      c_field
  in
  f c a0 a1 a2

let get_interfaces (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.get_interfaces__raw in
  let f =
    coerce
      (field_type Type_stubs.get_interfaces__raw)
      (Foreign.funptr (ptr lxc_container @-> returning (ptr (ptr char))))
      c_field
  in
  f c

let get_ips (c : Types.lxc_container structure ptr) a0 a1 a2 =
  let c_field = getf !@c Type_stubs.get_ips__raw in
  let f =
    coerce
      (field_type Type_stubs.get_ips__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> string_opt @-> string_opt @-> int
           @-> returning (ptr (ptr char)) ))
      c_field
  in
  f c a0 a1 a2

let get_cgroup_item (c : Types.lxc_container structure ptr) a0 a1 a2 =
  let c_field = getf !@c Type_stubs.get_cgroup_item__raw in
  let f =
    coerce
      (field_type Type_stubs.get_cgroup_item__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> string_opt @-> ptr char @-> int
           @-> returning int ))
      c_field
  in
  f c a0 a1 a2

let set_cgroup_item (c : Types.lxc_container structure ptr) a0 a1 =
  let c_field = getf !@c Type_stubs.set_cgroup_item__raw in
  let f =
    coerce
      (field_type Type_stubs.set_cgroup_item__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool))
      c_field
  in
  f c a0 a1

let get_config_path (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.get_config_path__raw in
  let f =
    coerce
      (field_type Type_stubs.get_config_path__raw)
      (Foreign.funptr (ptr lxc_container @-> returning string_opt))
      c_field
  in
  f c

let set_config_path (c : Types.lxc_container structure ptr) a0 =
  let c_field = getf !@c Type_stubs.set_config_path__raw in
  let f =
    coerce
      (field_type Type_stubs.set_config_path__raw)
      (Foreign.funptr (ptr lxc_container @-> string_opt @-> returning bool))
      c_field
  in
  f c a0

let clone (c : Types.lxc_container structure ptr) a0 a1 a2 a3 a4 a5 a6 =
  let c_field = getf !@c Type_stubs.clone__raw in
  let f =
    coerce
      (field_type Type_stubs.clone__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> string_opt @-> string_opt @-> int
           @-> string_opt @-> string_opt @-> uint64_t
           @-> ptr (ptr char)
           @-> returning (ptr lxc_container) ))
      c_field
  in
  f c a0 a1 a2 a3 a4 a5 a6

let console_getfd (c : Types.lxc_container structure ptr) a0 a1 =
  let c_field = getf !@c Type_stubs.console_getfd__raw in
  let f =
    coerce
      (field_type Type_stubs.console_getfd__raw)
      (Foreign.funptr
         (ptr lxc_container @-> ptr int @-> ptr int @-> returning int))
      c_field
  in
  f c a0 a1

let console (c : Types.lxc_container structure ptr) a0 a1 a2 a3 a4 =
  let c_field = getf !@c Type_stubs.console__raw in
  let f =
    coerce
      (field_type Type_stubs.console__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> int @-> int @-> int @-> int @-> int
           @-> returning int ))
      c_field
  in
  f c a0 a1 a2 a3 a4

let attach_run_wait (c : Types.lxc_container structure ptr) a0 a1 a2 =
  let c_field = getf !@c Type_stubs.attach_run_wait__raw in
  let f =
    coerce
      (field_type Type_stubs.attach_run_wait__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> ptr Lxc_attach_options_t.t @-> string_opt
           @-> ptr (ptr char)
           @-> returning int ))
      c_field
  in
  f c a0 a1 a2

let snapshot (c : Types.lxc_container structure ptr) a0 =
  let c_field = getf !@c Type_stubs.snapshot__raw in
  let f =
    coerce
      (field_type Type_stubs.snapshot__raw)
      (Foreign.funptr (ptr lxc_container @-> string_opt @-> returning int))
      c_field
  in
  f c a0

let snapshot_list (c : Types.lxc_container structure ptr) a0 =
  let c_field = getf !@c Type_stubs.snapshot_list__raw in
  let f =
    coerce
      (field_type Type_stubs.snapshot_list__raw)
      (Foreign.funptr
         (ptr lxc_container @-> ptr (ptr Lxc_snapshot.t) @-> returning int))
      c_field
  in
  f c a0

let snapshot_restore (c : Types.lxc_container structure ptr) a0 a1 =
  let c_field = getf !@c Type_stubs.snapshot_restore__raw in
  let f =
    coerce
      (field_type Type_stubs.snapshot_restore__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool))
      c_field
  in
  f c a0 a1

let snapshot_destroy (c : Types.lxc_container structure ptr) a0 =
  let c_field = getf !@c Type_stubs.snapshot_destroy__raw in
  let f =
    coerce
      (field_type Type_stubs.snapshot_destroy__raw)
      (Foreign.funptr (ptr lxc_container @-> string_opt @-> returning bool))
      c_field
  in
  f c a0

let may_control (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.may_control__raw in
  let f =
    coerce
      (field_type Type_stubs.may_control__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f c

let add_device_node (c : Types.lxc_container structure ptr) a0 a1 =
  let c_field = getf !@c Type_stubs.add_device_node__raw in
  let f =
    coerce
      (field_type Type_stubs.add_device_node__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool))
      c_field
  in
  f c a0 a1

let remove_device_node (c : Types.lxc_container structure ptr) a0 a1 =
  let c_field = getf !@c Type_stubs.remove_device_node__raw in
  let f =
    coerce
      (field_type Type_stubs.remove_device_node__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool))
      c_field
  in
  f c a0 a1

let attach_interface (c : Types.lxc_container structure ptr) a0 a1 =
  let c_field = getf !@c Type_stubs.attach_interface__raw in
  let f =
    coerce
      (field_type Type_stubs.attach_interface__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool))
      c_field
  in
  f c a0 a1

let detach_interface (c : Types.lxc_container structure ptr) a0 a1 =
  let c_field = getf !@c Type_stubs.detach_interface__raw in
  let f =
    coerce
      (field_type Type_stubs.detach_interface__raw)
      (Foreign.funptr
         (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool))
      c_field
  in
  f c a0 a1

let checkpoint (c : Types.lxc_container structure ptr) a0 a1 a2 =
  let c_field = getf !@c Type_stubs.checkpoint__raw in
  let f =
    coerce
      (field_type Type_stubs.checkpoint__raw)
      (Foreign.funptr
         (ptr lxc_container @-> ptr char @-> bool @-> bool @-> returning bool))
      c_field
  in
  f c a0 a1 a2

let restore (c : Types.lxc_container structure ptr) a0 a1 =
  let c_field = getf !@c Type_stubs.restore__raw in
  let f =
    coerce
      (field_type Type_stubs.restore__raw)
      (Foreign.funptr
         (ptr lxc_container @-> ptr char @-> bool @-> returning bool))
      c_field
  in
  f c a0 a1

let destroy_with_snapshots (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.destroy_with_snapshots__raw in
  let f =
    coerce
      (field_type Type_stubs.destroy_with_snapshots__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f c

let snapshot_destroy_all (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.snapshot_destroy_all__raw in
  let f =
    coerce
      (field_type Type_stubs.snapshot_destroy_all__raw)
      (Foreign.funptr (ptr lxc_container @-> returning bool))
      c_field
  in
  f c

let migrate (c : Types.lxc_container structure ptr) a0 a1 a2 =
  let c_field = getf !@c Type_stubs.migrate__raw in
  let f =
    coerce
      (field_type Type_stubs.migrate__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> uint @-> ptr Migrate_opts.t @-> uint
           @-> returning int ))
      c_field
  in
  f c a0 a1 a2

let console_log (c : Types.lxc_container structure ptr) a0 =
  let c_field = getf !@c Type_stubs.console_log__raw in
  let f =
    coerce
      (field_type Type_stubs.console_log__raw)
      (Foreign.funptr
         (ptr lxc_container @-> ptr Lxc_console_log.t @-> returning int))
      c_field
  in
  f c a0

let reboot2 (c : Types.lxc_container structure ptr) a0 =
  let c_field = getf !@c Type_stubs.reboot2__raw in
  let f =
    coerce
      (field_type Type_stubs.reboot2__raw)
      (Foreign.funptr (ptr lxc_container @-> int @-> returning bool))
      c_field
  in
  f c a0

let mount (c : Types.lxc_container structure ptr) a0 a1 a2 a3 a4 a5 =
  let c_field = getf !@c Type_stubs.mount__raw in
  let f =
    coerce
      (field_type Type_stubs.mount__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> string_opt @-> string_opt @-> string_opt
           @-> ulong @-> ptr void @-> ptr Lxc_mount.t @-> returning int ))
      c_field
  in
  f c a0 a1 a2 a3 a4 a5

let umount (c : Types.lxc_container structure ptr) a0 a1 a2 =
  let c_field = getf !@c Type_stubs.umount__raw in
  let f =
    coerce
      (field_type Type_stubs.umount__raw)
      (Foreign.funptr
         ( ptr lxc_container @-> string_opt @-> ulong @-> ptr Lxc_mount.t
           @-> returning int ))
      c_field
  in
  f c a0 a1 a2

let seccomp_notify_fd (c : Types.lxc_container structure ptr) =
  let c_field = getf !@c Type_stubs.seccomp_notify_fd__raw in
  let f =
    coerce
      (field_type Type_stubs.seccomp_notify_fd__raw)
      (Foreign.funptr (ptr lxc_container @-> returning int))
      c_field
  in
  f c

  (*$*)
