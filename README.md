# kernel

## how to compile kernel, dts and modules

- run "make help" to see the help.

## compilation results

- The compilation results:
  1. Kernel Image: $TEGRA_KERNEL_OUT/arch/arm64/boot/Image
  2. DTB: $TEGRA_KERNEL_OUT/arch/arm64/boot/dts/

## how to install the kernel modules

``` shell
$ sudo make ARCH=arm64 O=$TEGRA_KERNEL_OUT modules_install INSTALL_MOD_PATH=<top>/Linux_for_Tegra/rootfs/
```

Optionally, archive the installed kernel modules using the following command:

``` shell
$ cd <modules_install_path>

$ tar --owner root --group root -cjf kernel_supplements.tbz2 lib/modules
```

- The installed modules can be used to provide the contents of /lib/modules/<kernel_version> on the target system.
- Use the archive to replace the one in the kernel directory of the extracted release package prior to running apply_binaries.sh.

> apply_binaries.sh in Linux_for_Tegra/kernel/kernel_supplements.tbz2

