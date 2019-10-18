type container

module State = Lxc_c.State

module Snapshot : sig
  type t

  val get_name : t -> string

  val get_comment_path_name : t -> string

  val get_timestamp : t -> string

  val get_lxcpath : t -> string

  val free : t -> unit
end

type getfd_result =
  { ttynum : int
  ; masterfd : int
  ; tty_fd : int }

val new_container :
  ?config_path:string -> name:string -> unit -> (container, unit) result

val acquire : container -> (unit, unit) result

val release : container -> (unit, unit) result

val get_global_config_item : key:string -> string

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
    use_init:bool -> argv:string array -> container -> (unit, unit) result

  val stop : container -> (unit, unit) result

  val want_daemonize : want:[`Yes | `No] -> container -> (unit, unit) result

  val want_close_all_fds :
    want:[`Yes | `No] -> container -> (unit, unit) result

  val config_file_name : container -> string

  val wait :
    ?timeout:int -> wait_for:State.t -> container -> (unit, unit) result

  val set_config_item :
    key:string -> value:string -> container -> (unit, unit) result

  val destroy : container -> (unit, unit) result

  val save_config : alt_file:string -> container -> (unit, unit) result

  (* val create *)

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

  (* val clone  *)

  val console_getfd : ?ttynum:int -> container -> (getfd_result, unit) result

  val console :
    ?ttynum:int
    -> stdin_fd:int
    -> stdout_fd:int
    -> stderr_fd:int
    -> escape_char:char
    -> container
    -> (unit, unit) result

  (* val attach_run_wait *)

  val snapshot : comment_file:string -> container -> (int, unit) result
end
