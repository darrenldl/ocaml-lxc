open Ctypes
open Types
open Stubs

exception Unexpected_value_from_C

exception Unexpected_value_from_ML

module Namespace_flags = struct
  open Type_stubs.Namespace_flags

  (*$
       let l =
         ["newcgroup"; "newipc"; "newnet"; "newns"; "newpid"; "newuser"; "newuts"]

       ;;
       print_endline "type t ="

       ;;
       List.iter (fun s -> Printf.printf "| Clone_%s\n" s) l

       ;;
       print_endline "let to_c_int t = match t with"

       ;;
       List.iter (fun s -> Printf.printf "| Clone_%s -> clone_%s\n" s s) l
  *)

  type t =
    | Clone_newcgroup
    | Clone_newipc
    | Clone_newnet
    | Clone_newns
    | Clone_newpid
    | Clone_newuser
    | Clone_newuts

  let to_c_int t =
    match t with
    | Clone_newcgroup ->
      clone_newcgroup
    | Clone_newipc ->
      clone_newipc
    | Clone_newnet ->
      clone_newnet
    | Clone_newns ->
      clone_newns
    | Clone_newpid ->
      clone_newpid
    | Clone_newuser ->
      clone_newuser
    | Clone_newuts ->
      clone_newuts

      (*$*)
end

module Lxc_attach_flags = struct
  open Type_stubs.Lxc_attach_flags

  (*$
       let l =
         [ "move_to_cgroup"
         ; "drop_capabilities"
         ; "set_personality"
         ; "lsm_exec"
         ; "remount_proc_sys"
         ; "lsm_now"
         ; "no_new_privs"
         ; "terminal"
         ; "default"
         ; "lsm" ]

       ;;
       print_endline "type t ="

       ;;
       List.iter (fun s -> Printf.printf "| Attach_%s\n" s) l

       ;;
       print_endline "let to_c_int t = match t with"

       ;;
       List.iter (fun s -> Printf.printf "| Attach_%s -> lxc_attach_%s\n" s s) l
  *)

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

  let to_c_int t =
    match t with
    | Attach_move_to_cgroup ->
      lxc_attach_move_to_cgroup
    | Attach_drop_capabilities ->
      lxc_attach_drop_capabilities
    | Attach_set_personality ->
      lxc_attach_set_personality
    | Attach_lsm_exec ->
      lxc_attach_lsm_exec
    | Attach_remount_proc_sys ->
      lxc_attach_remount_proc_sys
    | Attach_lsm_now ->
      lxc_attach_lsm_now
    | Attach_no_new_privs ->
      lxc_attach_no_new_privs
    | Attach_terminal ->
      lxc_attach_terminal
    | Attach_default ->
      lxc_attach_default
    | Attach_lsm ->
      lxc_attach_lsm

      (*$*)
end

module Migrate_cmd = struct
  open Type_stubs.Migrate_cmd

  type t =
    | Migrate_pre_dump
    | Migrate_dump
    | Migrate_restore
    | Migrate_feature_check

  let to_c_int t =
    match t with
    | Migrate_pre_dump ->
      migrate_pre_dump
    | Migrate_dump ->
      migrate_dump
    | Migrate_restore ->
      migrate_restore
    | Migrate_feature_check ->
      migrate_feature_check
end

module Feature_checks = struct
  open Stubs.Type_stubs.Feature_checks

  type t =
    | Feature_mem_track
    | Feature_lazy_pages

  let to_c_int t =
    match t with
    | Feature_mem_track ->
      feature_mem_track |> Unsigned.ULLong.to_int
    | Feature_lazy_pages ->
      feature_lazy_pages |> Unsigned.ULLong.to_int
end

module State = struct
  type t =
    | Stopped
    | Starting
    | Running
    | Stopping
    | Aborting
    | Freezing
    | Frozen
    | Thawed

  let to_string t =
    match t with
    | Stopped ->
      "STOPPED"
    | Starting ->
      "STARTING"
    | Running ->
      "RUNNING"
    | Stopping ->
      "STOPPING"
    | Aborting ->
      "ABORTING"
    | Freezing ->
      "FREEZING"
    | Frozen ->
      "FROZEN"
    | Thawed ->
      "THAWED"

  let of_string t =
    match t with
    | "STOPPED" ->
      Stopped
    | "STARTING" ->
      Starting
    | "RUNNING" ->
      Running
    | "STOPPING" ->
      Stopping
    | "ABORTING" ->
      Aborting
    | "FREEZING" ->
      Freezing
    | "FROZEN" ->
      Frozen
    | "THAWED" ->
      Thawed
    | _ ->
      raise Unexpected_value_from_C
end

(*$
     List.iter
       (fun s -> Printf.printf "let %s = Fun_stubs.%s\n" s s)
       [ "create__glue"
       ; "lxc_container_new"
       ; "lxc_container_get"
       ; "lxc_container_put"
       ; "lxc_get_wait_states"
       ; "lxc_get_global_config_item"
       ; "lxc_get_version"
       ; "list_defined_containers"
       ; "list_active_containers"
       ; "list_all_containers"
       ; "lxc_log_init"
       ; "lxc_log_close"
       ; "lxc_config_item_is_supported"
       ; "lxc_has_api_extension" ]
*)

let create__glue = Fun_stubs.create__glue

let lxc_container_new = Fun_stubs.lxc_container_new

let lxc_container_get = Fun_stubs.lxc_container_get

let lxc_container_put = Fun_stubs.lxc_container_put

let lxc_get_wait_states = Fun_stubs.lxc_get_wait_states

let lxc_get_global_config_item = Fun_stubs.lxc_get_global_config_item

let lxc_get_version = Fun_stubs.lxc_get_version

let list_defined_containers = Fun_stubs.list_defined_containers

let list_active_containers = Fun_stubs.list_active_containers

let list_all_containers = Fun_stubs.list_all_containers

let lxc_log_init = Fun_stubs.lxc_log_init

let lxc_log_close = Fun_stubs.lxc_log_close

let lxc_config_item_is_supported = Fun_stubs.lxc_config_item_is_supported

let lxc_has_api_extension = Fun_stubs.lxc_has_api_extension

                            (*$*)

(*$ #use "code_gen/gen.cinaps";;

*)
(*$*)
