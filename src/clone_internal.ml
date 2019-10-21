module Flags = Lxc_c.Lxc_clone_flags

module Options = struct
  type t =
    { new_name : string option
    ; lxcpath : string option
    ; flags : Flags.t list
    ; backing_store_type : Backing_store.store_type option
    (* ; backing_store_specs : Backing_store.Specs.t option *)
    ; new_size : int64
    ; hook_args : string list }

  let blank =
    { new_name = None
    ; lxcpath = None
    ; flags = []
    ; backing_store_type = None
    ; new_size = 0L
    ; hook_args = [] }
end
