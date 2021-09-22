PWD := $(shell pwd)
TOOLCHAIN_DIR ?= $(PWD)/toolchains/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu
#JOBS = $(shell cat /proc/cpuinfo |grep "processor"|wc -l)
KERNEL_SRC := $(PWD)/kernel/kernel-4.9

export BUILD_OUT := $(PWD)/out
export LOCALVERSION := -tegra
export CROSS_COMPILE := $(TOOLCHAIN_DIR)/bin/aarch64-linux-gnu-

all:
	@make -C $(KERNEL_SRC) ARCH=arm64 O=$(BUILD_OUT)

defconfig:
	@echo make defconfig ......
	@make -C $(KERNEL_SRC) ARCH=arm64 O=$(BUILD_OUT) tegra_defconfig

dtbs:
	@make -C $(KERNEL_SRC) ARCH=arm64 O=$(BUILD_OUT) dtbs

install_modules:
	@echo install kernel modules ......
	@sudo make ARCH=arm64 O=$(BUILD_OUT) modules_install INSTALL_MOD_PATH=$(PWD)/rootfs -C $(KERNEL_SRC)

clean:
	@make clean -C $(KERNEL_SRC) ARCH=arm64 O=$(BUILD_OUT)

mrproper:
	@make mrproper -C $(KERNEL_SRC) ARCH=arm64 O=$(BUILD_OUT)

distclean:
	@make distclean -C $(KERNEL_SRC) ARCH=arm64 O=$(BUILD_OUT)

.PHONY: all defconfig clean mrproper distclean

