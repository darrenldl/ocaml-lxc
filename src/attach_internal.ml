open Ctypes
open Misc_utils
module Namespace_flags = Lxc_c.Namespace_flags
module Flags = Lxc_c.Lxc_attach_flags
module Env_policy = Stubs.Type_stubs.Lxc_attach_env_policy_t

module Options = struct
  module L = Stubs.Type_stubs.Lxc_attach_options_t

  type t =
    { attach_flags : Flags.t list option
    ; namespace_flags : Namespace_flags.t list option
    ; personality : int64 option
    ; initial_cwd : string option
    ; uid : int option
    ; gid : int option
    ; env_policy : Env_policy.t option
    ; extra_env_vars : string list option
    ; extra_keep_env : string list option
    ; stdin_fd : int option
    ; stdout_fd : int option
    ; stderr_fd : int option
    ; log_fd : int option }

  type c_struct = Types.Lxc_attach_options_t.t structure

  let default =
    { attach_flags = None
    ; namespace_flags = None
    ; personality = None
    ; initial_cwd = None
    ; uid = None
    ; gid = None
    ; env_policy = None
    ; extra_env_vars = None
    ; extra_keep_env = None
    ; stdin_fd = None
    ; stdout_fd = None
    ; stderr_fd = None
    ; log_fd = None }

  let c_struct_of_t t =
    let id x = x in
    let default_ptr = Lxc_c.get_lxc_attach_options_default__glue () in
    let c_struct = make L.t in
    let aux c_struct_field field f =
      setf c_struct c_struct_field (match field with
          | None -> getf !@default_ptr c_struct_field
          | Some v -> f v
        )
    in
    aux L.attach_flags t.attach_flags (lor_flags Flags.to_c_int);
    aux L.namespaces t.namespace_flags (lor_flags Namespace_flags.to_c_int);
    aux L.personality t.personality (Signed.Long.of_int64);
    setf c_struct L.initial_cwd t.initial_cwd;
    aux L.uid t.uid Posix_types.Uid.of_int;
    aux L.gid t.gid Posix_types.Gid.of_int;
    aux L.env_policy t.env_policy id;
    let extra_env_vars =
      match t.extra_env_vars with
      | None ->
        make_null_ptr (ptr (ptr char))
      | Some l ->
        string_arr_ptr_from_string_list l
    in
    setf c_struct L.extra_env_vars extra_env_vars;
    let extra_keep_env =
      match t.extra_keep_env with
      | None ->
        make_null_ptr (ptr (ptr char))
      | Some l ->
        string_arr_ptr_from_string_list l
    in
    setf c_struct L.extra_keep_env extra_keep_env;
    aux L.stdin_fd t.stdin_fd id;
    aux L.stdout_fd t.stdout_fd id;
    aux L.stderr_fd t.stderr_fd id;
    aux L.log_fd t.log_fd id;
    c_struct
end

module Command = struct
  module L = Stubs.Type_stubs.Lxc_attach_command_t

  let c_struct_of_string_array arr =
    let c_struct = Ctypes.make L.t in
    setf c_struct L.program arr.(0);
    let argv =
      match arr with
      | [||] ->
        failwith "Unexpected empty array"
      | _ ->
        string_arr_ptr_from_string_arr arr
    in
    setf c_struct L.argv argv; c_struct
end
