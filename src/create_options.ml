type t =
  { template : string option
  ; backing_store_type : Backing_store.store_type option
  ; backing_store_specs : Backing_store.Specs.t option
  ; distro : string option
  ; release : string option
  ; arch : string option
  ; variant : string option
  ; server : string option
  ; key_id : string option
  ; key_server : string option
  ; disable_gpg_validation : bool option
  ; flush_cache : bool option
  ; force_cache : bool option
  ; extra_args : string array option }

let blank =
  { template = None
  ; backing_store_type = None
  ; backing_store_specs = None
  ; distro = None
  ; release = None
  ; arch = None
  ; variant = None
  ; server = None
  ; key_id = None
  ; key_server = None
  ; disable_gpg_validation = None
  ; flush_cache = None
  ; force_cache = None
  ; extra_args = None }

module Templates = struct
  let download_ubuntu_trusty_amd64 =
    { blank with
      template = Some "download"
    ; distro = Some "ubuntu"
    ; release = Some "trusty"
    ; arch = Some "amd64" }

  let busybox = {blank with template = Some "busybox"}

  let ubuntu = {blank with distro = Some "ubuntu"}
end
