KBUILD_CFLAGS	+= $(call cc-option,-fno-PIE)
KBUILD_AFLAGS	+= $(call cc-option,-fno-PIE)
CFLAGS_GCOV	:= -fprofile-arcs -ftest-coverage -fno-tree-loop-im $(call cc-disable-warning,maybe-uninitialized,)
CFLAGS_KCOV	:= $(call cc-option,-fsanitize-coverage=trace-pc,)
export CFLAGS_GCOV CFLAGS_KCOV

# Make toolchain changes before including arch/$(SRCARCH)/Makefile to ensure
# ar/cc/ld-* macros return correct values.
ifdef CONFIG_LTO_CLANG
# use GNU gold with LLVMgold for LTO linking, and LD for vmlinux_link
LDFINAL_vmlinux := $(LD)
LD		:= $(LDGOLD)
LDFLAGS		+= -plugin LLVMgold.so
# use llvm-ar for building symbol tables from IR files, and llvm-dis instead
# of objdump for processing symbol versions and exports
LLVM_AR		:= llvm-ar
LLVM_DIS	:= llvm-dis
export LLVM_AR LLVM_DIS
endif

# The arch Makefile can set ARCH_{CPP,A,C}FLAGS to override the default
# values of the respective KBUILD_* variables
ARCH_CPPFLAGS :=
ARCH_AFLAGS :=
ARCH_CFLAGS :=
include arch/$(SRCARCH)/Makefile

KBUILD_CFLAGS	+= $(call cc-option,-fno-delete-null-pointer-checks,)
KBUILD_CFLAGS	+= $(call cc-disable-warning,frame-address,)
KBUILD_CFLAGS	+= $(call cc-disable-warning, format-truncation)
KBUILD_CFLAGS	+= $(call cc-disable-warning, format-overflow)
KBUILD_CFLAGS	+= $(call cc-disable-warning, int-in-bool-context)
KBUILD_CFLAGS	+= $(call cc-disable-warning, address-of-packed-member)
KBUILD_CFLAGS	+= $(call cc-disable-warning, attribute-alias)
KBUILD_CFLAGS   += $(call cc-disable-warning, address-of-packed-member)
KBUILD_CFLAGS   += $(call cc-disable-warning, packed-not-aligned)

ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
KBUILD_CFLAGS	+= $(call cc-option,-ffunction-sections,)
KBUILD_CFLAGS	+= $(call cc-option,-fdata-sections,)
endif

ifdef CONFIG_LTO_CLANG
lto-clang-flags	:= -flto -fvisibility=hidden

# allow disabling only clang LTO where needed
DISABLE_LTO_CLANG := -fno-lto -fvisibility=default
export DISABLE_LTO_CLANG
endif

ifdef CONFIG_LTO
lto-flags	:= $(lto-clang-flags)
KBUILD_CFLAGS	+= $(lto-flags)

DISABLE_LTO	:= $(DISABLE_LTO_CLANG)
export DISABLE_LTO

# LDFINAL_vmlinux and LDFLAGS_FINAL_vmlinux can be set to override
# the linker and flags for vmlinux_link.
export LDFINAL_vmlinux LDFLAGS_FINAL_vmlinux
endif

ifdef CONFIG_CFI_CLANG
cfi-clang-flags	+= -fsanitize=cfi
DISABLE_CFI_CLANG := -fno-sanitize=cfi
ifdef CONFIG_MODULES
cfi-clang-flags	+= -fsanitize-cfi-cross-dso
DISABLE_CFI_CLANG += -fno-sanitize-cfi-cross-dso
endif
ifdef CONFIG_CFI_PERMISSIVE
cfi-clang-flags	+= -fsanitize-recover=cfi -fno-sanitize-trap=cfi
endif

# also disable CFI when LTO is disabled
DISABLE_LTO_CLANG += $(DISABLE_CFI_CLANG)
# allow disabling only clang CFI where needed
export DISABLE_CFI_CLANG
endif

ifdef CONFIG_CFI
# cfi-flags are re-tested in prepare-compiler-check
cfi-flags	:= $(cfi-clang-flags)
KBUILD_CFLAGS	+= $(cfi-flags)

DISABLE_CFI	:= $(DISABLE_CFI_CLANG)
DISABLE_LTO	+= $(DISABLE_CFI)
export DISABLE_CFI
endif

ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
KBUILD_CFLAGS   += -Os
else
KBUILD_CFLAGS   += -O2
endif

# Tell gcc to never replace conditional load with a non-conditional one
KBUILD_CFLAGS	+= $(call cc-option,--param=allow-store-data-races=0)
KBUILD_CFLAGS	+= $(call cc-option,-fno-allow-store-data-races)

# check for 'asm goto'
ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC) $(KBUILD_CFLAGS)), y)
	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
	KBUILD_AFLAGS += -DCC_HAVE_ASM_GOTO
endif
