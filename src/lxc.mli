type container

module Backing_store = Backing_store
module Console_log = Console_log
module Console_options = Console_options
module Namespace_flags = Lxc_c.Namespace_flags
module Feature_checks = Lxc_c.Feature_checks
module State = Lxc_c.State
module Migrate = Migrate

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
    container -> want:[`Yes | `No] -> (unit, unit) result

  val set_want_close_all_fds :
    container -> want:[`Yes | `No] -> (unit, unit) result

  val config_file_name : container -> string

  val wait :
    ?timeout:int -> container -> wait_for:State.t -> (unit, unit) result

  val set_config_item :
    container -> key:string -> value:string -> (unit, unit) result

  val destroy : container -> (unit, unit) result

  val save_config : container -> alt_file:string -> (unit, unit) result

  module Create : sig
    module Options = Create_internal.Options
    module Templates = Create_internal.Templates

    val create : container -> Options.t -> (unit, unit) result
  end

  val rename : container -> new_name:string -> (unit, unit) result

  val reboot : ?timeout:int -> container -> (unit, unit) result

  val shutdown : container -> timeout:int -> (unit, unit) result

  val clear_config : container -> unit

  val clear_config_item : container -> key:string -> (unit, unit) result

  val get_config_item : container -> key:string -> (string, unit) result

  val get_running_config_item :
    container -> key:string -> (string, unit) result

  val get_keys : container -> prefix:string -> (string list, unit) result

  val get_interfaces : container -> (string list, unit) result

  val get_ips :
    container
    -> interface:string
    -> family:string
    -> scope:int
    -> (string list, unit) result

  val get_config_path : container -> string

  val set_config_path : container -> path:string -> (unit, unit) result

  (* val clone :
   *   container
   *   -> new_name:string
   *   -> lxcpath:string
   *   -> flags:int
   *   -> bdevtype:string
   *   -> bdevdata:string
   *   -> new_size:int64
   *   -> hook_args:string list
   *   -> (container, unit) result *)

  val console_getfd : ?tty_num:int -> container -> (getfd_result, unit) result

  val console : ?options:Console_options.t -> container -> (unit, unit) result

  val may_control : container -> bool

  val destroy_with_snapshots : container -> (unit, unit) result

  val migrate :
    container -> Migrate.Command.t -> Migrate.Options.t -> (unit, unit) result

  val console_log : container -> Console_log.options -> (string, unit) result

  module Checkpoint : sig
    val checkpoint :
      container
      -> dir:string
      -> stop:bool
      -> verbose:bool
      -> (unit, unit) result

    val restore :
      container -> dir:string -> verbose:bool -> (unit, unit) result
  end

  module Device : sig
    val add_node :
      container -> src_path:string -> dst_path:string -> (unit, unit) result

    val remove_node :
      container -> src_path:string -> dst_path:string -> (unit, unit) result
  end

  module Interface : sig
    val attach :
      container -> src_dev:string -> dst_dev:string -> (unit, unit) result

    val detach : container -> src_dev:string -> (unit, unit) result
  end

  module Snapshot : sig
    type t

    val create : container -> comment_file:string -> (int, unit) result

    val list : container -> (t list, unit) result

    val restore :
      container
      -> snap_name:string
      -> new_container_name:string
      -> (unit, unit) result

    val destroy : container -> snap_name:string -> (unit, unit) result

    val destroy_all : container -> (unit, unit) result
  end

  module Run : sig
    module Options = Run_internal.Options

    val shell : ?options:Options.t -> container -> (int, unit) result

    val command_no_wait :
      ?options:Options.t
      -> container
      -> argv:string array
      -> (int, unit) result

    val command_ret_status :
      ?options:Options.t
      -> container
      -> argv:string array
      -> (int, unit) result
  end

  module Cgroup : sig
    val get : container -> key:string -> (string list, unit) result

    val set : container -> key:string -> value:string -> (unit, unit) result

    module Helpers : sig
      val get_mem_usage_bytes : container -> (int, unit) result

      val get_mem_limit_bytes : container -> (int, unit) result

      val set_mem_limit_bytes : container -> int -> (unit, unit) result

      val get_soft_mem_limit_bytes : container -> (int, unit) result

      val set_soft_mem_limit_bytes : container -> int -> (unit, unit) result

      val get_kernel_mem_usage_bytes : container -> (int, unit) result

      val get_kernel_mem_limit_bytes : container -> (int, unit) result

      val set_kernel_mem_limit_bytes : container -> int -> (unit, unit) result

      val get_mem_swap_usage_bytes : container -> (int, unit) result

      val get_mem_swap_limit_bytes : container -> (int, unit) result

      val set_mem_swap_limit_bytes : container -> int -> (unit, unit) result
    end
  end
end
