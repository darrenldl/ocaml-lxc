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
