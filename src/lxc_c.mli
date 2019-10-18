open Ctypes
open Types

exception Unexpected_value_from_C

exception Unexpected_value_from_ML

module Namespace_flags : sig
  type t =
    | Clone_newcgroup
    | Clone_newipc
    | Clone_newnet
    | Clone_newns
    | Clone_newpid
    | Clone_newuser
    | Clone_newuts

  val to_c_int : t -> int
end

module Lxc_attach_flags : sig
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

  val to_c_int : t -> int
end

module Migrate_cmd : sig
  type t =
    | Migrate_pre_dump
    | Migrate_dump
    | Migrate_restore
    | Migrate_feature_check

  val to_c_int : t -> int64
end

module Feature_checks : sig
  type t =
    | Feature_mem_track
    | Feature_lazy_pages

  val to_c_int : t -> int
end

module State : sig
  type t =
    | Stopped
    | Starting
    | Running
    | Stopping
    | Aborting
    | Freezing
    | Frozen
    | Thawed

  val to_string : t -> string

  val of_string : string -> t
end

val create__glue :
  lxc_container structure ptr
  -> string
  -> string option
  -> Bdev_specs__glue.t structure ptr option
  -> int
  -> char ptr ptr
  -> bool

val lxc_container_new :
  string -> string option -> lxc_container structure ptr option

val lxc_container_get : lxc_container structure ptr -> int

val lxc_container_put : lxc_container structure ptr -> int

val lxc_get_wait_states : string ptr -> int

val lxc_get_global_config_item : string -> char ptr

val lxc_get_version : unit -> string

val list_defined_containers :
  string option
  -> char ptr ptr ptr
  -> lxc_container structure ptr ptr ptr
  -> int

val list_active_containers :
  string option
  -> char ptr ptr ptr
  -> lxc_container structure ptr ptr ptr
  -> int

val list_all_containers :
  string option
  -> char ptr ptr ptr
  -> lxc_container structure ptr ptr ptr
  -> int

val lxc_log_init : Lxc_log.t structure ptr -> int

val lxc_log_close : unit -> unit

val lxc_config_item_is_supported : string -> bool

val lxc_has_api_extension : string -> bool

(*$ #use "code_gen/gen.cinaps";;

     For_lxc_c_dot_mli.gen_lxc_container_funptr_field_ml_wrapper_sig_all ()
*)

val is_defined : Types.lxc_container structure ptr -> bool

val state : Types.lxc_container structure ptr -> string option

val is_running : Types.lxc_container structure ptr -> bool

val freeze : Types.lxc_container structure ptr -> bool

val unfreeze : Types.lxc_container structure ptr -> bool

val init_pid : Types.lxc_container structure ptr -> Posix_types.pid_t

val load_config : Types.lxc_container structure ptr -> string option -> bool

val start : Types.lxc_container structure ptr -> int -> char ptr ptr -> bool

val stop : Types.lxc_container structure ptr -> bool

val want_daemonize : Types.lxc_container structure ptr -> bool -> bool

val want_close_all_fds : Types.lxc_container structure ptr -> bool -> bool

val config_file_name : Types.lxc_container structure ptr -> char ptr

val wait : Types.lxc_container structure ptr -> string option -> int -> bool

val set_config_item :
  Types.lxc_container structure ptr -> string option -> string option -> bool

val destroy : Types.lxc_container structure ptr -> bool

val save_config : Types.lxc_container structure ptr -> string option -> bool

val rename : Types.lxc_container structure ptr -> string option -> bool

val reboot : Types.lxc_container structure ptr -> bool

val shutdown : Types.lxc_container structure ptr -> int -> bool

val clear_config : Types.lxc_container structure ptr -> unit

val clear_config_item :
  Types.lxc_container structure ptr -> string option -> bool

val get_config_item :
  Types.lxc_container structure ptr -> string option -> char ptr -> int -> int

val get_running_config_item :
  Types.lxc_container structure ptr -> string option -> char ptr

val get_keys :
  Types.lxc_container structure ptr -> string option -> char ptr -> int -> int

val get_interfaces : Types.lxc_container structure ptr -> char ptr ptr

val get_ips :
  Types.lxc_container structure ptr
  -> string option
  -> string option
  -> int
  -> char ptr ptr

val get_cgroup_item :
  Types.lxc_container structure ptr -> string option -> char ptr -> int -> int

val set_cgroup_item :
  Types.lxc_container structure ptr -> string option -> string option -> bool

val get_config_path : Types.lxc_container structure ptr -> string option

val set_config_path :
  Types.lxc_container structure ptr -> string option -> bool

val clone :
  Types.lxc_container structure ptr
  -> string option
  -> string option
  -> int
  -> string option
  -> string option
  -> Unsigned.uint64
  -> char ptr ptr
  -> lxc_container structure ptr

val console_getfd :
  Types.lxc_container structure ptr -> int ptr -> int ptr -> int

val console :
  Types.lxc_container structure ptr -> int -> int -> int -> int -> int -> int

val attach_run_wait :
  Types.lxc_container structure ptr
  -> Lxc_attach_options_t.t structure ptr
  -> string option
  -> char ptr ptr
  -> int

val snapshot : Types.lxc_container structure ptr -> string option -> int

val snapshot_list :
  Types.lxc_container structure ptr -> Lxc_snapshot.t structure ptr ptr -> int

val snapshot_restore :
  Types.lxc_container structure ptr -> string option -> string option -> bool

val snapshot_destroy :
  Types.lxc_container structure ptr -> string option -> bool

val may_control : Types.lxc_container structure ptr -> bool

val add_device_node :
  Types.lxc_container structure ptr -> string option -> string option -> bool

val remove_device_node :
  Types.lxc_container structure ptr -> string option -> string option -> bool

val attach_interface :
  Types.lxc_container structure ptr -> string option -> string option -> bool

val detach_interface :
  Types.lxc_container structure ptr -> string option -> string option -> bool

val checkpoint :
  Types.lxc_container structure ptr -> char ptr -> bool -> bool -> bool

val restore : Types.lxc_container structure ptr -> char ptr -> bool -> bool

val destroy_with_snapshots : Types.lxc_container structure ptr -> bool

val snapshot_destroy_all : Types.lxc_container structure ptr -> bool

val migrate :
  Types.lxc_container structure ptr
  -> Unsigned.uint
  -> Migrate_opts.t structure ptr
  -> Unsigned.uint
  -> int

val console_log :
  Types.lxc_container structure ptr -> Lxc_console_log.t structure ptr -> int

val reboot2 : Types.lxc_container structure ptr -> int -> bool

val mount :
  Types.lxc_container structure ptr
  -> string option
  -> string option
  -> string option
  -> Unsigned.ulong
  -> unit ptr
  -> Lxc_mount.t structure ptr
  -> int

val umount :
  Types.lxc_container structure ptr
  -> string option
  -> Unsigned.ulong
  -> Lxc_mount.t structure ptr
  -> int

val seccomp_notify_fd : Types.lxc_container structure ptr -> int

                                                             (*$*)
