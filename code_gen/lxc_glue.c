#include "lxc_glue.h"

#ifndef LXC_DEVEL
#define LXC_DEVEL 0
#endif

static lxc_attach_options_t lxc_attach_options_default =
    LXC_ATTACH_OPTIONS_DEFAULT;

lxc_attach_options_t *get_lxc_attach_options_default__glue(void) {
  return &lxc_attach_options_default;
}

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
  if (specs__glue == NULL) {
    return c->create(c, t, bdevtype, NULL, flags, argv);
  } else {
    struct bdev_specs specs = bdev_specs__glue_dissolve(specs__glue);

    return c->create(c, t, bdevtype, &specs, flags, argv);
  }
}

bool lxc_config_item_is_supported__glue(const char *key) {
#if VERSION_AT_LEAST(2, 1, 0)
  return lxc_config_item_is_supported(key);
#else
  return false;
#endif
}

bool lxc_has_api_extension__glue(const char *extension) {
#if VERSION_AT_LEAST(3, 1, 0)
  return lxc_has_api_extension(extension);
#else
  return false;
#endif
}

struct migrate_opts
migrate_opts__glue_dissolve(struct migrate_opts__glue *opts) {
  struct migrate_opts ret = {0};

#if VERSION_AT_LEAST(3, 0, 0)
  ret.features_to_check = opts->features_to_check;
#endif

#if VERSION_AT_LEAST(2, 0, 4)
  ret.action_script = opts->action_script;
  ret.ghost_limit = opts->ghost_limit;
#endif

#if VERSION_AT_LEAST(2, 0, 1)
  ret.preserves_inodes = opts->preserves_inodes;
#endif

  return ret;
}

int migrate__glue(struct lxc_container *c, unsigned int cmd,
                  struct migrate_opts__glue *opts__glue) {
  struct migrate_opts opts = migrate_opts__glue_dissolve(opts__glue);

#if VERSION_AT_LEAST(2, 0, 0)
  return c->migrate(c, cmd, &opts, sizeof(struct migrate_opts));
#else
  return -EINVAL;
#endif
}

int attach_run_command__glue(struct lxc_container *c,
                             lxc_attach_options_t *options,
                             struct lxc_attach_command_t *cmd,
                             pid_t *attached_process_pid) {
  return c->attach(c, lxc_attach_run_command, cmd, options,
                   attached_process_pid);
}

int attach_run_shell__glue(struct lxc_container *c,
                           lxc_attach_options_t *options,
                           pid_t *attached_process_pid) {
  return c->attach(c, lxc_attach_run_shell, NULL, options,
                   attached_process_pid);
}

/*$ #use "code_gen/gen.cinaps";;

    For_lxc_glue_dot_c.gen_lxc_container_funptr_field_c_glue_code_all ()
 */
bool is_defined__glue(struct lxc_container *c) {
  return (bool)c->is_defined((struct lxc_container *)c);
}

char *state__glue(struct lxc_container *c) {
  return (char *)c->state((struct lxc_container *)c);
}

bool is_running__glue(struct lxc_container *c) {
  return (bool)c->is_running((struct lxc_container *)c);
}

bool freeze__glue(struct lxc_container *c) {
  return (bool)c->freeze((struct lxc_container *)c);
}

bool unfreeze__glue(struct lxc_container *c) {
  return (bool)c->unfreeze((struct lxc_container *)c);
}

pid_t init_pid__glue(struct lxc_container *c) {
  return (pid_t)c->init_pid((struct lxc_container *)c);
}

bool load_config__glue(struct lxc_container *c, char *a0) {
  return (bool)c->load_config((struct lxc_container *)c, (const char *)a0);
}

bool start__glue(struct lxc_container *c, int a0, char **a1) {
  return (bool)c->start((struct lxc_container *)c, (int)a0, (char *const *)a1);
}

bool stop__glue(struct lxc_container *c) {
  return (bool)c->stop((struct lxc_container *)c);
}

