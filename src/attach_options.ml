open Ctypes
open Misc_utils
module Namespace_flags = Lxc_c.Namespace_flags
module Attach_flags = Lxc_c.Lxc_attach_flags
module L = Stubs.Type_stubs.Lxc_attach_options_t

type t =
  { attach_flags : Attach_flags.t list
  ; namespace_flags : Namespace_flags.t list
  ; personality : int64
  ; initial_cwd : string option
  ; uid : int
  ; gid : int
  ; extra_env_vars : string list option
  ; extra_keep_env : string list option
  ; stdin_fd : int
  ; stdout_fd : int
  ; stderr_fd : int
  ; log_fd : int }

let default =
  { attach_flags = [Attach_flags.Attach_default]
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
  ; (* env_policy =
     *   Attach_env *)
    extra_env_vars = None
  ; extra_keep_env = None
  ; stdin_fd = 0
  ; stdout_fd = 1
  ; stderr_fd = 2
  ; log_fd = -Stubs.Type_stubs.Errno.ebadf }

type c_struct = Types.Lxc_attach_options_t.t structure

let make ?(personality = -1L) ?initial_cwd ?(uid = -1) ?(gid = -1)
    (attach_flags : Attach_flags.t list)
    (namespace_flags : Namespace_flags.t list) env_policy ~extra_env_vars
    ~extra_keep_env ~stdin_fd ~stdout_fd ~stderr_fd ~log_fd =
  let t = make L.t in
  setf t L.attach_flags (lor_flags Attach_flags.to_c_int attach_flags);
  setf t L.namespaces (lor_flags Namespace_flags.to_c_int namespace_flags);
  setf t L.personality (Signed.Long.of_int64 personality);
  setf t L.initial_cwd initial_cwd;
  setf t L.uid (Posix_types.Uid.of_int uid);
  setf t L.gid (Posix_types.Gid.of_int gid);
  setf t L.env_policy env_policy;
  setf t L.extra_env_vars extra_env_vars;
  setf t L.extra_keep_env extra_keep_env;
  setf t L.stdin_fd stdin_fd;
  setf t L.stdout_fd stdout_fd;
  setf t L.stderr_fd stderr_fd;
  setf t L.log_fd log_fd;
  t

let default () =
  let t = Ctypes.make L.t in
  setf t L.attach_flags
    (lor_flags Attach_flags.to_c_int [Attach_flags.Attach_default]);
  setf t L.namespaces (-1);
  setf t L.personality (Signed.Long.of_int (-1));
  setf t L.initial_cwd None;
  setf t L.uid (Posix_types.Uid.of_int (-1));
  setf t L.gid (Posix_types.Gid.of_int (-1));
  setf t L.env_policy
    Stubs.Type_stubs.Lxc_attach_env_policy_t.Lxc_attach_keep_env;
  setf t L.extra_env_vars (make_null_ptr (ptr (ptr char)));
  setf t L.extra_keep_env (make_null_ptr (ptr (ptr char)));
  setf t L.stdin_fd 0;
  setf t L.stdout_fd 1;
  setf t L.stderr_fd 2;
  setf t L.log_fd (-Stubs.Type_stubs.Errno.ebadf);
  t
