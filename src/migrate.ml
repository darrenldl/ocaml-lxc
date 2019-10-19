open Ctypes
open Misc_utils
module Feature_checks = Lxc_c.Feature_checks
module Cmd = Lxc_c.Migrate_cmd

module Options = struct
  module M = Stubs.Type_stubs.Migrate_opts

  type c_struct = Types.Migrate_opts.t structure

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

  let c_struct_of_t t =
    let c_struct = Ctypes.make M.t in
    setf c_struct M.directory (Some t.dir);
    setf c_struct M.verbose t.verbose;
    setf c_struct M.stop t.stop;
    setf c_struct M.predump_dir t.predump_dir;
    setf c_struct M.pageserver_address t.page_server_addr;
    setf c_struct M.pageserver_port t.page_server_port;
    setf c_struct M.preserves_inodes t.preserve_inodes;
    setf c_struct M.action_script t.action_script;
    setf c_struct M.disable_skip_in_flight t.disable_skip_in_flight;
    setf c_struct M.ghost_limit (Unsigned.UInt64.of_int64 t.ghost_limit);
    setf c_struct M.features_to_check
      ( lor_flags Feature_checks.to_c_int t.features_to_check
        |> Unsigned.UInt64.of_int );
    c_struct
end