bool want_daemonize__glue(struct lxc_container *c, bool a0) {
  return (bool)c->want_daemonize((struct lxc_container *)c, (bool)a0);
}

bool want_close_all_fds__glue(struct lxc_container *c, bool a0) {
  return (bool)c->want_close_all_fds((struct lxc_container *)c, (bool)a0);
}

char *config_file_name__glue(struct lxc_container *c) {
  return (char *)c->config_file_name((struct lxc_container *)c);
}

bool wait__glue(struct lxc_container *c, char *a0, int a1) {
  return (bool)c->wait((struct lxc_container *)c, (const char *)a0, (int)a1);
}

bool set_config_item__glue(struct lxc_container *c, char *a0, char *a1) {
  return (bool)c->set_config_item((struct lxc_container *)c, (const char *)a0,
                                  (const char *)a1);
}

bool destroy__glue(struct lxc_container *c) {
  return (bool)c->destroy((struct lxc_container *)c);
}

bool save_config__glue(struct lxc_container *c, char *a0) {
  return (bool)c->save_config((struct lxc_container *)c, (const char *)a0);
}

bool rename__glue(struct lxc_container *c, char *a0) {
  return (bool)c->rename((struct lxc_container *)c, (const char *)a0);
}

bool reboot__glue(struct lxc_container *c) {
  return (bool)c->reboot((struct lxc_container *)c);
}

bool shutdown__glue(struct lxc_container *c, int a0) {
  return (bool)c->shutdown((struct lxc_container *)c, (int)a0);
}

void clear_config__glue(struct lxc_container *c) {
  return (void)c->clear_config((struct lxc_container *)c);
}

bool clear_config_item__glue(struct lxc_container *c, char *a0) {
  return (bool)c->clear_config_item((struct lxc_container *)c,
                                    (const char *)a0);
}

int get_config_item__glue(struct lxc_container *c, char *a0, char *a1, int a2) {
  return (int)c->get_config_item((struct lxc_container *)c, (const char *)a0,
                                 (char *)a1, (int)a2);
}

char *get_running_config_item__glue(struct lxc_container *c, char *a0) {
  return (char *)c->get_running_config_item((struct lxc_container *)c,
                                            (const char *)a0);
}

int get_keys__glue(struct lxc_container *c, char *a0, char *a1, int a2) {
  return (int)c->get_keys((struct lxc_container *)c, (const char *)a0,
                          (char *)a1, (int)a2);
}

char **get_interfaces__glue(struct lxc_container *c) {
  return (char **)c->get_interfaces((struct lxc_container *)c);
}

char **get_ips__glue(struct lxc_container *c, char *a0, char *a1, int a2) {
  return (char **)c->get_ips((struct lxc_container *)c, (const char *)a0,
                             (const char *)a1, (int)a2);
}

int get_cgroup_item__glue(struct lxc_container *c, char *a0, char *a1, int a2) {
  return (int)c->get_cgroup_item((struct lxc_container *)c, (const char *)a0,
                                 (char *)a1, (int)a2);
}

bool set_cgroup_item__glue(struct lxc_container *c, char *a0, char *a1) {
  return (bool)c->set_cgroup_item((struct lxc_container *)c, (const char *)a0,
                                  (const char *)a1);
}

char *get_config_path__glue(struct lxc_container *c) {
  return (char *)c->get_config_path((struct lxc_container *)c);
}

bool set_config_path__glue(struct lxc_container *c, char *a0) {
  return (bool)c->set_config_path((struct lxc_container *)c, (const char *)a0);
}

struct lxc_container *clone__glue(struct lxc_container *c, char *a0, char *a1,
                                  int a2, char *a3, char *a4, uint64_t a5,
                                  char **a6) {
  return (struct lxc_container *)c->clone(
      (struct lxc_container *)c, (const char *)a0, (const char *)a1, (int)a2,
      (const char *)a3, (const char *)a4, (uint64_t)a5, (char **)a6);
}

int console_getfd__glue(struct lxc_container *c, int *a0, int *a1) {
  return (int)c->console_getfd((struct lxc_container *)c, (int *)a0, (int *)a1);
}

