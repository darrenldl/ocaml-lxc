module Types_stubs (S : Cstubs_structs.TYPE) = struct
  open S

  module Errno = struct
    let ebadf = constant "EBADF" int
  end

  module Posix_types = struct
    let pid_t = S.lift_typ Posix_types.pid_t

    let uid_t = S.lift_typ Posix_types.uid_t

    let gid_t = S.lift_typ Posix_types.gid_t
  end

  module Lxc_clone_flags = struct
    let lxc_clone_keepname = S.constant "LXC_CLONE_KEEPNAME" int

    let lxc_clone_keepmacaddr = S.constant "LXC_CLONE_KEEPMACADDR" int

    let lxc_clone_keepbdevtype = S.constant "LXC_CLONE_SNAPSHOT" int

    let lxc_clone_maybe_snapshot = S.constant "LXC_CLONE_MAYBE_SNAPSHOT" int

    let lxc_clone_maxflags = S.constant "LXC_CLONE_MAXFLAGS" int

    let lxc_clone_allow_running = S.constant "LXC_CLONE_ALLOW_RUNNING" int

    let lxc_create_quiet = S.constant "LXC_CREATE_QUIET" int

    let lxc_create_maxflags = S.constant "LXC_CREATE_MAXFLAGS" int

    let lxc_mount_api_v1 = S.constant "LXC_MOUNT_API_V1" int
  end

  module Namespace_flags = struct
    let clone_newcgroup = S.constant "CLONE_NEWCGROUP" int

    let clone_newipc = S.constant "CLONE_NEWIPC" int

    let clone_newnet = S.constant "CLONE_NEWNET" int

    let clone_newns = S.constant "CLONE_NEWNS" int

    let clone_newpid = S.constant "CLONE_NEWPID" int

    let clone_newuser = S.constant "CLONE_NEWUSER" int

    let clone_newuts = S.constant "CLONE_NEWUTS" int
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

  module Lxc_attach_options_t = struct
    let t = lift_typ Types.Lxc_attach_options_t.t

    let attach_flags = field t "attach_flags" int

    let namespaces = field t "namespaces" int

    let personality = field t "personality" long

    let initial_cwd = field t "initial_cwd" string_opt

    let uid = field t "uid" Posix_types.uid_t

    let gid = field t "gid" Posix_types.gid_t

    let env_policy = field t "env_policy" Lxc_attach_env_policy_t.t

    let extra_env_vars = field t "extra_env_vars" (ptr (ptr char))

    let extra_keep_env = field t "extra_keep_env" (ptr (ptr char))

    let stdin_fd = field t "stdin_fd" int

    let stdout_fd = field t "stdout_fd" int

    let stderr_fd = field t "stderr_fd" int

    let log_fd = field t "log_fd" int

    let () = seal t
  end

  module Lxc_attach_command_t = struct
    let t = lift_typ Types.Lxc_attach_command_t.t

    let program = field t "program" string

    let argv = field t "argv" (ptr (ptr char))

    let () = seal t
  end

  module Lxc_snapshot = struct
    let t = lift_typ Types.Lxc_snapshot.t

    let name = field t "name" string

    let comment_pathname = field t "comment_pathname" string

    let timestamp = field t "timestamp" string

    let lxcpath = field t "lxcpath" string

    let free = field t "free" (static_funptr (ptr t @-> returning void))

    let () = seal t
  end

  module Bdev_specs__glue = struct
    module Zfs__glue = struct
      let t = lift_typ Types.Bdev_specs__glue.Zfs__glue.t

      let zfsroot = field t "zfsroot" string_opt

      let () = seal t
    end

    module Lvm__glue = struct
      let t = lift_typ Types.Bdev_specs__glue.Lvm__glue.t

      let vg = field t "vg" string_opt

      let lv = field t "lv" string_opt

      let thinpool = field t "thinpool" string_opt

      let () = seal t
    end

    module Rbd__glue = struct
      let t = lift_typ Types.Bdev_specs__glue.Rbd__glue.t

      let rbdname = field t "rbdname" string_opt

      let rbdpool = field t "rbdpool" string_opt

      let () = seal t
    end

    let t = lift_typ Types.Bdev_specs__glue.t

    let fstype = field t "fstype" string_opt

    let fssize = field t "fssize" uint64_t

    let zfs = field t "zfs" Zfs__glue.t

    let lvm = field t "lvm" Lvm__glue.t

    let dir = field t "dir" string_opt

    let rbd = field t "rbd" Rbd__glue.t

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
    let t = lift_typ Types.Migrate_opts.t

    let directory = field t "directory" string_opt

    let verbose = field t "verbose" bool

    let stop = field t "stop" bool

    let predump_dir = field t "predump_dir" string_opt

    let pageserver_address = field t "pageserver_address" string_opt

    let pageserver_port = field t "pageserver_port" string_opt

    let preserves_inodes = field t "preserves_inodes" bool

    let action_script = field t "action_script" string_opt

    let disable_skip_in_flight = field t "disable_skip_in_flight" bool

    let ghost_limit = field t "ghost_limit" uint64_t

    let features_to_check = field t "features_to_check" uint64_t

    let () = seal t
  end

  module Lxc_console_log = struct
    let t = lift_typ Types.Lxc_console_log.t

    let clear = field t "clear" bool

    let read = field t "read" bool

    let read_max = field t "read_max" (ptr uint64_t)

    let data = field t "data" (ptr char)

    let () = seal t
  end

  module Lxc_mount = struct
    let t = lift_typ Types.Lxc_mount.t

    let version = field t "version" int

    let () = seal t
  end

  module Lxc_log = struct
    let t = lift_typ Types.Lxc_log.t

    let name = field t "name" string

    let lxcpath = field t "lxcpath" string

    let file = field t "file" string

    let level = field t "level" string

    let prefix = field t "prefix" string

    let quiet = field t "quiet" bool

    let () = seal t
  end

  type lxc_container = Types.lxc_container

  let lxc_container = lift_typ Types.lxc_container

  let error_string = field lxc_container "error_string" (ptr char)

  let error_num = field lxc_container "error_num" int

  let daemonize = field lxc_container "daemonize" bool

  let config_path = field lxc_container "config_path" (ptr char)

  (*$ #use "code_gen/gen.cinaps";;

       For_ffi_types_dot_ml.gen_lxc_container_funptr_field_ml_all ()
  *)

  let is_defined__raw =
    field lxc_container "is_defined"
      (static_funptr (ptr lxc_container @-> returning bool))

  let state__raw =
    field lxc_container "state"
      (static_funptr (ptr lxc_container @-> returning string_opt))

  let is_running__raw =
    field lxc_container "is_running"
      (static_funptr (ptr lxc_container @-> returning bool))

  let freeze__raw =
    field lxc_container "freeze"
      (static_funptr (ptr lxc_container @-> returning bool))

  let unfreeze__raw =
    field lxc_container "unfreeze"
      (static_funptr (ptr lxc_container @-> returning bool))

  let init_pid__raw =
    field lxc_container "init_pid"
      (static_funptr (ptr lxc_container @-> returning Posix_types.pid_t))

  let load_config__raw =
    field lxc_container "load_config"
      (static_funptr (ptr lxc_container @-> string_opt @-> returning bool))

  let start__raw =
    field lxc_container "start"
      (static_funptr
         (ptr lxc_container @-> int @-> ptr (ptr char) @-> returning bool))

  let stop__raw =
    field lxc_container "stop"
      (static_funptr (ptr lxc_container @-> returning bool))

  let want_daemonize__raw =
    field lxc_container "want_daemonize"
      (static_funptr (ptr lxc_container @-> bool @-> returning bool))

  let want_close_all_fds__raw =
    field lxc_container "want_close_all_fds"
      (static_funptr (ptr lxc_container @-> bool @-> returning bool))

  let config_file_name__raw =
    field lxc_container "config_file_name"
      (static_funptr (ptr lxc_container @-> returning (ptr char)))

  let wait__raw =
    field lxc_container "wait"
      (static_funptr
         (ptr lxc_container @-> string_opt @-> int @-> returning bool))

  let set_config_item__raw =
    field lxc_container "set_config_item"
      (static_funptr
         (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool))

  let destroy__raw =
    field lxc_container "destroy"
      (static_funptr (ptr lxc_container @-> returning bool))

  let save_config__raw =
    field lxc_container "save_config"
      (static_funptr (ptr lxc_container @-> string_opt @-> returning bool))

  let rename__raw =
    field lxc_container "rename"
      (static_funptr (ptr lxc_container @-> string_opt @-> returning bool))

  let reboot__raw =
    field lxc_container "reboot"
      (static_funptr (ptr lxc_container @-> returning bool))

  let shutdown__raw =
    field lxc_container "shutdown"
      (static_funptr (ptr lxc_container @-> int @-> returning bool))

  let clear_config__raw =
    field lxc_container "clear_config"
      (static_funptr (ptr lxc_container @-> returning void))

  let clear_config_item__raw =
    field lxc_container "clear_config_item"
      (static_funptr (ptr lxc_container @-> string_opt @-> returning bool))

  let get_config_item__raw =
    field lxc_container "get_config_item"
      (static_funptr
         ( ptr lxc_container @-> string_opt @-> ptr char @-> int
           @-> returning int ))

  let get_running_config_item__raw =
    field lxc_container "get_running_config_item"
      (static_funptr (ptr lxc_container @-> string_opt @-> returning (ptr char)))

  let get_keys__raw =
    field lxc_container "get_keys"
      (static_funptr
         ( ptr lxc_container @-> string_opt @-> ptr char @-> int
           @-> returning int ))

  let get_interfaces__raw =
    field lxc_container "get_interfaces"
      (static_funptr (ptr lxc_container @-> returning (ptr (ptr char))))

  let get_ips__raw =
    field lxc_container "get_ips"
      (static_funptr
         ( ptr lxc_container @-> string_opt @-> string_opt @-> int
           @-> returning (ptr (ptr char)) ))

  let get_cgroup_item__raw =
    field lxc_container "get_cgroup_item"
      (static_funptr
         ( ptr lxc_container @-> string_opt @-> ptr char @-> int
           @-> returning int ))

  let set_cgroup_item__raw =
    field lxc_container "set_cgroup_item"
      (static_funptr
         (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool))

  let get_config_path__raw =
    field lxc_container "get_config_path"
      (static_funptr (ptr lxc_container @-> returning string_opt))

  let set_config_path__raw =
    field lxc_container "set_config_path"
      (static_funptr (ptr lxc_container @-> string_opt @-> returning bool))

  let clone__raw =
    field lxc_container "clone"
      (static_funptr
         ( ptr lxc_container @-> string_opt @-> string_opt @-> int
           @-> string_opt @-> string_opt @-> uint64_t
           @-> ptr (ptr char)
           @-> returning (ptr lxc_container) ))

  let console_getfd__raw =
    field lxc_container "console_getfd"
      (static_funptr
         (ptr lxc_container @-> ptr int @-> ptr int @-> returning int))

  let console__raw =
    field lxc_container "console"
      (static_funptr
         ( ptr lxc_container @-> int @-> int @-> int @-> int @-> int
           @-> returning int ))

  let attach_run_wait__raw =
    field lxc_container "attach_run_wait"
      (static_funptr
         ( ptr lxc_container @-> ptr Lxc_attach_options_t.t @-> string_opt
           @-> ptr (ptr char)
           @-> returning int ))

  let snapshot__raw =
    field lxc_container "snapshot"
      (static_funptr (ptr lxc_container @-> string_opt @-> returning int))

  let snapshot_list__raw =
    field lxc_container "snapshot_list"
      (static_funptr
         (ptr lxc_container @-> ptr (ptr Lxc_snapshot.t) @-> returning int))

  let snapshot_restore__raw =
    field lxc_container "snapshot_restore"
      (static_funptr
         (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool))

  let snapshot_destroy__raw =
    field lxc_container "snapshot_destroy"
      (static_funptr (ptr lxc_container @-> string_opt @-> returning bool))

  let may_control__raw =
    field lxc_container "may_control"
      (static_funptr (ptr lxc_container @-> returning bool))

  let add_device_node__raw =
    field lxc_container "add_device_node"
      (static_funptr
         (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool))

  let remove_device_node__raw =
    field lxc_container "remove_device_node"
      (static_funptr
         (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool))

  let attach_interface__raw =
    field lxc_container "attach_interface"
      (static_funptr
         (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool))

  let detach_interface__raw =
    field lxc_container "detach_interface"
      (static_funptr
         (ptr lxc_container @-> string_opt @-> string_opt @-> returning bool))

  let checkpoint__raw =
    field lxc_container "checkpoint"
      (static_funptr
         (ptr lxc_container @-> ptr char @-> bool @-> bool @-> returning bool))

  let restore__raw =
    field lxc_container "restore"
      (static_funptr
         (ptr lxc_container @-> ptr char @-> bool @-> returning bool))

  let destroy_with_snapshots__raw =
    field lxc_container "destroy_with_snapshots"
      (static_funptr (ptr lxc_container @-> returning bool))

  let snapshot_destroy_all__raw =
    field lxc_container "snapshot_destroy_all"
      (static_funptr (ptr lxc_container @-> returning bool))

  let migrate__raw =
    field lxc_container "migrate"
      (static_funptr
         ( ptr lxc_container @-> uint @-> ptr Migrate_opts.t @-> uint
           @-> returning int ))

  let console_log__raw =
    field lxc_container "console_log"
      (static_funptr
         (ptr lxc_container @-> ptr Lxc_console_log.t @-> returning int))

  let reboot2__raw =
    field lxc_container "reboot2"
      (static_funptr (ptr lxc_container @-> int @-> returning bool))

  let mount__raw =
    field lxc_container "mount"
      (static_funptr
         ( ptr lxc_container @-> string_opt @-> string_opt @-> string_opt
           @-> ulong @-> ptr void @-> ptr Lxc_mount.t @-> returning int ))

  let umount__raw =
    field lxc_container "umount"
      (static_funptr
         ( ptr lxc_container @-> string_opt @-> ulong @-> ptr Lxc_mount.t
           @-> returning int ))

  let seccomp_notify_fd__raw =
    field lxc_container "seccomp_notify_fd"
      (static_funptr (ptr lxc_container @-> returning int))

    (*$*)

let () = seal lxc_container
end
