type store_type =
  | Btrfs
  | Directory
  | Lvm
  | Zfs
  | Aufs
  | Overlayfs
  | Loopback
  | Best

let store_type_to_string t =
  match t with
  | Btrfs -> "btrfs"
  | Directory -> "dir"
  | Lvm -> "lvm"
  | Zfs -> "zfs"
  | Aufs -> "aufs"
  | Overlayfs -> "overlayfs"
  | Loopback -> "loopback"
  | Best -> "best"

module Specs = struct
  open Ctypes
  module B = Stubs.Type_stubs.Bdev_specs__glue
  open B

  type zfs = {zfs_root : string option}

  type lvm =
    { vg : string option
    ; lv : string option
    ; thin_pool : string option }

  type rbd =
    { rbd_name : string option
    ; rbd_pool : string option }

  type t =
    { fstype : string option
    ; fssize : int64
    ; zfs : zfs
    ; lvm : lvm
    ; rbd : rbd
    ; dir : string option }

  type c_struct = Types.Bdev_specs__glue.t structure

  module Zfs = struct
    type c_struct = Types.Bdev_specs__glue.Zfs__glue.t structure

    let c_struct_of_t t =
      let c_struct = Ctypes.make Zfs__glue.t in
      setf c_struct Zfs__glue.zfsroot t.zfs_root;
      c_struct
  end

  module Lvm = struct
    type c_struct = Types.Bdev_specs__glue.Lvm__glue.t structure

    let c_struct_of_t t =
      let c_struct = Ctypes.make Lvm__glue.t in
      setf c_struct Lvm__glue.vg t.vg;
      setf c_struct Lvm__glue.lv t.lv;
      setf c_struct Lvm__glue.thinpool t.thin_pool;
      c_struct
  end

  module Rbd = struct
    type c_struct = Types.Bdev_specs__glue.Rbd__glue.t structure

    let c_struct_of_t t =
      let c_struct = Ctypes.make Rbd__glue.t in
      setf c_struct Rbd__glue.rbdname t.rbd_name;
      setf c_struct Rbd__glue.rbdpool t.rbd_pool;
      c_struct
  end

  let c_struct_of_t t =
    let c_struct = Ctypes.make B.t in
    setf c_struct B.fstype t.fstype;
    setf c_struct B.fssize (Unsigned.UInt64.of_int64 t.fssize);
    setf c_struct B.zfs (Zfs.c_struct_of_t t.zfs);
    setf c_struct B.lvm (Lvm.c_struct_of_t t.lvm);
    setf c_struct B.rbd (Rbd.c_struct_of_t t.rbd);
    setf c_struct B.dir t.dir;
    c_struct
end
