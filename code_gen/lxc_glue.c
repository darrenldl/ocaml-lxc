#include "lxc_glue.h"

struct bdev_specs bdev_specs__glue_dissolve(struct bdev_specs__glue *src) {
  struct bdev_specs ret = {0};

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

bool create__glue(struct lxc_container *c, const char *t, const char *bdevtype,
                  struct bdev_specs__glue *specs__glue, int flags,
                  char *const argv[]) {
  struct bdev_specs specs = bdev_specs__glue_dissolve(specs__glue);

  return c->create(c, t, bdevtype, &specs, flags, argv);
}
