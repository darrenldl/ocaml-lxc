open Ctypes
open PosixTypes
open Foreign

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
