open Ctypes
module Stubs = Ffi_bindings.Stubs (Ml_stubs)

module Migrate_cmd = struct
  open Stubs.Migrate_cmd

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

let create_glue =
  Foreign.foreign "create_glue"
    ( ptr Stubs.lxc_container @-> string @-> string
      @-> ptr_opt Stubs.Bdev_specs_glue.t
      @-> int @-> ptr_opt string @-> returning bool )

let lxc_container_new =
  Foreign.foreign "lxc_container_new"
    (string @-> string @-> returning (ptr_opt Stubs.lxc_container))

let lxc_container_get =
  Foreign.foreign "lxc_container_get"
    (ptr Stubs.lxc_container @-> returning int)

let lxc_container_put =
  Foreign.foreign "lxc_container_put"
    (ptr Stubs.lxc_container @-> returning int)

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
      @-> ptr (ptr (ptr Stubs.lxc_container))
      @-> returning int )

let list_active_containers =
  Foreign.foreign "list_active_containers"
    ( string
      @-> ptr (ptr (ptr char))
      @-> ptr (ptr (ptr Stubs.lxc_container))
      @-> returning int )

let list_all_containers =
  Foreign.foreign "list_all_containers"
    ( string
      @-> ptr (ptr (ptr char))
      @-> ptr (ptr (ptr Stubs.lxc_container))
      @-> returning int )

let lxc_log_init =
  Foreign.foreign "lxc_log_init" (ptr Stubs.Lxc_log.t @-> returning int)

let lxc_log_close = Foreign.foreign "lxc_log_close" (void @-> returning void)

let lxc_config_item_is_supported =
  Foreign.foreign "lxc_config_item_is_supported" (string @-> returning bool)

let lxc_has_api_extension =
  Foreign.foreign "lxc_has_api_extension" (string @-> returning bool)
