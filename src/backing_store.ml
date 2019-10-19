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
