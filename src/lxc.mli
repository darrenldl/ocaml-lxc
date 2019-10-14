type t

val new_container : name:string -> config_path:string -> (t, unit) result

val release : t -> (unit, unit) result

(*$ #use "code_gen/gen.cinaps";;

     For_lxc_c_dot_mli.gen_lxc_container_funptr_field_ml_wrapper_sig_all ()
*)

val is_defined : Types.lxc_container structure ptr -> bool

val state : Types.lxc_container structure ptr -> string

val is_running : Types.lxc_container structure ptr -> bool

val freeze : Types.lxc_container structure ptr -> bool

val unfreeze : Types.lxc_container structure ptr -> bool

val init_pid : Types.lxc_container structure ptr -> Posix_types.pid_t

val load_config : Types.lxc_container structure ptr -> string -> bool

val start : Types.lxc_container structure ptr -> int -> char ptr ptr -> bool

val stop : Types.lxc_container structure ptr -> bool

val want_daemonize : Types.lxc_container structure ptr -> bool -> bool

val want_close_all_fds : Types.lxc_container structure ptr -> bool -> bool

val config_file_name : Types.lxc_container structure ptr -> char ptr

val wait : Types.lxc_container structure ptr -> string -> int -> bool

val set_config_item :
  Types.lxc_container structure ptr -> string -> string -> bool

val destroy : Types.lxc_container structure ptr -> bool

val save_config : Types.lxc_container structure ptr -> string -> bool

val rename : Types.lxc_container structure ptr -> string -> bool

val reboot : Types.lxc_container structure ptr -> bool

val shutdown : Types.lxc_container structure ptr -> int -> bool

val clear_config : Types.lxc_container structure ptr -> void

val clear_config_item : Types.lxc_container structure ptr -> string -> bool

val get_config_item :
  Types.lxc_container structure ptr -> string -> char ptr -> int -> int

val get_running_config_item :
  Types.lxc_container structure ptr -> string -> char ptr

val get_keys :
  Types.lxc_container structure ptr -> string -> char ptr -> int -> int

val get_interfaces : Types.lxc_container structure ptr -> char ptr ptr

val get_ips :
  Types.lxc_container structure ptr -> string -> string -> int -> char ptr ptr

val get_cgroup_item :
  Types.lxc_container structure ptr -> string -> char ptr -> int -> int

val set_cgroup_item :
  Types.lxc_container structure ptr -> string -> string -> bool

val get_config_path : Types.lxc_container structure ptr -> string

val set_config_path : Types.lxc_container structure ptr -> string -> bool

val clone :
  Types.lxc_container structure ptr
  -> string
  -> string
  -> int
  -> string
  -> string
  -> uint64_t
  -> char ptr ptr
  -> lxc_container ptr

val console_getfd :
  Types.lxc_container structure ptr -> int ptr -> int ptr -> int

val console :
  Types.lxc_container structure ptr -> int -> int -> int -> int -> int -> int

val attach_run_wait :
  Types.lxc_container structure ptr
  -> Lxc_attach_options_t.t ptr
  -> string
  -> string ptr
  -> int

val snapshot : Types.lxc_container structure ptr -> string -> int

val snapshot_list :
  Types.lxc_container structure ptr -> ptr Lxc_snapshot.t ptr -> int

val snapshot_restore :
  Types.lxc_container structure ptr -> string -> string -> bool

val snapshot_destroy : Types.lxc_container structure ptr -> string -> bool

val may_control : Types.lxc_container structure ptr -> bool

val add_device_node :
  Types.lxc_container structure ptr -> string -> string -> bool

val remove_device_node :
  Types.lxc_container structure ptr -> string -> string -> bool

val attach_interface :
  Types.lxc_container structure ptr -> string -> string -> bool

val detach_interface :
  Types.lxc_container structure ptr -> string -> string -> bool

val checkpoint :
  Types.lxc_container structure ptr -> char ptr -> bool -> bool -> bool

val restore : Types.lxc_container structure ptr -> char ptr -> bool -> bool

val destroy_with_snapshots : Types.lxc_container structure ptr -> bool

val snapshot_destroy_all : Types.lxc_container structure ptr -> bool

val migrate :
  Types.lxc_container structure ptr
  -> uint
  -> Migrate_opts.t ptr
  -> uint
  -> int

val console_log :
  Types.lxc_container structure ptr -> Lxc_console_log.t ptr -> int

val reboot2 : Types.lxc_container structure ptr -> int -> bool

val mount :
  Types.lxc_container structure ptr
  -> string
  -> string
  -> string
  -> ulong
  -> void ptr
  -> Lxc_mount.t ptr
  -> int

val umount :
  Types.lxc_container structure ptr
  -> string
  -> ulong
  -> Lxc_mount.t ptr
  -> int

val seccomp_notify_fd : Types.lxc_container structure ptr -> int

                                                             (*$*)
