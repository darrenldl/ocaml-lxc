let () =
  let c = Lxc.new_container "playtime" |> Result.get_ok in
  match Lxc.Container.create c Lxc.Create_options.Templates.download_ubuntu_trusty_amd64 with
  | Ok _ -> print_endline "Ok"
  | Error _ -> print_endline "Error"
