module Stubs (S : Cstubs_structs.TYPE) = struct
  open S

  module Posix = struct
    let pid_t = S.lift_typ PosixTypes.pid_t
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

    type bdev_specs_glue

    type t = bdev_specs_glue Ctypes.structure

    let t : t typ = structure "bdev_specs_glue"

    let fstype = field t "fstype" string

    let fssize = field t "fssize" uint64_t

    let zfs = field t "zfs" Zfs_glue.t

    let lvm = field t "lvm" Lvm_glue.t

    let dir = field t "dir" string

    let rbd = field t "rbd" Rbd_glue.t

    let () = seal t
  end

  module Migrate_cmd = struct
    let migrate_pre_dump = S.constant "MIGRATE_PRE_DUMP" int

    let migrate_dump = S.constant "MIGRATE_DUMP" int

    let migrate_restore = S.constant "MIGRATE_RESTORE" int

    let migrate_feature_check = S.constant "MIGRATE_FEATURE_CHECK" int
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

  type lxc_container

  let lxc_container : lxc_container Ctypes.structure typ =
    structure "lxc_container"

  let error_string = field lxc_container "error_string" string

  let error_num = field lxc_container "error_num" int

  let daemonize = field lxc_container "daemonize" bool

  let config_path = field lxc_container "config_path" string

  let is_defined =
    field lxc_container "is_defined"
      (static_funptr (ptr lxc_container @-> returning bool))

  let state =
    field lxc_container "state"
      (static_funptr (ptr lxc_container @-> returning string))

  let is_running =
    field lxc_container "is_running"
      (static_funptr (ptr lxc_container @-> returning bool))

  let freeze =
    field lxc_container "freeze"
      (static_funptr (ptr lxc_container @-> returning bool))

  let unfreeze =
    field lxc_container "unfreeze"
      (static_funptr (ptr lxc_container @-> returning bool))

  let init_pid =
    field lxc_container "init_pid"
      (static_funptr (ptr lxc_container @-> returning Posix.pid_t))

  let load_config =
    field lxc_container "load_config"
      (static_funptr (ptr lxc_container @-> string @-> returning bool))

  let start =
    field lxc_container "start"
      (static_funptr
         (ptr lxc_container @-> int @-> ptr string @-> returning bool))

  let stop =
    field lxc_container "stop"
      (static_funptr (ptr lxc_container @-> returning bool))

  let want_daemonize =
    field lxc_container "want_daemonize"
      (static_funptr (ptr lxc_container @-> bool @-> returning bool))

  let want_close_all_fds =
    field lxc_container "want_close_all_fds"
      (static_funptr (ptr lxc_container @-> bool @-> returning bool))

  let config_file_name =
    field lxc_container "config_file_name"
      (static_funptr (ptr lxc_container @-> returning string))

  let wait =
    field lxc_container "wait"
      (static_funptr (ptr lxc_container @-> string @-> int @-> returning bool))

  let set_config_item =
    field lxc_container "set_config_item"
      (static_funptr
         (ptr lxc_container @-> string @-> string @-> returning bool))

  let destroy =
    field lxc_container "destroy"
      (static_funptr (ptr lxc_container @-> returning bool))

  let save_config =
    field lxc_container "save_config"
      (static_funptr (ptr lxc_container @-> string @-> returning bool))

  let rename =
    field lxc_container "rename"
      (static_funptr (ptr lxc_container @-> string @-> returning bool))

  let reboot =
    field lxc_container "reboot"
      (static_funptr (ptr lxc_container @-> returning bool))

  let shutdown =
    field lxc_container "shutdown"
      (static_funptr (ptr lxc_container @-> int @-> returning bool))

  let clear_config =
    field lxc_container "clear_config"
      (static_funptr (ptr lxc_container @-> returning void))

  let clear_config_item =
    field lxc_container "clear_config_item"
      (static_funptr (ptr lxc_container @-> string @-> returning bool))

  let get_config_item =
    field lxc_container "get_config_item"
      (static_funptr
         (ptr lxc_container @-> string @-> string @-> int @-> returning int))

  let get_running_config_item =
    field lxc_container "get_running_config_item"
      (static_funptr (ptr lxc_container @-> string @-> returning string))

  let get_keys =
    field lxc_container "get_keys"
      (static_funptr
         (ptr lxc_container @-> string @-> string @-> int @-> returning int))

  let get_interfaces =
    field lxc_container "get_interfaces"
      (static_funptr (ptr lxc_container @-> returning (ptr string)))

  let get_ips =
    field lxc_container "get_ips"
      (static_funptr
         ( ptr lxc_container @-> string @-> string @-> int
           @-> returning (ptr string) ))

  let get_cgroup_item =
    field lxc_container "get_cgroup_item"
      (static_funptr
         (ptr lxc_container @-> string @-> string @-> int @-> returning int))

  let set_cgroup_item =
    field lxc_container "set_cgroup_item"
      (static_funptr
         (ptr lxc_container @-> string @-> string @-> returning bool))

  let get_config_path =
    field lxc_container "get_config_path"
      (static_funptr (ptr lxc_container @-> returning string))

  let set_config_path =
    field lxc_container "set_config_path"
      (static_funptr (ptr lxc_container @-> string @-> returning bool))

  let clone =
    field lxc_container "clone"
      (static_funptr
         ( ptr lxc_container @-> string @-> string @-> string @-> int @-> string
           @-> string @-> uint64_t @-> ptr string
           @-> returning (ptr lxc_container) ))

  let console_getfd =
    field lxc_container "console_getfd"
      (static_funptr
         (ptr lxc_container @-> ptr int @-> ptr int @-> returning int))

  let console =
    field lxc_container "console"
      (static_funptr
         ( ptr lxc_container @-> int @-> int @-> int @-> int @-> int
           @-> returning int ))

  let snapshot =
    field lxc_container "snapshot"
      (static_funptr (ptr lxc_container @-> string @-> returning int))

  let snapshot_list =
    field lxc_container "snapshot_list"
      (static_funptr
         (ptr lxc_container @-> ptr (ptr Lxc_snapshot.t) @-> returning int))

  let snapshot_restore =
    field lxc_container "snapshot_restore"
      (static_funptr
         (ptr lxc_container @-> string @-> string @-> returning bool))

  let snapshot_destroy =
    field lxc_container "snapshot_destroy"
      (static_funptr (ptr lxc_container @-> string @-> returning bool))

  let may_control =
    field lxc_container "may_control"
      (static_funptr (ptr lxc_container @-> returning bool))

  let add_device_node =
    field lxc_container "add_device_node"
      (static_funptr
         (ptr lxc_container @-> string @-> string @-> returning bool))

  let remove_device_node =
    field lxc_container "remove_device_node"
      (static_funptr
         (ptr lxc_container @-> string @-> string @-> returning bool))

  let attach_interface =
    field lxc_container "attach_interface"
      (static_funptr
         (ptr lxc_container @-> string @-> string @-> returning bool))

  let detach_interface =
    field lxc_container "detach_interface"
      (static_funptr
         (ptr lxc_container @-> string @-> string @-> returning bool))

  let checkpoint =
    field lxc_container "checkpoint"
      (static_funptr
         (ptr lxc_container @-> string @-> bool @-> bool @-> returning bool))

  let restore =
    field lxc_container "restore"
      (static_funptr (ptr lxc_container @-> string @-> bool @-> returning bool))

  let destroy_with_snapshots =
    field lxc_container "destroy_with_snapshots"
      (static_funptr (ptr lxc_container @-> returning bool))

  let snapshot_destroy_all =
    field lxc_container "snapshot_destroy_all"
      (static_funptr (ptr lxc_container @-> returning bool))

  let migrate =
    field lxc_container "migrate"
      (static_funptr
         ( ptr lxc_container @-> uint @-> ptr Migrate_opts.t @-> uint
           @-> returning int ))

  let console_log =
    field lxc_container "console_log"
      (static_funptr
         (ptr lxc_container @-> ptr Lxc_console_log.t @-> returning int))

  let reboot2 =
    field lxc_container "reboot2"
      (static_funptr (ptr lxc_container @-> int @-> returning bool))

  let mount =
    field lxc_container "mount"
      (static_funptr
         ( ptr lxc_container @-> string @-> string @-> string @-> ulong
           @-> ptr void @-> ptr Lxc_mount.t @-> returning int ))

  let umount =
    field lxc_container "umount"
      (static_funptr
         ( ptr lxc_container @-> string @-> ulong @-> ptr Lxc_mount.t
           @-> returning int ))

  let seccomp_notify_fd =
    field lxc_container "seccomp_notify_fd"
      (static_funptr (ptr lxc_container @-> returning int))

  let () = seal lxc_container
end
