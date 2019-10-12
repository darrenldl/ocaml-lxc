let headers = ["#include <lxc/lxccontainer.h>";
               "#include <stdint.h>"]

let glue = {|
struct glue_bdev_specs {
	char *fstype; /*!< Filesystem type */
	uint64_t fssize;  /*!< Filesystem size in bytes */
	struct zfs {
		char *zfsroot; /*!< ZFS root path */
	} zfs;
	struct lvm {
		char *vg; /*!< LVM Volume Group name */
		char *lv; /*!< LVM Logical Volume name */
		char *thinpool; /*!< LVM thin pool to use, if any */
	} lvm;
	char *dir; /*!< Directory path */
	struct rbd {
		char *rbdname; /*!< RBD image name */
		char *rbdpool; /*!< Ceph pool name */
	} rbd;
};
|}

let () =
  let c_out = stdout in
  let c_fmt = Format.formatter_of_out_channel c_out in
  List.iter (fun h ->
      output_string c_out (Printf.sprintf "%s\n" h)
    ) headers;
  output_string c_out "\n";
  output_string c_out glue;
  output_string c_out "\n";
  Cstubs_structs.write_c c_fmt (module Ffi_bindings.Bindings)
