ifeq ($(cc-name),clang)
ifneq ($(CROSS_COMPILE),)
CLANG_TRIPLE    ?= $(CROSS_COMPILE)
CLANG_FLAGS	+= --target=$(notdir $(CLANG_TRIPLE:%-=%))
GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)elfedit))
CLANG_FLAGS	+= --prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
GCC_TOOLCHAIN	:= $(realpath $(GCC_TOOLCHAIN_DIR)/..)
endif
ifneq ($(GCC_TOOLCHAIN),)
CLANG_FLAGS	+= --gcc-toolchain=$(GCC_TOOLCHAIN)
endif
CLANG_FLAGS	+= -no-integrated-as
CLANG_FLAGS	+= -Werror=unknown-warning-option
KBUILD_CFLAGS	+= $(CLANG_FLAGS)
KBUILD_AFLAGS	+= $(CLANG_FLAGS)
endif
