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

                                      *)
                                      (*$*)
