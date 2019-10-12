let headers = ["#include <lxc/lxccontainer.h>";
               "#include <stdint.h>"]

let glue = {|
struct bdev_specs_glue {
	char *fstype;
	uint64_t fssize;
	struct zfs_glue {
		char *zfsroot;
	} zfs;
	struct lvm_glue {
		char *vg;
		char *lv;
		char *thinpool;
	} lvm;
	char *dir;
	struct rbd_glue {
		char *rbdname;
		char *rbdpool;
	} rbd;
};

struct bdev_specs bdev_specs_glue_dissolve(struct bdev_specs_glue * src) {
  struct bdev_specs ret = { 0 };

  ret.fstype = src->fstype;
  ret.fssize = src->fssize;

  ret.zfs.zfsroot = src->zfs.zfsroot;

  ret.lvm.vg = src->lvm.vg;
  ret.lvm.lv = src->lvm.lv;
  ret.lvm.thinpool = src->lvm.thinpool;

  ret.dir = src->dir;

  ret.rbd.rbdname = src->rbd.rbdname;
  ret.rbd.rbdpool = src->rbd.rbdpool;

  return ret;
}
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
