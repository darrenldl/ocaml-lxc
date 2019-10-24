let container_name = "ocaml-lxc-example"

let () =
  let c = Lxc.new_container container_name |> Result.get_ok in
  Lxc.Container.Checkpoint.checkpoint c ~dir:"/tmp/ocaml-lxc-example"
    ~stop:false ~verbose:true
  |> Result.get_ok
