# Comparison to go-lxc

## lxc-binding.go

| go-lxc                        | ocaml-lxc equivalent               |
| ----------------------------- | ---------------------------------- |
| `NewContainer`                | `Lxc.new_container`                |
| `Acquire`                     | `Lxc.acquire`                      |
| `Release`                     | `Lxc.release`                      |
| `Version`                     | `Lxc.lxc_version_string`           |
| `GlobalConfigItem`            | `Lxc.get_global_config_item`       |
| `DefaultConfigPath`           | WIP                                |
| `DefaultLvmVg`                | WIP                                |
| `DefaultZfRoot`               | WIP                                |
| `ContainerNames`              | `Lxc.list_all_container_names`     |
| `Containers`                  | `Lxc.list_all_containers`          |
| `DefinedContainerNames`       | `Lxc.list_defined_container_names` |
| `DefinedContaineres`          | `Lxc.list_defined_containers`      |
| `ActiveContainerNames`        | `Lxc.list_active_container_names`  |
| `ActiveContainers`            | `Lxc.list_active_containers`       |
| `VersionNumber`               | `Lxc.lxc_version`                  |
| `VersionAtLeast`              | WIP                                |
| `IsSupportedConfigItem`       | `Lxc.config_item_is_supported`     |
| `runtimeLiblxcVersionAtLeast` | WIP                                |
| `HasApiExtension`             | `Lxc.has_api_extension`            |
