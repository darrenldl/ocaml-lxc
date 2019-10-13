open Ctypes

module Lxc_attach_options_t = struct
  type t

  let t : t structure typ = structure "lxc_attach_options_t"
end

module Lxc_snapshot = struct
  type t

  let t : t structure typ = structure "lxc_snapshot"
end

module Bdev_specs_glue = struct
  module Zfs_glue = struct
    type t

    let t : t structure typ = structure "zfs_glue"
  end

  module Lvm_glue = struct
    type t

    let t : t structure typ = structure "lvm_glue"
  end

  module Rbd_glue = struct
    type t

    let t : t structure typ = structure "rbd_glue"
  end

  type t

  let t : t structure typ = structure "bdev_specs_glue"
end

module Migrate_opts = struct
  type t

  let t : t structure typ = structure "migrate_opts"
end

module Lxc_console_log = struct
  type t

  let t : t structure typ = structure "lxc_console_log"
end

module Lxc_mount = struct
  type t

  let t : t structure typ = structure "lxc_mount"
end

module Lxc_log = struct
  type t

  let t : t structure typ = structure "lxc_log"
end

type lxc_container

let lxc_container : lxc_container structure typ = structure "lxc_container"
