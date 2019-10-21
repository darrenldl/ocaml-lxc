let () =
  let c = Lxc.new_container "playtime" |> Result.get_ok in
  match Lxc.Container.Create.create c Lxc.Container.Create.Templates.download_ubuntu_trusty_amd64 with
  | Ok _ -> print_endline "Ok"
  | Error _ -> print_endline "Error"
