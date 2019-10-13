open Ctypes

module Lxc_attach_options_t = struct
  type t

  let t : t structure typ =
    structure "lxc_attach_options_t"
end

module Lxc_snapshot = struct
  type t

  let t : t structure typ =
    structure "lxc_snapshot"
end

module Zfs_glue = struct
  type t

  let t : t structure typ =
    structure "zfs_glue"
end

module Bdev_specs_glue = struct
  type t

  let t : t structure typ =
    structure "bdev_specs_glue"
end

type lxc_container

let lxc_container : lxc_container structure typ = structure "lxc_container"
