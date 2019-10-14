open Ctypes
open Types

module Fun_stubs (F : Cstubs.FOREIGN) = struct
  open F

  let create__glue =
    foreign "create__glue"
      ( ptr lxc_container @-> string @-> string @-> ptr_opt Bdev_specs__glue.t
        @-> int @-> ptr_opt string @-> returning bool )
end
