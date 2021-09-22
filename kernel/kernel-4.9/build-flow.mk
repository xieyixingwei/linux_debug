
make -C ./kernel-4.9 ARCH=arm64 O=${TEGRA_KERNEL_OUT} tegra_defconfig

%config: scripts_basic outputmakefile FORCE
	# # 调用 Makefile.build 来使用 scripts/kconfig/生成tegra_defconfig
	$(Q)$(MAKE) $(build)=scripts/kconfig $@

scripts_basic:
	# 调用 Makefile.build 来编译 scripts/basic目录下的fixdep
	$(Q)$(MAKE) $(build)=scripts/basic
	$(Q)rm -f .tmp_quiet_recordmcount


# 调用 脚本 mkmakefile 生成 makefile
outputmakefile:
ifneq ($(KBUILD_SRC),)
	$(Q)ln -fsn $(srctree) source
	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkmakefile \
	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
endif

# 最后 使用命令 $(Q)$(MAKE) $(build)=scripts/kconfig $@
# 生成 tegra_defconfig文件

----------------------------------------------------------------------

make -C ./kernel-4.9 ARCH=arm64 O=${TEGRA_KERNEL_OUT}
