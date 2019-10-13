#include <lxc/attach_options.h>
#include <lxc/lxccontainer.h>
#include <stdint.h>

#ifndef LXC_GLUE_H
#define LXC_GLUE_H

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

struct bdev_specs bdev_specs_glue_dissolve(struct bdev_specs_glue *src);

bool create__glue(struct lxc_container *c, const char *t, const char *bdevtype,
                  struct bdev_specs_glue *specs_glue, int flags,
                  char *const argv[]);

/*$ #use "code_gen/gen.cinaps";;

    (* gen_lxc_container_funptr_field_c_glue_header_all () *)
 *//*$*/
#endif
