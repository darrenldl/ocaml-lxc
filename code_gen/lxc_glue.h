#include <lxc/lxccontainer.h>
#include <stdint.h>

#define VERSION_AT_LEAST(major, minor, patch)                                  \
  ((LXC_DEVEL == 1) || (LXC_VERSION_MAJOR > major) ||                          \
   (LXC_VERSION_MAJOR == major && LXC_VERSION_MINOR > minor) ||                \
   (LXC_VERSION_MAJOR == major && LXC_VERSION_MINOR == minor &&                \
    LXC_VERSION_PATCH >= patch))

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

// dummy definitions of struct for older versions of LXC
#if !VERSION_AT_LEAST(2, 0, 0)
struct migrate_opts {
  char *directory;
  bool verbose;
  bool stop;
  char *predump_dir;
  char *pageserver_address;
  char *pageserver_port;
  bool preserves_inodes;
  char *action_script;
  bool disable_skip_in_flight;
  uint64_t ghost_limit;
  uint64_t features_to_check;
};
#endif

#if !VERSION_AT_LEAST(3, 0, 0)
struct lxc_console_log {
  bool clear;
  bool read;
  uint64_t *read_max;
  char *data;
};
#endif

struct bdev_specs bdev_specs__glue_dissolve(struct bdev_specs__glue *src);

bool create__glue(struct lxc_container *c, const char *t, const char *bdevtype,
                  struct bdev_specs__glue *specs__glue, int flags,
                  char *const argv[]);

int attach_run_command__glue(struct lxc_container *c,
                             lxc_attach_options_t *options,
                             struct lxc_attach_command_t *cmd,
                             pid_t *attached_process_pid);

int attach_run_shell__glue(struct lxc_container *c,
                           lxc_attach_options_t *options,
                           pid_t *attached_process_pid);

/*$ #use "code_gen/gen.cinaps";;

    For_lxc_glue_dot_h.gen_lxc_container_funptr_field_c_glue_header_all ()
 */
bool is_defined__glue(struct lxc_container *c);

char *state__glue(struct lxc_container *c);

bool is_running__glue(struct lxc_container *c);

bool freeze__glue(struct lxc_container *c);

bool unfreeze__glue(struct lxc_container *c);

pid_t init_pid__glue(struct lxc_container *c);

bool load_config__glue(struct lxc_container *c, char *a0);

bool start__glue(struct lxc_container *c, int a0, char **a1);

bool stop__glue(struct lxc_container *c);

bool want_daemonize__glue(struct lxc_container *c, bool a0);

bool want_close_all_fds__glue(struct lxc_container *c, bool a0);

char *config_file_name__glue(struct lxc_container *c);

bool wait__glue(struct lxc_container *c, char *a0, int a1);

bool set_config_item__glue(struct lxc_container *c, char *a0, char *a1);

bool destroy__glue(struct lxc_container *c);

bool save_config__glue(struct lxc_container *c, char *a0);

bool rename__glue(struct lxc_container *c, char *a0);

bool reboot__glue(struct lxc_container *c);

bool shutdown__glue(struct lxc_container *c, int a0);

void clear_config__glue(struct lxc_container *c);

bool clear_config_item__glue(struct lxc_container *c, char *a0);

int get_config_item__glue(struct lxc_container *c, char *a0, char *a1, int a2);

char *get_running_config_item__glue(struct lxc_container *c, char *a0);

int get_keys__glue(struct lxc_container *c, char *a0, char *a1, int a2);

char **get_interfaces__glue(struct lxc_container *c);

char **get_ips__glue(struct lxc_container *c, char *a0, char *a1, int a2);

int get_cgroup_item__glue(struct lxc_container *c, char *a0, char *a1, int a2);

bool set_cgroup_item__glue(struct lxc_container *c, char *a0, char *a1);

char *get_config_path__glue(struct lxc_container *c);

bool set_config_path__glue(struct lxc_container *c, char *a0);

struct lxc_container *clone__glue(struct lxc_container *c, char *a0, char *a1,
                                  int a2, char *a3, char *a4, uint64_t a5,
                                  char **a6);

int console_getfd__glue(struct lxc_container *c, int *a0, int *a1);

int console__glue(struct lxc_container *c, int a0, int a1, int a2, int a3,
                  int a4);

int attach_run_wait__glue(struct lxc_container *c, lxc_attach_options_t *a0,
                          char *a1, char **a2);

int snapshot__glue(struct lxc_container *c, char *a0);

int snapshot_list__glue(struct lxc_container *c, struct lxc_snapshot **a0);

bool snapshot_restore__glue(struct lxc_container *c, char *a0, char *a1);

bool snapshot_destroy__glue(struct lxc_container *c, char *a0);

bool may_control__glue(struct lxc_container *c);

bool add_device_node__glue(struct lxc_container *c, char *a0, char *a1);

bool remove_device_node__glue(struct lxc_container *c, char *a0, char *a1);

bool attach_interface__glue(struct lxc_container *c, char *a0, char *a1);

bool detach_interface__glue(struct lxc_container *c, char *a0, char *a1);

bool checkpoint__glue(struct lxc_container *c, char *a0, bool a1, bool a2);

bool restore__glue(struct lxc_container *c, char *a0, bool a1);

bool destroy_with_snapshots__glue(struct lxc_container *c);

bool snapshot_destroy_all__glue(struct lxc_container *c);

int migrate__glue(struct lxc_container *c, unsigned int a0,
                  struct migrate_opts *a1, unsigned int a2);

int console_log__glue(struct lxc_container *c, struct lxc_console_log *a0);

bool reboot2__glue(struct lxc_container *c, int a0);

/*$*/

#endif
