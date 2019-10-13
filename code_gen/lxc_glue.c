#include "lxc_glue.h"

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

bool create_glu(struct lxc_container *c, const char *t, const char *bdevtype,
                struct bdev_specs_glue *specs_glue, int flags, char *const argv[]) {
  struct bdev_specs specs = bdev_specs_glue_dissolve(specs_glue);

  return c->create(c, t, bdevtype, &specs, flags, argv);
}

/*$ #use "code_gen/gen.cinaps";;

  gen_lxc_container_funptr_field_c_glue_all ()
*/bool is_defined_glu(struct lxc_container * c) {
  return c->is_defined(c);
}

const char * state_glu(struct lxc_container * c) {
  return c->state(c);
}

bool is_running_glu(struct lxc_container * c) {
  return c->is_running(c);
}

bool freeze_glu(struct lxc_container * c) {
  return c->freeze(c);
}

bool unfreeze_glu(struct lxc_container * c) {
  return c->unfreeze(c);
}

pid_t init_pid_glu(struct lxc_container * c) {
  return c->init_pid(c);
}

bool load_config_glu(struct lxc_container * c, const char * a0) {
  return c->load_config(c, a0);
}

bool start_glu(struct lxc_container * c, int a0, char * const * a1) {
  return c->start(c, a0, a1);
}

bool stop_glu(struct lxc_container * c) {
  return c->stop(c);
}

bool want_daemonize_glu(struct lxc_container * c, bool a0) {
  return c->want_daemonize(c, a0);
}

bool want_close_all_fds_glu(struct lxc_container * c, bool a0) {
  return c->want_close_all_fds(c, a0);
}

char * config_file_name_glu(struct lxc_container * c) {
  return c->config_file_name(c);
}

bool wait_glu(struct lxc_container * c, const char * a0, int a1) {
  return c->wait(c, a0, a1);
}

bool set_config_item_glu(struct lxc_container * c, const char * a0, const char * a1) {
  return c->set_config_item(c, a0, a1);
}

bool destroy_glu(struct lxc_container * c) {
  return c->destroy(c);
}

bool save_config_glu(struct lxc_container * c, const char * a0) {
  return c->save_config(c, a0);
}

bool rename_glu(struct lxc_container * c, const char * a0) {
  return c->rename(c, a0);
}

bool reboot_glu(struct lxc_container * c) {
  return c->reboot(c);
}

bool shutdown_glu(struct lxc_container * c, int a0) {
  return c->shutdown(c, a0);
}

void clear_config_glu(struct lxc_container * c) {
  return c->clear_config(c);
}

bool clear_config_item_glu(struct lxc_container * c, const char * a0) {
  return c->clear_config_item(c, a0);
}

int get_config_item_glu(struct lxc_container * c, const char * a0, char * a1, int a2) {
  return c->get_config_item(c, a0, a1, a2);
}

char * get_running_config_item_glu(struct lxc_container * c, const char * a0) {
  return c->get_running_config_item(c, a0);
}

int get_keys_glu(struct lxc_container * c, const char * a0, char * a1, int a2) {
  return c->get_keys(c, a0, a1, a2);
}

char ** get_interfaces_glu(struct lxc_container * c) {
  return c->get_interfaces(c);
}

char ** get_ips_glu(struct lxc_container * c, const char * a0, const char * a1, int a2) {
  return c->get_ips(c, a0, a1, a2);
}

int get_cgroup_item_glu(struct lxc_container * c, const char * a0, char * a1, int a2) {
  return c->get_cgroup_item(c, a0, a1, a2);
}

bool set_cgroup_item_glu(struct lxc_container * c, const char * a0, const char * a1) {
  return c->set_cgroup_item(c, a0, a1);
}

const char * get_config_path_glu(struct lxc_container * c) {
  return c->get_config_path(c);
}

bool set_config_path_glu(struct lxc_container * c, const char * a0) {
  return c->set_config_path(c, a0);
}

struct lxc_container * clone_glu(struct lxc_container * c, const char * a0, const char * a1, int a2, const char * a3, const char * a4, uint64_t a5, char ** a6) {
  return c->clone(c, a0, a1, a2, a3, a4, a5, a6);
}

int console_getfd_glu(struct lxc_container * c, int * a0, int * a1) {
  return c->console_getfd(c, a0, a1);
}

int console_glu(struct lxc_container * c, int a0, int a1, int a2, int a3, int a4) {
  return c->console(c, a0, a1, a2, a3, a4);
}

int attach_run_wait_glu(struct lxc_container * c, lxc_attach_options_t * a0, const char * a1, const char * const * a2) {
  return c->attach_run_wait(c, a0, a1, a2);
}

int snapshot_glu(struct lxc_container * c, const char * a0) {
  return c->snapshot(c, a0);
}

int snapshot_list_glu(struct lxc_container * c, struct lxc_snapshot ** a0) {
  return c->snapshot_list(c, a0);
}

bool snapshot_restore_glu(struct lxc_container * c, const char * a0, const char * a1) {
  return c->snapshot_restore(c, a0, a1);
}

bool snapshot_destroy_glu(struct lxc_container * c, const char * a0) {
  return c->snapshot_destroy(c, a0);
}

bool may_control_glu(struct lxc_container * c) {
  return c->may_control(c);
}

bool add_device_node_glu(struct lxc_container * c, const char * a0, const char * a1) {
  return c->add_device_node(c, a0, a1);
}

bool remove_device_node_glu(struct lxc_container * c, const char * a0, const char * a1) {
  return c->remove_device_node(c, a0, a1);
}

bool attach_interface_glu(struct lxc_container * c, const char * a0, const char * a1) {
  return c->attach_interface(c, a0, a1);
}

bool detach_interface_glu(struct lxc_container * c, const char * a0, const char * a1) {
  return c->detach_interface(c, a0, a1);
}

bool checkpoint_glu(struct lxc_container * c, char * a0, bool a1, bool a2) {
  return c->checkpoint(c, a0, a1, a2);
}

bool restore_glu(struct lxc_container * c, char * a0, bool a1) {
  return c->restore(c, a0, a1);
}

bool destroy_with_snapshots_glu(struct lxc_container * c) {
  return c->destroy_with_snapshots(c);
}

bool snapshot_destroy_all_glu(struct lxc_container * c) {
  return c->snapshot_destroy_all(c);
}

int migrate_glu(struct lxc_container * c, unsigned int a0, struct migrate_opts * a1, unsigned int a2) {
  return c->migrate(c, a0, a1, a2);
}

int console_log_glu(struct lxc_container * c, struct lxc_console_log * a0) {
  return c->console_log(c, a0);
}

bool reboot2_glu(struct lxc_container * c, int a0) {
  return c->reboot2(c, a0);
}

int mount_glu(struct lxc_container * c, const char * a0, const char * a1, const char * a2, unsigned long a3, const void * a4, struct lxc_mount * a5) {
  return c->mount(c, a0, a1, a2, a3, a4, a5);
}

int umount_glu(struct lxc_container * c, const char * a0, unsigned long a1, struct lxc_mount * a2) {
  return c->umount(c, a0, a1, a2);
}

int seccomp_notify_fd_glu(struct lxc_container * c) {
  return c->seccomp_notify_fd(c);
}

/*$*/