int console__glue(struct lxc_container *c, int a0, int a1, int a2, int a3,
                  int a4) {
  return (int)c->console((struct lxc_container *)c, (int)a0, (int)a1, (int)a2,
                         (int)a3, (int)a4);
}

int attach_run_wait__glue(struct lxc_container *c, lxc_attach_options_t *a0,
                          char *a1, char **a2) {
  return (int)c->attach_run_wait((struct lxc_container *)c,
                                 (lxc_attach_options_t *)a0, (const char *)a1,
                                 (const char *const *)a2);
}

int snapshot__glue(struct lxc_container *c, char *a0) {
  return (int)c->snapshot((struct lxc_container *)c, (const char *)a0);
}

int snapshot_list__glue(struct lxc_container *c, struct lxc_snapshot **a0) {
  return (int)c->snapshot_list((struct lxc_container *)c,
                               (struct lxc_snapshot **)a0);
}

bool snapshot_restore__glue(struct lxc_container *c, char *a0, char *a1) {
  return (bool)c->snapshot_restore((struct lxc_container *)c, (const char *)a0,
                                   (const char *)a1);
}

bool snapshot_destroy__glue(struct lxc_container *c, char *a0) {
  return (bool)c->snapshot_destroy((struct lxc_container *)c, (const char *)a0);
}

bool may_control__glue(struct lxc_container *c) {
  return (bool)c->may_control((struct lxc_container *)c);
}

bool add_device_node__glue(struct lxc_container *c, char *a0, char *a1) {
  return (bool)c->add_device_node((struct lxc_container *)c, (const char *)a0,
                                  (const char *)a1);
}

bool remove_device_node__glue(struct lxc_container *c, char *a0, char *a1) {
  return (bool)c->remove_device_node((struct lxc_container *)c,
                                     (const char *)a0, (const char *)a1);
}

bool attach_interface__glue(struct lxc_container *c, char *a0, char *a1) {
#if VERSION_AT_LEAST(1, 1, 0)
  return (bool)c->attach_interface((struct lxc_container *)c, (const char *)a0,
                                   (const char *)a1);
#else
  return false;
#endif
}

bool detach_interface__glue(struct lxc_container *c, char *a0, char *a1) {
#if VERSION_AT_LEAST(1, 1, 0)
  return (bool)c->detach_interface((struct lxc_container *)c, (const char *)a0,
                                   (const char *)a1);
#else
  return false;
#endif
}

bool checkpoint__glue(struct lxc_container *c, char *a0, bool a1, bool a2) {
#if VERSION_AT_LEAST(1, 1, 0)
  return (bool)c->checkpoint((struct lxc_container *)c, (char *)a0, (bool)a1,
                             (bool)a2);
#else
  return false;
#endif
}

bool restore__glue(struct lxc_container *c, char *a0, bool a1) {
#if VERSION_AT_LEAST(1, 1, 0)
  return (bool)c->restore((struct lxc_container *)c, (char *)a0, (bool)a1);
#else
  return false;
#endif
}

bool destroy_with_snapshots__glue(struct lxc_container *c) {
#if VERSION_AT_LEAST(1, 1, 0)
  return (bool)c->destroy_with_snapshots((struct lxc_container *)c);
#else
  return false;
#endif
}

bool snapshot_destroy_all__glue(struct lxc_container *c) {
#if VERSION_AT_LEAST(1, 1, 0)
  return (bool)c->snapshot_destroy_all((struct lxc_container *)c);
#else
  return false;
#endif
}

int console_log__glue(struct lxc_container *c, struct lxc_console_log *a0) {
#if VERSION_AT_LEAST(3, 0, 0)
  return (int)c->console_log((struct lxc_container *)c,
                             (struct lxc_console_log *)a0);
#else
  return false;
#endif
}

bool reboot2__glue(struct lxc_container *c, int a0) {
  return (bool)c->reboot2((struct lxc_container *)c, (int)a0);
}

/*$*/
