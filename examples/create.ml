let container_name = "ocaml-lxc_example"

let () =
  let c = Lxc.new_container container_name |> Result.get_ok in
  match Lxc.Container.create c Lxc.Create_options.Templates.download_ubuntu_trusty_amd64 with
  | Ok _ -> print_endline "Ok"
  | Error _ -> print_endline "Error"
