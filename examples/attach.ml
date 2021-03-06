let container_name = "playtime"

let () =
  let c = Lxc.new_container container_name |> Result.get_ok in
  if not (Lxc.Container.is_defined c) then (
    print_endline "Container is not defined";
    exit 1 );
  ( match Lxc.Container.Attach.shell c with
    | Ok _ ->
      print_endline "Attached shell successfully"
    | Error _ ->
      print_endline "Failed to run shell" );
  ( match
      Lxc.Container.Attach.run_command_ret_waitpid_status c ~argv:[|"id"|]
    with
    | Ok _ ->
      print_endline "Ran command successfully"
    | Error _ ->
      print_endline "Failed to run command" );
  ()
