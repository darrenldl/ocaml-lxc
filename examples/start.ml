let () =
  let c = Lxc.new_container "ocaml-lxc-example" |> Result.get_ok in
  match Lxc.Container.start c with
  | Ok _ ->
    print_endline "Ok"
  | Error _ ->
    print_endline "Error"
