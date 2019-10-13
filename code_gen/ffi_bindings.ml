open Ctypes
open Types

module Fun_stubs (F : Cstubs.FOREIGN) = struct
  open F

  let create__glue =
    foreign "create__glue"
      ( ptr lxc_container @-> string @-> string @-> ptr_opt Bdev_specs_glue.t
        @-> int @-> ptr_opt string @-> returning bool )

    (*$ #use "code_gen/gen.cinaps";;

         (* gen_lxc_container_funptr_field_ml_glue_all () *)
    *)
    (*$*)
end
