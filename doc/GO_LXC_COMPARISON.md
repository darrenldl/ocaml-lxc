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

## container.go

| go-lxc                      | ocaml-lxc equivalent                                      |
| --------------------------- | --------------------------------------------------------- |
| `makeSure`                  | WIP                                                       |
| `cgroupItemAsByteSize`      | WIP                                                       |
| `setCgroupItemWithByteSize` | WIP                                                       |
| `Release`                   | N/A                                                       |
| `Name`                      | WIP                                                       |
| `String`                    | WIP                                                       |
| `Defined`                   | `Lxc.Container.is_defined`                                |
| `Running`                   | `Lxc.Container.is_running`                                |
| `Controllable`              | `Lxc.Container.may_control`                               |
| `CreateSnapshot`            | `Lxc.Container.Snapshot.create`                           |
| `RestoreSnapshot`           | `Lxc.Container.Snapshot.restore`                          |
| `DestroySnapshot`           | `Lxc.Container.Snapshot.destroy`                          |
| `DestroyAllSnapshots`       | `Lxc.Container.Snapshot.destroy_all`                      |
| `Snapshots`                 | `Lxc.Container.Snapshot.list`                             |
| `State`                     | `Lxc.Container.state`                                     |
| `InitPid`                   | `Lxc.Container.init_pid`                                  |
| `Daemonize`                 | WIP                                                       |
| `WantDaemonize`             | `Lxc.Container.set_want_daemonize`                        |
| `WantCloseAllFds`           | `Lxc.Container.set_want_close_all_fds`                    |
| `SetVerbosity`              | WIP                                                       |
| `Freeze`                    | `Lxc.Container.freeze`                                    |
| `Unfreeze`                  | `Lxc.Container.unfreeze`                                  |
| `Create`                    | `Lxc.Container.create`                                    |
| `Start`                     | `Lxc.Container.start`                                     |
| `Execute`                   | WIP                                                       |
| `Stop`                      | `Lxc.Container.stop`                                      |
| `Reboot`                    | `Lxc.Container.reboot`                                    |
| `Shutdown`                  | `Lxc.Container.shutdown`                                  |
| `Destroy`                   | `Lxc.Container.destroy`                                   |
| `DestroyWithAllSnapshots`   | `Lxc.Container.destroy_with_snapshots`                    |
| `Clone`                     | `Lxc.Container.Clone.clone`                               |
| `Rename`                    | `Lxc.Container.rename`                                    |
| `Wait`                      | `Lxc.Container.wait`                                      |
| `ConfigFileName`            | `Lxc.Container.config_file_name`                          |
| `ConfigItem`                | `Lxc.Container.get_config_item`                           |
| `SetConfigItem`             | `Lxc.Container.set_config_item`                           |
| `RunningConfigItem`         | `Lxc.Container.get_running_config_item`                   |
| `CgroupItem`                | `Lxc.Container.Cgroup.get`                                |
| `SetCgroupItem`             | `Lxc.Container.Cgroup.set`                                |
| `ClearConfig`               | `Lxc.Container.clear_config`                              |
| `ClearConfigItem`           | `Lxc.Container.clear_config_item`                         |
| `ConfigKeys`                | WIP                                                       |
| `LoadConfigFile`            | `Lxc.Container.load_config`                               |
| `SaveConfigFile`            | `Lxc.Container.save_config`                               |
| `ConfigPath`                | `Lxc.Container.get_config_path`                           |
| `SetConfigPath`             | `Lxc.Container.set_config_path`                           |
| `MemoryUsage`               | `Lxc.Container.Cgroup.Helpers.get_mem_usage_bytes`        |
| `MemoryLimit`               | `Lxc.Container.Cgroup.Helpers.get_mem_limit_bytes`        |
| `SetMemoryLimit`            | `Lxc.Container.Cgroup.Helpers.set_mem_limit_bytes`        |
| `SoftMemoryLimit`           | `Lxc.Container.Cgroup.Helpers.get_soft_mem_limit_bytes`   |
| `SetSoftMemoryLimit`        | `Lxc.Container.Cgroup.Helpers.set_soft_mem_limit_bytes`   |
| `KernelMemoryUsage`         | `Lxc.Container.Cgroup.Helpers.get_kernel_mem_usage_bytes` |
| `KernelMemoryLimit`         | `Lxc.Container.Cgroup.Helpers.get_kernel_mem_limit_bytes` |
| `SetKernelMemoryLimit`      | `Lxc.Container.Cgroup.Helpers.set_kernel_mem_limit_bytes` |
| `MemorySwapUsage`           | `Lxc.Container.Cgroup.Helpers.get_mem_swap_usage_bytes`   |
| `MemorySwapLimit`           | `Lxc.Container.Cgroup.Helpers.get_mem_swap_limit_bytes`   |
| `SetMemorySwapLimit`        | `Lxc.Container.Cgroup.Helpers.set_mem_swap_limit_bytes`   |
| `BlkioUsage`                | WIP                                                       |
| `CPUTime`                   | WIP                                                       |
| `CPUTimePerCPU`             | WIP                                                       |
| `CPUStats`                  | WIP                                                       |
| `ConsoleFd`                 | `Lxc.Container.console_getfd`                             |
| `Console`                   | `Lxc.Container.console`                                   |
| `AttachShell`               | `Lxc.Container.Attach.shell`                              |
| `RunCommandStatus`          | `Lxc.Container.Attach.run_command_ret_waitpid_status`     |
| `RunCommandNoWait`          | `Lxc.Container.Attach.run_command_no_wait`                |
| `RunCommand`                | WIP                                                       |
| `Interfaces`                | `Lxc.Container.get_interfaces`                            |
| `InterfaceStats`            | WIP                                                       |
| `IPAddress`                 | WIP                                                       |
| `IPv4Address`               | WIP                                                       |
| `IPv6Address`               | WIP                                                       |
| `WaitIPAddresses`           | WIP                                                       |
| `IPAddresses`               | WIP                                                       |
| `IPv4Addresses`             | WIP                                                       |
| `IPv6Addresses`             | WIP                                                       |
| `LogFile`                   | WIP                                                       |
| `SetLogFile`                | WIP                                                       |
| `LogLevel`                  | WIP                                                       |
| `SetLogLevel`               | WIP                                                       |
| `AddDeviceNode`             | `Lxc.Container.Device.add_node`                           |
| `RemoveDeviceNode`          | `Lxc.Container.Device.remove_node`                        |
| `Checkpoint`                | `Lxc.Container.Checkpoint.checkpoint`                     |
| `Restore`                   | `Lxc.Container.Checkpoint.restore`                        |
| `Migrate`                   | `Lxc.Container.Migrate.migrate`                           |
| `AttachInterface`           | `Lxc.Container.Interface.attach`                          |
| `DetachInterface`           | `Lxc.Container.Interface.detach`                          |
| `DetachInterfaceRename`     | WIP                                                       |
| `ConsoleLog`                | `Lxc.Container.console_log`                               |
| `ErrorNum`                  | WIP                                                       |
