let clean_up_and_exit c =
  Option.iter (fun c -> Lxc.release c |> Result.get_ok) c;
  exit 1

let () =
  let c =
    match Lxc.new_container "apicontainer" with
    | Ok c ->
      c
    | Error _ ->
      Printf.eprintf "Failed to setup lxc_container\n";
      clean_up_and_exit None
  in
  if Lxc.Container.is_defined c then (
    Printf.eprintf "Container already exists\n";
    clean_up_and_exit (Some c) );
  (* Create the container *)
  let create_options =
    { Lxc.Create_options.blank with
      template = Some "download"
    ; distro = Some "ubuntu"
    ; release = Some "trusty"
    ; arch = Some "i386" }
  in
  Lxc.Container.create c create_options
  |> Result.iter_error (fun _ ->
      Printf.eprintf "Failed to create container rootfs\n";
      clean_up_and_exit (Some c));
  (* Start the container *)
  Lxc.Container.start c
  |> Result.iter_error (fun _ ->
      Printf.eprintf "Failed to start container rootfs\n";
      clean_up_and_exit (Some c));
  (* Query some information *)
  Printf.printf "Container state: %s\n"
    (Lxc.Container.state c |> Lxc.State.to_string);
  Printf.printf "Container PID: %d\n" (Lxc.Container.init_pid c);
  (* Stop the container *)
  Lxc.Container.shutdown c ~timeout:30
  |> Result.iter_error (fun _ ->
      Printf.printf "Failed to cleanly shutdown the container, forcing\n";
      Lxc.Container.stop c
      |> Result.iter_error (fun _ ->
          Printf.eprintf "Failed to kill the container\n";
          clean_up_and_exit (Some c)));
  (* Destroy the container *)
  Lxc.Container.destroy c
  |> Result.iter_error (fun _ ->
      Printf.eprintf "Failed to destroy the container\n";
      clean_up_and_exit (Some c))
