type container

module Attach = Attach
module Backing_store = Backing_store
module Console_log = Console_log
module Console_options = Console_options
module Create_options = Create_options
module Namespace_flags = Lxc_c.Namespace_flags
module Feature_checks = Lxc_c.Feature_checks
module State = Lxc_c.State
module Migrate = Migrate
module Snapshot = Snapshot

type getfd_result =
  { ttynum : int
  ; masterfd : int
  ; tty_fd : int }

val new_container : ?config_path:string -> string -> (container, unit) result

val acquire : container -> (unit, unit) result

val release : container -> (unit, unit) result

val get_global_config_item : key:string -> string

val get_version : unit -> string

val list_defined_container_names : ?lxcpath:string -> unit -> string list

val list_active_container_names : ?lxcpath:string -> unit -> string list

val list_all_container_names : ?lxcpath:string -> unit -> string list

val list_defined_containers :
  ?lxcpath:string -> unit -> (string * container) list

val list_active_containers :
  ?lxcpath:string -> unit -> (string * container) list

val list_all_containers : ?lxcpath:string -> unit -> (string * container) list

val config_item_is_supported : key:string -> bool

val has_api_extension : extension:string -> bool

module Container : sig
  val is_defined : container -> bool

  val state : container -> State.t

  val is_running : container -> bool

  val freeze : container -> (unit, unit) result

  val unfreeze : container -> (unit, unit) result

  val init_pid : container -> int

  val load_config : ?alt_file:string -> container -> (unit, unit) result

  val start :
    ?use_init:bool -> ?argv:string array -> container -> (unit, unit) result

  val stop : container -> (unit, unit) result

  val set_want_daemonize :
    want:[`Yes | `No] -> container -> (unit, unit) result

  val want_close_all_fds :
    want:[`Yes | `No] -> container -> (unit, unit) result

  val config_file_name : container -> string

  val wait :
    ?timeout:int -> wait_for:State.t -> container -> (unit, unit) result

  val set_config_item :
    key:string -> value:string -> container -> (unit, unit) result

  val destroy : container -> (unit, unit) result

  val save_config : alt_file:string -> container -> (unit, unit) result

  val create : Create_options.t -> container -> (unit, unit) result

  val rename : new_name:string -> container -> (unit, unit) result

  val reboot : ?timeout:int -> container -> (unit, unit) result

  val shutdown : timeout:int -> container -> (unit, unit) result

  val clear_config : container -> unit

  val clear_config_item : key:string -> container -> (unit, unit) result

  val get_config_item : key:string -> container -> (string, unit) result

  val get_running_config_item :
    key:string -> container -> (string, unit) result

  val get_keys : prefix:string -> container -> (string list, unit) result

  val get_interfaces : container -> (string list, unit) result

  val get_ips :
    interface:string
    -> family:string
    -> scope:int
    -> container
    -> (string list, unit) result

  val get_cgroup_item : subsys:string -> container -> (string, unit) result

  val set_cgroup_item :
    subsys:string -> value:string -> container -> (unit, unit) result

  val get_config_path : container -> string

  val set_config_path : path:string -> container -> (unit, unit) result

  val clone :
    new_name:string
    -> lxcpath:string
    -> flags:int
    -> bdevtype:string
    -> bdevdata:string
    -> new_size:int64
    -> hook_args:string list
    -> container
    -> (container, unit) result

  val console_getfd : ?ttynum:int -> container -> (getfd_result, unit) result

  val console : ?options:Console_options.t -> container -> (unit, unit) result

  val attach_run_wait :
    Attach.Options.t
    -> program:string
    -> argv:string array
    -> container
    -> (int, unit) result

  val create_snapshot : comment_file:string -> container -> (int, unit) result

  val list_snapshots : container -> (Snapshot.t list, unit) result

  val restore_snapshot :
    snap_name:string
    -> new_container_name:string
    -> container
    -> (unit, unit) result

  val destroy_snapshot : snap_name:string -> container -> (unit, unit) result

  val destroy_all_snapshots : container -> (unit, unit) result

  val may_control : container -> bool

  val add_device_node :
    src_path:string -> dst_path:string -> container -> (unit, unit) result

  val remove_device_node :
    src_path:string -> dst_path:string -> container -> (unit, unit) result

  val attach_interface :
    src_dev:string -> dst_dev:string -> container -> (unit, unit) result

  val detach_interface : src_dev:string -> container -> (unit, unit) result

  val checkpoint :
    dir:string -> stop:bool -> verbose:bool -> container -> (unit, unit) result

  val restore_from_checkpoint :
    dir:string -> verbose:bool -> container -> (unit, unit) result

  val destroy_with_snapshots : container -> (unit, unit) result

  val migrate :
    Migrate.Cmd.t -> Migrate.Options.t -> container -> (unit, unit) result

  val console_log : Console_log.options -> container -> (string, unit) result
end
