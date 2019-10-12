open Ctypes
open PosixTypes
open Foreign

module Lxc_snapshot = struct
  type t

  let t : t structure typ = structure "lxc_snapshot"

  let name = field t "name" (ptr char)

  let comment_pathname = field t "comment_pathname" (ptr char)

  let timestamp = field t "timestamp" (ptr char)

  let lxcpath = field t "lxcpath" (ptr char)

  let free = field t "free"
      (funptr (ptr t @-> returning void))
end

module Bdev_specs = struct
  module Zfs = struct
    type t

    let t : t structure typ = structure "zfs"

    let zfsroot = field t "zfsroot" (ptr char)
  end

  module Lvm = struct
    type t

    let t : t structure typ = structure "lvm"

    let vg = field t "vg" (ptr char)

    let lv = field t "lv" (ptr char)

    let thinpool = field t "thinpool" (ptr char)
  end

  module Rbd = struct
    type t

    let t : t structure typ = structure "rbd"

    let rbdname = field t "rbdname" (ptr char)

    let rbdpool = field t "rbdpool" (ptr char)
  end

  type t

  let t : t structure typ = structure "bdev_specs"

  let fstype = field t "fstype" (ptr char)

  let fssize = field t "fssize" uint64_t

  let zfs = field t "zfs" Zfs.t

  let lvm = field t "lvm" Lvm.t

  let dir = field t "dir" (ptr char)

  let rbd = field t "rbd" Rbd.t
end

module Migrate_opts = struct
  type t

  let t : t structure typ = structure "migrate_opts"

  let directory = field t "directory" (ptr char)

  let verbose = field t "verbose" bool

  let stop = field t "stop" bool

  let predump_dir = field t "predump_dir" (ptr char)

  let pageserver_address = field t "pageserver_address" (ptr char)

  let pageserver_port = field t "pageserver_port" (ptr char)

  let preserves_inodes = field t "preserves_inodes" bool

  let action_script = field t "action_script" (ptr char)

  let disable_skip_in_flight = field t "disable_skip_in_flight" bool

  let ghost_limit = field t "ghost_limit" uint64_t

  let features_to_check = field t "features_to_check" uint64_t
end

module Lxc_console_log = struct
  type t

  let t : t structure typ = structure "lxc_console_log"

  let clear = field t "clear" bool

  let read = field t "read" bool

  let read_max = field t "read_max" (ptr uint64_t)

  let data = field t "data" (ptr char)
end

module Lxc_mount = struct
  type t

  let t : t structure typ = structure "lxc_mount"

  let version = field t "version" int
end

type lxc_container

let lxc_container : lxc_container structure typ = structure "lxc_container"

let error_string = field lxc_container "error_string" (ptr char)

let error_num = field lxc_container "error_num" int

let daemonize = field lxc_container "daemonize" bool

let config_path = field lxc_container "config_path" (ptr char)

let is_defined =
  field lxc_container "is_defined"
    (funptr (ptr lxc_container @-> returning bool))

let state =
  field lxc_container "state"
    (funptr (ptr lxc_container @-> returning (ptr char)))

let is_running =
  field lxc_container "is_running"
    (funptr (ptr lxc_container @-> returning bool))

let freeze =
  field lxc_container "freeze" (funptr (ptr lxc_container @-> returning bool))

let unfreeze =
  field lxc_container "unfreeze"
    (funptr (ptr lxc_container @-> returning bool))

let init_pid =
  field lxc_container "init_pid"
    (funptr (ptr lxc_container @-> returning pid_t))

let load_config =
  field lxc_container "load_config"
    (funptr (ptr lxc_container @-> ptr char @-> returning bool))

let start =
  field lxc_container "start"
    (funptr (ptr lxc_container @-> int @-> ptr (ptr char) @-> returning bool))

let stop =
  field lxc_container "stop" (funptr (ptr lxc_container @-> returning bool))

let want_daemonize =
  field lxc_container "want_daemonize"
    (funptr (ptr lxc_container @-> bool @-> returning bool))

let want_close_all_fds =
  field lxc_container "want_close_all_fds"
    (funptr (ptr lxc_container @-> bool @-> returning bool))

let config_file_name =
  field lxc_container "config_file_name"
    (funptr (ptr lxc_container @-> returning (ptr char)))

let wait =
  field lxc_container "wait"
    (funptr (ptr lxc_container @-> ptr char @-> int @-> returning bool))

let set_config_item =
  field lxc_container "set_config_item"
    (funptr (ptr lxc_container @-> ptr char @-> ptr char @-> returning bool))

let destroy =
  field lxc_container "destroy" (funptr (ptr lxc_container @-> returning bool))

let save_config =
  field lxc_container "save_config"
    (funptr (ptr lxc_container @-> ptr char @-> returning bool))

let create =
  field lxc_container "create"
    (funptr
       ( ptr lxc_container @-> ptr char @-> ptr char @-> ptr Bdev_specs.t
         @-> int @-> ptr char @-> returning bool ))

let rename =
  field lxc_container "rename"
    (funptr
       (ptr lxc_container @-> ptr char @-> returning bool))

let reboot =
  field lxc_container "reboot"
    (funptr (ptr lxc_container @-> returning bool))

