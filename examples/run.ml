let container_name = "ocaml-lxc_example"

let () =
  let c = Lxc.new_container container_name |> Result.get_ok in
  if not (Lxc.Container.is_defined c) then (
    print_endline "Container is not defined";
    exit 1 );
  print_endline "Container.Run.shell";
  ( match Lxc.Container.Run.shell c with
    | Ok _ ->
      ()
    | Error _ ->
      print_endline "Failed to run shell";
      exit 1 );
  print_endline "Container.Run.command";
  ( match Lxc.Container.Run.command_ret_waitpid_status c ~argv:[|"id"|] with
    | Ok _ ->
      ()
    | Error _ ->
      print_endline "Failed to run shell";
      exit 1 );
  ()
