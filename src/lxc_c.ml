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
    ( ptr Stubs.lxc_container @-> string @-> string @-> ptr Stubs.Bdev_specs_glue.t
      @-> int @-> string @-> returning bool )
