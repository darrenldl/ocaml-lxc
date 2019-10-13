open Types

module Types_stubs (S : Cstubs_structs.TYPE) = struct
  open S

  module Posix = struct
    let pid_t = S.lift_typ PosixTypes.pid_t

    let uid_t = S.lift_typ Posix_types.uid_t

    let gid_t = S.lift_typ Posix_types.gid_t
  end

  module Lxc_attach_env_policy_t = struct
    let lxc_attach_keep_env = S.constant "LXC_ATTACH_KEEP_ENV" int64_t

    let lxc_attach_clear_env = S.constant "LXC_ATTACH_CLEAR_ENV" int64_t

    type t =
      | Lxc_attach_keep_env
      | Lxc_attach_clear_env

    let t =
      enum "lxc_attach_env_policy_t" ~typedef:true
        [ (Lxc_attach_keep_env, lxc_attach_keep_env)
        ; (Lxc_attach_clear_env, lxc_attach_clear_env) ]
  end

  module Lxc_attach_flags = struct
    let lxc_attach_move_to_cgroup = S.constant "LXC_ATTACH_MOVE_TO_CGROUP" int

    let lxc_attach_drop_capabilities =
      S.constant "LXC_ATTACH_DROP_CAPABILITIES" int

    let lxc_attach_set_personality =
      S.constant "LXC_ATTACH_SET_PERSONALITY" int

    let lxc_attach_lsm_exec = S.constant "LXC_ATTACH_LSM_EXEC" int

    let lxc_attach_remount_proc_sys =
      S.constant "LXC_ATTACH_REMOUNT_PROC_SYS" int

    let lxc_attach_lsm_now = S.constant "LXC_ATTACH_LSM_NOW" int

    let lxc_attach_no_new_privs = S.constant "LXC_ATTACH_NO_NEW_PRIVS" int

    let lxc_attach_terminal = S.constant "LXC_ATTACH_TERMINAL" int

    let lxc_attach_default = S.constant "LXC_ATTACH_DEFAULT" int

    let lxc_attach_lsm = S.constant "LXC_ATTACH_LSM" int
  end

  module Lxc_attach_options = struct
    type lxc_attach_options_t

    type t = lxc_attach_options_t Ctypes.structure

    let t : t typ = structure "lxc_attach_options_t"

    let attach_flags = field t "attach_flags" int

    let namespaces = field t "namespaces" int

    let personality = field t "personality" int

    let initial_cwd = field t "initial_cwd" (ptr char)

    let uid = field t "uid" Posix.uid_t

    let gid = field t "gid" Posix.gid_t

    let env_policy = field t "env_policy" Lxc_attach_env_policy_t.t

    let extra_env_vars = field t "extra_env_vars" (ptr (ptr char))

    let extra_keep_env = field t "extra_keep_env" (ptr (ptr char))

    let stdin_fd = field t "stdin_fd" int

    let stdout_fd = field t "stdout_fd" int

    let stderr_fd = field t "stderr_fd" int

    let log_fd = field t "log_fd" int
  end

  module Lxc_snapshot = struct
    type lxc_snapshot

    type t = lxc_snapshot Ctypes.structure

    let t : t typ = structure "lxc_snapshot"

    let name = S.(field t "name" string)

    let comment_pathname = field t "comment_pathname" string

    let timestamp = field t "timestamp" string

    let lxcpath = field t "lxcpath" string

    let free = field t "free" (static_funptr (ptr t @-> returning void))

    let () = seal t
  end

  module Bdev_specs_glue = struct
    module Zfs_glue = struct
      type zfs_glue

      type t = zfs_glue Ctypes.structure

      let t : t typ = structure "zfs_glue"

      let zfsroot = field t "zfsroot" string

      let () = seal t
    end

    module Lvm_glue = struct
      type lvm_glue

      type t = lvm_glue Ctypes.structure

      let t : t typ = structure "lvm_glue"

      let vg = field t "vg" string

      let lv = field t "lv" string

      let thinpool = field t "thinpool" string

      let () = seal t
    end

    module Rbd_glue = struct
      type rbd_glue

      type t = rbd_glue Ctypes.structure

      let t : t typ = structure "rbd_glue"

      let rbdname = field t "rbdname" string

      let rbdpool = field t "rbdpool" string

      let () = seal t
    end

    let t = lift_typ bdev_specs_glue

    let fstype = field t "fstype" string

    let fssize = field t "fssize" uint64_t

    let zfs = field t "zfs" Zfs_glue.t

    let lvm = field t "lvm" Lvm_glue.t

    let dir = field t "dir" string

    let rbd = field t "rbd" Rbd_glue.t

    let () = seal t
  end

  module Migrate_cmd = struct
    let migrate_pre_dump = S.constant "MIGRATE_PRE_DUMP" int64_t

    let migrate_dump = S.constant "MIGRATE_DUMP" int64_t

    let migrate_restore = S.constant "MIGRATE_RESTORE" int64_t

    let migrate_feature_check = S.constant "MIGRATE_FEATURE_CHECK" int64_t
  end

  module Feature_checks = struct
    let feature_mem_track = S.constant "FEATURE_MEM_TRACK" ullong

    let feature_lazy_pages = S.constant "FEATURE_LAZY_PAGES" ullong
  end

  module Migrate_opts = struct
    type migrate_opts

    type t = migrate_opts Ctypes.structure

    let t : t typ = structure "migrate_opts"

    let directory = field t "directory" string

    let verbose = field t "verbose" bool

    let stop = field t "stop" bool

    let predump_dir = field t "predump_dir" string

    let pageserver_address = field t "pageserver_address" string

    let pageserver_port = field t "pageserver_port" string

    let preserves_inodes = field t "preserves_inodes" bool

    let action_script = field t "action_script" string

    let disable_skip_in_flight = field t "disable_skip_in_flight" bool

    let ghost_limit = field t "ghost_limit" uint64_t

    let features_to_check = field t "features_to_check" uint64_t
  end

  module Lxc_console_log = struct
    type lxc_console_log

    type t = lxc_console_log Ctypes.structure

    let t : t typ = structure "lxc_console_log"

    let clear = field t "clear" bool

    let read = field t "read" bool

    let read_max = field t "read_max" (ptr uint64_t)

    let data = field t "data" string

    let () = seal t
  end

  module Lxc_mount = struct
    type lxc_mount

    type t = lxc_mount Ctypes.structure

    let t : t typ = structure "lxc_mount"

    let version = field t "version" int

    let () = seal t
  end

  module Lxc_log = struct
    type lxc_log

    type t = lxc_log Ctypes.structure

    let t : t typ = structure "lxc_log"

    let name = field t "name" string

    let lxcpath = field t "lxcpath" string

    let file = field t "file" string

    let level = field t "level" string

    let prefix = field t "prefix" string

    let quiet = field t "quiet" bool
  end

  type lxc_container

  let lxc_container : lxc_container Ctypes.structure typ =
    structure "lxc_container"
end
