type t = {
  lxc_container : Lxc_c.Stubs.lxc_container Ctypes.structure Ctypes.ptr
}

let make ~name ~config_path =
  let lxc_container = Lxc_c.lxc_container_new name config_path in
  { lxc_container }
