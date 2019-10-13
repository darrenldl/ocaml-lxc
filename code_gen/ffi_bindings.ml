open Ctypes
open Types

module Func_stubs (F : Cstubs.FOREIGN) = struct
  open F

  let create_glue =
    foreign "create_glue"
      ( ptr lxc_container @-> string @-> string @-> ptr_opt Bdev_specs_glue.t
        @-> int @-> ptr_opt string @-> returning bool )
end
