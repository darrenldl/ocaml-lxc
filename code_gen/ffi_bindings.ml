open Ctypes
open Types

module Fun_stubs (F : Cstubs.FOREIGN) = struct
  open F

       (*$*)
(*$*)

let create_glu =
  foreign "create_glu"
    ( ptr lxc_container @-> string @-> string @-> ptr_opt Bdev_specs_glue.t
      @-> int @-> ptr_opt string @-> returning bool )
end
