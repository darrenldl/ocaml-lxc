let () =
  let c = Lxc.new_container "playtime" |> Result.get_ok in
  match Lxc.Container.create Lxc.Create_options.Templates.busybox c with
  | Ok _ -> print_endline "Ok"
  | Error _ -> print_endline "Error"
