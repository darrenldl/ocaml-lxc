type container

exception Unexpected_value_from_C

exception Unexpected_value_from_ML

exception Not_supported_by_installed_lxc_version

module Error : sig end

module Backing_store : sig
  type store_type =
    | Btrfs
    | Directory
    | Lvm
    | Zfs
    | Aufs
    | Overlayfs
    | Loopback
    | Best

  module Specs : sig
    type zfs = {zfs_root : string option}

    type lvm =
      { vg : string option
      ; lv : string option
      ; thin_pool : string option }

    type rbd =
      { rbd_name : string option
      ; rbd_pool : string option }

    type t =
      { fstype : string option
      ; fssize : int64
      ; zfs : zfs
      ; lvm : lvm
      ; rbd : rbd
      ; dir : string option }
  end
end

module Console_log_options : sig
  type t =
    { clear : bool
    ; read : bool
    ; read_max : int64 }
end

module Console_options : sig
  type t =
    { tty_num : int
    ; stdin_fd : int
    ; stdout_fd : int
    ; stderr_fd : int
    ; escape_char : char }
end

module Create_options : sig
  type t =
    { template : string option
    ; backing_store_type : Backing_store.store_type option
    ; backing_store_specs : Backing_store.Specs.t option
    ; distro : string option
    ; release : string option
    ; arch : string option
    ; variant : string option
    ; server : string option
    ; key_id : string option
    ; key_server : string option
    ; disable_gpg_validation : bool option
    ; flush_cache : bool option
    ; force_cache : bool option
    ; extra_args : string array option }

  module Templates : sig
    val download_ubuntu_trusty_amd64 : t

    val busybox : t

    val ubuntu : t
  end
end

module Namespace_flags : sig
  type t =
    | Clone_newcgroup
    | Clone_newipc
    | Clone_newnet
    | Clone_newns
    | Clone_newpid
    | Clone_newuser
    | Clone_newuts
end

module Feature_checks : sig
  type t =
    | Feature_mem_track
    | Feature_lazy_pages
end

module State : sig
  type t =
    | Stopped
    | Starting
    | Running
    | Stopping
    | Aborting
    | Freezing
    | Frozen
    | Thawed
end

type getfd_result =
  { tty_num : int
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

  val create : container -> Create_options.t -> (unit, unit) result

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

  val console_getfd : ?tty_num:int -> container -> (getfd_result, unit) result

  val console : ?options:Console_options.t -> container -> (unit, unit) result

  val may_control : container -> bool

  val destroy_with_snapshots : container -> (unit, unit) result

  val console_log : container -> Console_log_options.t -> (string, unit) result

  module Migrate : sig
    module Command : sig
      type t =
        | Migrate_pre_dump
        | Migrate_dump
        | Migrate_restore
        | Migrate_feature_check
    end

    module Options : sig
      type t =
        { dir : string
        ; verbose : bool
        ; stop : bool
        ; predump_dir : string option
        ; page_server_addr : string option
        ; page_server_port : string option
        ; preserve_inodes : bool
        ; action_script : string option
        ; disable_skip_in_flight : bool
        ; ghost_limit : int64
        ; features_to_check : Feature_checks.t list }
    end

    val migrate : container -> Command.t -> Options.t -> (unit, unit) result
  end

  module Clone : sig
    module Flags : sig
      type t =
        | Clone_keepname
        | Clone_keepmacaddr
        | Clone_snapshot
    end

    module Options : sig
      type t =
        { new_name : string option
        ; lxcpath : string option
        ; flags : Flags.t list
        ; backing_store_type : Backing_store.store_type option
        ; new_size : int64
        ; hook_args : string list }
    end

    val clone : container -> options:Options.t -> (container, unit) result
  end

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

    val create : ?comment_file:string -> container -> (int, unit) result

    val list : container -> (t list, unit) result

    val restore :
      container
      -> snap_name:string
      -> new_container_name:string
      -> (unit, unit) result

    val destroy : container -> snap_name:string -> (unit, unit) result

    val destroy_all : container -> (unit, unit) result
  end

  module Attach : sig
    module Flags : sig
      type t =
        | Attach_move_to_cgroup
        | Attach_drop_capabilities
        | Attach_set_personality
        | Attach_lsm_exec
        | Attach_remount_proc_sys
        | Attach_lsm_now
        | Attach_no_new_privs
        | Attach_terminal
        | Attach_default
        | Attach_lsm
    end

    module Env_policy : sig
      type t =
        | Lxc_attach_keep_env
        | Lxc_attach_clear_env
    end

    module Options : sig
      type t =
        { attach_flags : Flags.t list option
        ; namespace_flags : Namespace_flags.t list option
        ; personality : int64 option
        ; initial_cwd : string option
        ; uid : int option
        ; gid : int option
        ; env_policy : Env_policy.t option
        ; extra_env_vars : string list option
        ; extra_keep_env : string list option
        ; stdin_fd : int option
        ; stdout_fd : int option
        ; stderr_fd : int option
        ; log_fd : int option }
    end

    val run_shell : ?options:Options.t -> container -> (int, unit) result

    val run_command_no_wait :
      ?options:Options.t
      -> container
      -> argv:string array
      -> (int, unit) result

    val run_command_ret_waitpid_status :
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
