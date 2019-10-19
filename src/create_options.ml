type t = {
  template : string option;
  backend_store : Backing_store.store_type option;
  bdev_specs : Bdev_specs.t option;
  distro : string option;
  release : string option;
  arch : string option;
  variant : string option;
  server : string option;
  key_id : string option;
  key_server : string option;
  disable_gpg_validation : bool option;
  flush_cache : bool option;
  force_cache : bool option;
  extra_args : string array option;
}

let blank = {
  template = None;
  backend_store = None;
  bdev_specs = None;
  distro = None;
  release = None;
  arch = None;
  variant = None;
  server = None;
  key_id = None;
  key_server = None;
  disable_gpg_validation = None;
  flush_cache = None;
  force_cache = None;
  extra_args = None;
}

module Templates = struct
  let download_ubuntu_trusty_and64 =
    { blank with
      template = Some "download";
      distro = Some "ubuntu";
      release = Some "trusty";
      arch = Some "amd64";
    }

  let busybox =
    { blank with
      template = Some "busybox"
    }

  let ubuntu =
    { blank with distro = Some "ubuntu" }
end
