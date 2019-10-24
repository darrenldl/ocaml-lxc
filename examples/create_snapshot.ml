let container_name = "ocaml-lxc-example"

let () =
  let c = Lxc.new_container container_name |> Result.get_ok in
  match Lxc.Container.Snapshot.create c with
  | Ok _ ->
    print_endline "Ok"
  | Error _ ->
    print_endline "Error"
