open Ctypes

module Lxc_attach_options_t = struct
  type t

  let t : t structure typ = structure "lxc_attach_options_t"
end

module Lxc_attach_command_t = struct
  type t

  let t : t structure typ = structure "lxc_attach_command_t"
end

module Lxc_snapshot = struct
  type t

  let t : t structure typ = structure "lxc_snapshot"
end

module Bdev_specs__glue = struct
  module Zfs__glue = struct
    type t

    let t : t structure typ = structure "zfs__glue"
  end

  module Lvm__glue = struct
    type t

    let t : t structure typ = structure "lvm__glue"
  end

  module Rbd__glue = struct
    type t

    let t : t structure typ = structure "rbd__glue"
  end

  type t

  let t : t structure typ = structure "bdev_specs__glue"
end

module Migrate_opts__glue = struct
  type t

  let t : t structure typ = structure "migrate_opts__glue"
end

module Lxc_console_log = struct
  type t

  let t : t structure typ = structure "lxc_console_log"
end

(* module Lxc_mount = struct
 *   type t
 * 
 *   let t : t structure typ = structure "lxc_mount"
 * end *)

module Lxc_log = struct
  type t

  let t : t structure typ = structure "lxc_log"
end

type lxc_container

let lxc_container : lxc_container structure typ = structure "lxc_container"
