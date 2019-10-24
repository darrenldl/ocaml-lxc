let container_name = "playtime"

let () =
  let c = Lxc.new_container container_name |> Result.get_ok in
  if not (Lxc.Container.is_defined c) then (
    print_endline "Container is not defined";
    exit 1 );
  ( match Lxc.Container.console c with
    | Ok _ ->
      ()
    | Error _ ->
      print_endline "Failed to run console" );
  ()
