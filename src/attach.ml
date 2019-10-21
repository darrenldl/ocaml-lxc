open Ctypes
open Misc_utils
module Namespace_flags = Lxc_c.Namespace_flags
module Flags = Lxc_c.Lxc_attach_flags
module Env_policy = Stubs.Type_stubs.Lxc_attach_env_policy_t

module Options = struct
  module L = Stubs.Type_stubs.Lxc_attach_options_t

  type t =
    { attach_flags : Flags.t list
    ; namespace_flags : Namespace_flags.t list
    ; personality : int64
    ; initial_cwd : string option
    ; uid : int
    ; gid : int
    ; env_policy : Env_policy.t
    ; extra_env_vars : string list option
    ; extra_keep_env : string list option
    ; stdin_fd : int
    ; stdout_fd : int
    ; stderr_fd : int
    ; log_fd : int }

  type c_struct = Types.Lxc_attach_options_t.t structure

  let default =
    { attach_flags = [Flags.Attach_default]
    ; namespace_flags =
        (let open Namespace_flags in
         [ Clone_newcgroup
         ; Clone_newipc
         ; Clone_newnet
         ; Clone_newns
         ; Clone_newpid
         ; Clone_newuser
         ; Clone_newuts ])
    ; personality = -1L
    ; initial_cwd = None
    ; uid = -1
    ; gid = -1
    ; env_policy = Env_policy.Lxc_attach_keep_env
    ; extra_env_vars = None
    ; extra_keep_env = None
    ; stdin_fd = 0
    ; stdout_fd = 1
    ; stderr_fd = 2
    ; log_fd = -Stubs.Type_stubs.Errno.ebadf }

  let c_struct_of_t t =
    let c_struct = make L.t in
    setf c_struct L.attach_flags (lor_flags Flags.to_c_int t.attach_flags);
    setf c_struct L.namespaces
      (lor_flags Namespace_flags.to_c_int t.namespace_flags);
    setf c_struct L.personality (Signed.Long.of_int64 t.personality);
    setf c_struct L.initial_cwd t.initial_cwd;
    setf c_struct L.uid (Posix_types.Uid.of_int t.uid);
    setf c_struct L.gid (Posix_types.Gid.of_int t.gid);
    setf c_struct L.env_policy t.env_policy;
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
    setf c_struct L.stdin_fd t.stdin_fd;
    setf c_struct L.stdout_fd t.stdout_fd;
    setf c_struct L.stderr_fd t.stderr_fd;
    setf c_struct L.log_fd t.log_fd;
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
