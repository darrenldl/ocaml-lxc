#include <lxc/attach_options.h>
#include <lxc/lxccontainer.h>
#include <stdint.h>

#ifndef LXC_GLUE_H
#define LXC_GLUE_H

struct bdev_specs__glue {
  char *fstype;
  uint64_t fssize;
  struct zfs__glue {
    char *zfsroot;
  } zfs;
  struct lvm__glue {
    char *vg;
    char *lv;
    char *thinpool;
  } lvm;
  char *dir;
  struct rbd__glue {
    char *rbdname;
    char *rbdpool;
  } rbd;
};

struct bdev_specs bdev_specs__glue_dissolve(struct bdev_specs__glue *src);

bool create__glue(struct lxc_container *c, const char *t, const char *bdevtype,
                  struct bdev_specs__glue *specs__glue, int flags,
                  char *const argv[]);

#endif