let shutdown =
  field lxc_container "shutdown"
    (funptr (ptr lxc_container @-> int @-> returning bool))

let clear_config =
  field lxc_container "clear_config"
    (funptr (ptr lxc_container @-> returning void))

let clear_config_item =
  field lxc_container "clear_config_item"
    (funptr (ptr lxc_container @-> ptr char @-> returning bool))

let get_config_item =
  field lxc_container "get_config_item"
    (funptr (ptr lxc_container @-> ptr char @-> ptr char @-> int @-> returning int))

let get_running_config_item =
  field lxc_container "get_running_config_item"
    (funptr (ptr lxc_container @-> ptr char @-> returning (ptr char)))

let get_keys =
  field lxc_container "get_keys"
    (funptr (ptr lxc_container @-> ptr char @-> ptr char @-> int @-> returning int))

let get_interfaces =
  field lxc_container "get_interfaces"
    (funptr (ptr lxc_container @-> returning (ptr (ptr char))))

let get_ips =
  field lxc_container "get_ips"
    (funptr (ptr lxc_container @-> ptr char @-> ptr char @-> int @-> returning (ptr (ptr char))))

let get_cgroup_item =
  field lxc_container "get_cgroup_item"
    (funptr (ptr lxc_container @-> ptr char @-> ptr char @-> int @-> returning int))

let set_cgroup_item =
  field lxc_container "set_cgroup_item"
    (funptr (ptr lxc_container @-> ptr char @-> ptr char @-> returning bool))

let get_config_path =
  field lxc_container "get_config_path"
    (funptr (ptr lxc_container @-> returning (ptr char)))

let set_config_path =
  field lxc_container "set_config_path"
    (funptr (ptr lxc_container @-> ptr char @-> returning bool))

let clone =
  field lxc_container "clone"
    (funptr (ptr lxc_container @-> ptr char @-> ptr char @-> ptr char @-> int @-> ptr char @-> ptr char @-> uint64_t @-> ptr (ptr char) @-> returning (ptr lxc_container)))

let console_getfd =
  field lxc_container "console_getfd"
    (funptr (ptr lxc_container @-> ptr int @-> ptr int @-> returning int))

let console =
  field lxc_container "console"
    (funptr (ptr lxc_container @-> int @-> int @-> int @-> int @-> int @-> returning int))

let snapshot =
  field lxc_container "snapshot"
    (funptr (ptr lxc_container @-> ptr char @-> returning int))

let snapshot_list =
  field lxc_container "snapshot_list"
    (funptr (ptr lxc_container @-> ptr (ptr Lxc_snapshot.t) @-> returning int))

let snapshot_restore =
  field lxc_container "snapshot_restore"
    (funptr (ptr lxc_container @-> ptr char @-> ptr char @-> returning bool))

let snapshot_destroy =
  field lxc_container "snapshot_destroy"
    (funptr (ptr lxc_container @-> ptr char @-> returning bool))

let may_control =
  field lxc_container "may_control"
    (funptr (ptr lxc_container @-> returning bool))

let add_device_node =
  field lxc_container "add_device_node"
    (funptr (ptr lxc_container @-> ptr char @-> ptr char @-> returning bool))

let remove_device_node =
  field lxc_container "remove_device_node"
    (funptr (ptr lxc_container @-> ptr char @-> ptr char @-> returning bool))

let attach_interface =
  field lxc_container "attach_interface"
    (funptr (ptr lxc_container @-> ptr char @-> ptr char @-> returning bool))

let detach_interface =
  field lxc_container "detach_interface"
    (funptr (ptr lxc_container @-> ptr char @-> ptr char @-> returning bool))

let checkpoint =
  field lxc_container "checkpoint"
    (funptr (ptr lxc_container @-> ptr char @-> bool @-> bool @-> returning bool))

let restore =
  field lxc_container "restore"
    (funptr (ptr lxc_container @-> ptr char @-> bool @-> returning bool))

let destroy_with_snapshots =
  field lxc_container "destroy_with_snapshots"
    (funptr (ptr lxc_container @-> returning bool))

let snapshot_destroy_all =
  field lxc_container "snapshot_destroy_all"
    (funptr (ptr lxc_container @-> returning bool))

let migrate =
  field lxc_container "migrate"
    (funptr (ptr lxc_container @-> uint @-> ptr Migrate_opts.t @-> uint @-> returning int))

let console_log =
  field lxc_container "console_log"
    (funptr (ptr lxc_container @-> ptr Lxc_console_log.t @-> returning int))

let reboot2 =
  field lxc_container "reboot2"
    (funptr (ptr lxc_container @-> int @-> returning bool))

let mount =
  field lxc_container "mount"
    (funptr (ptr lxc_container @-> ptr char @-> ptr char @-> ptr char @-> ulong @-> ptr void @-> ptr Lxc_mount.t @-> returning int))

let umount =
  field lxc_container "umount"
    (funptr (ptr lxc_container @-> ptr char @-> ulong @-> ptr Lxc_mount.t @-> returning int))

let seccomp_notify_fd =
  field lxc_container "seccomp_notify_fd"
    (funptr (ptr lxc_container @-> returning int))
