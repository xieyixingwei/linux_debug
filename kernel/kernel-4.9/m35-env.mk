# Add any arch overrides and user supplied CPPFLAGS, AFLAGS and CFLAGS as the
# last assignments
KBUILD_CPPFLAGS += $(ARCH_CPPFLAGS) $(KCPPFLAGS)
KBUILD_AFLAGS   += $(ARCH_AFLAGS)   $(KAFLAGS)
KBUILD_CFLAGS   += $(ARCH_CFLAGS)   $(KCFLAGS)

# Use --build-id when available.
LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
			      $(call cc-ldoption, -Wl$(comma)--build-id,))
KBUILD_LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)

ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
LDFLAGS_vmlinux	+= $(call ld-option, --gc-sections,)
endif

ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
LDFLAGS_vmlinux	+= $(call ld-option, -X,)
endif

# Default kernel image to build when no specific target is given.
# KBUILD_IMAGE may be overruled on the command line or
# set in the environment
# Also any assignments in arch/$(ARCH)/Makefile take precedence over
# this default value
export KBUILD_IMAGE ?= vmlinux

#
# INSTALL_PATH specifies where to place the updated kernel and system map
# images. Default is /boot, but you can set it to other values
export	INSTALL_PATH ?= /boot

#
# INSTALL_DTBS_PATH specifies a prefix for relocations required by build roots.
# Like INSTALL_MOD_PATH, it isn't defined in the Makefile, but can be passed as
# an argument if needed. Otherwise it defaults to the kernel install path
#
export INSTALL_DTBS_PATH ?= $(INSTALL_PATH)/dtbs/$(KERNELRELEASE)

#
# INSTALL_MOD_PATH specifies a prefix to MODLIB for module directory
# relocations required by build roots.  This is not defined in the
# makefile but the argument can be passed to make if needed.
#

MODLIB	= $(INSTALL_MOD_PATH)/lib/modules/$(KERNELRELEASE)
export MODLIB

#
# INSTALL_MOD_STRIP, if defined, will cause modules to be
# stripped after they are installed.  If INSTALL_MOD_STRIP is '1', then
# the default option --strip-debug will be used.  Otherwise,
# INSTALL_MOD_STRIP value will be used as the options to the strip command.

ifdef INSTALL_MOD_STRIP
ifeq ($(INSTALL_MOD_STRIP),1)
mod_strip_cmd = $(STRIP) --strip-debug
else
mod_strip_cmd = $(STRIP) $(INSTALL_MOD_STRIP)
endif # INSTALL_MOD_STRIP=1
else
mod_strip_cmd = true
endif # INSTALL_MOD_STRIP
export mod_strip_cmd

# CONFIG_MODULE_COMPRESS, if defined, will cause module to be compressed
# after they are installed in agreement with CONFIG_MODULE_COMPRESS_GZIP
# or CONFIG_MODULE_COMPRESS_XZ.

mod_compress_cmd = true
ifdef CONFIG_MODULE_COMPRESS
  ifdef CONFIG_MODULE_COMPRESS_GZIP
    mod_compress_cmd = gzip -n -f
  endif # CONFIG_MODULE_COMPRESS_GZIP
  ifdef CONFIG_MODULE_COMPRESS_XZ
    mod_compress_cmd = xz -f
  endif # CONFIG_MODULE_COMPRESS_XZ
endif # CONFIG_MODULE_COMPRESS
export mod_compress_cmd

# Select initial ramdisk compression format, default is gzip(1).
# This shall be used by the dracut(8) tool while creating an initramfs image.
#
INITRD_COMPRESS-y                  := gzip
INITRD_COMPRESS-$(CONFIG_RD_BZIP2) := bzip2
INITRD_COMPRESS-$(CONFIG_RD_LZMA)  := lzma
INITRD_COMPRESS-$(CONFIG_RD_XZ)    := xz
INITRD_COMPRESS-$(CONFIG_RD_LZO)   := lzo
INITRD_COMPRESS-$(CONFIG_RD_LZ4)   := lz4
# do not export INITRD_COMPRESS, since we didn't actually
# choose a sane default compression above.
# export INITRD_COMPRESS := $(INITRD_COMPRESS-y)

ifdef CONFIG_MODULE_SIG_ALL
$(eval $(call config_filename,MODULE_SIG_KEY))

mod_sign_cmd = scripts/sign-file $(CONFIG_MODULE_SIG_HASH) $(MODULE_SIG_KEY_SRCPREFIX)$(CONFIG_MODULE_SIG_KEY) certs/signing_key.x509
else
mod_sign_cmd = true
endif
export mod_sign_cmd
