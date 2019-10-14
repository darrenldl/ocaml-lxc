open Ctypes
open Types

module Fun_stubs (F : Cstubs.FOREIGN) = struct
  open F

  let create__glue =
    foreign "create__glue"
      ( ptr lxc_container @-> string @-> string @-> ptr_opt Bdev_specs__glue.t
        @-> int @-> ptr_opt string @-> returning bool )

  let lxc_container_new =
    foreign "lxc_container_new"
      (string @-> string @-> returning (ptr_opt Types.lxc_container))

  let lxc_container_get =
    foreign "lxc_container_get" (ptr Types.lxc_container @-> returning int)

  let lxc_container_put =
    foreign "lxc_container_put" (ptr Types.lxc_container @-> returning int)

  let lxc_get_wait_states =
    foreign "lxc_get_wait_states" (ptr string @-> returning int)

  let lxc_get_global_config_item =
    foreign "lxc_get_global_config_item" (string @-> returning string)

  let lxc_get_version = foreign "lxc_get_version" (void @-> returning string)

  let list_defined_containers =
    foreign "list_defined_containers"
      ( string
        @-> ptr (ptr (ptr char))
        @-> ptr (ptr (ptr Types.lxc_container))
        @-> returning int )

  let list_active_containers =
    foreign "list_active_containers"
      ( string
        @-> ptr (ptr (ptr char))
        @-> ptr (ptr (ptr Types.lxc_container))
        @-> returning int )

  let list_all_containers =
    foreign "list_all_containers"
      ( string
        @-> ptr (ptr (ptr char))
        @-> ptr (ptr (ptr Types.lxc_container))
        @-> returning int )

  let lxc_log_init =
    foreign "lxc_log_init" (ptr Types.Lxc_log.t @-> returning int)

  let lxc_log_close = foreign "lxc_log_close" (void @-> returning void)

  let lxc_config_item_is_supported =
    foreign "lxc_config_item_is_supported" (string @-> returning bool)

  let lxc_has_api_extension =
    foreign "lxc_has_api_extension" (string @-> returning bool)
end
