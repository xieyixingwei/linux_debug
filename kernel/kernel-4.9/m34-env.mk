ifdef CONFIG_READABLE_ASM
# Disable optimizations that make assembler listings hard to read.
# reorder blocks reorders the control in the function
# ipa clone creates specialized cloned functions
# partial inlining inlines only parts of functions
KBUILD_CFLAGS += $(call cc-option,-fno-reorder-blocks,) \
                 $(call cc-option,-fno-ipa-cp-clone,) \
                 $(call cc-option,-fno-partial-inlining)
endif

ifneq ($(CONFIG_FRAME_WARN),0)
KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
endif

# This selects the stack protector compiler flag. Testing it is delayed
# until after .config has been reprocessed, in the prepare-compiler-check
# target.
ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
  stackp-flag := -fstack-protector
  stackp-name := REGULAR
else
ifdef CONFIG_CC_STACKPROTECTOR_STRONG
  stackp-flag := -fstack-protector-strong
  stackp-name := STRONG
else
  # Force off for distro compilers that enable stack protector by default.
  stackp-flag := $(call cc-option, -fno-stack-protector)
endif
endif
# Find arch-specific stack protector compiler sanity-checking script.
ifdef CONFIG_CC_STACKPROTECTOR
  stackp-path := $(srctree)/scripts/gcc-$(SRCARCH)_$(BITS)-has-stack-protector.sh
  stackp-check := $(wildcard $(stackp-path))
endif
KBUILD_CFLAGS += $(stackp-flag)

ifeq ($(cc-name),clang)
KBUILD_CPPFLAGS += $(call cc-option,-Qunused-arguments,)
KBUILD_CFLAGS += $(call cc-disable-warning, format-invalid-specifier)
KBUILD_CFLAGS += $(call cc-disable-warning, gnu)
KBUILD_CFLAGS += $(call cc-disable-warning, duplicate-decl-specifier)
# Quiet clang warning: comparison of unsigned expression < 0 is always false
KBUILD_CFLAGS += $(call cc-disable-warning, tautological-compare)
# CLANG uses a _MergedGlobals as optimization, but this breaks modpost, as the
# source of a reference will be _MergedGlobals and not on of the whitelisted names.
# See modpost pattern 2
KBUILD_CFLAGS += $(call cc-option, -mno-global-merge,)
KBUILD_CFLAGS += $(call cc-option, -fcatch-undefined-behavior)
else

# These warnings generated too much noise in a regular build.
# Use make W=1 to enable them (see scripts/Makefile.extrawarn)
KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
endif

KBUILD_CFLAGS += $(call cc-disable-warning, unused-const-variable)
ifdef CONFIG_FRAME_POINTER
KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
else
# Some targets (ARM with Thumb2, for example), can't be built with frame
# pointers.  For those, we don't have FUNCTION_TRACER automatically
# select FRAME_POINTER.  However, FUNCTION_TRACER adds -pg, and this is
# incompatible with -fomit-frame-pointer with current GCC, so we don't use
# -fomit-frame-pointer with FUNCTION_TRACER.
ifndef CONFIG_FUNCTION_TRACER
KBUILD_CFLAGS	+= -fomit-frame-pointer
endif
endif

KBUILD_CFLAGS   += $(call cc-option, -fno-var-tracking-assignments)

ifdef CONFIG_DEBUG_INFO
ifdef CONFIG_DEBUG_INFO_SPLIT
KBUILD_CFLAGS   += $(call cc-option, -gsplit-dwarf, -g)
else
KBUILD_CFLAGS	+= -g
endif
KBUILD_AFLAGS	+= -Wa,-gdwarf-2
endif
ifdef CONFIG_DEBUG_INFO_DWARF4
KBUILD_CFLAGS	+= $(call cc-option, -gdwarf-4,)
endif

ifdef CONFIG_DEBUG_INFO_REDUCED
KBUILD_CFLAGS 	+= $(call cc-option, -femit-struct-debug-baseonly) \
		   $(call cc-option,-fno-var-tracking)
endif

ifdef CONFIG_FUNCTION_TRACER
ifndef CC_FLAGS_FTRACE
CC_FLAGS_FTRACE := -pg
endif
export CC_FLAGS_FTRACE
ifdef CONFIG_HAVE_FENTRY
CC_USING_FENTRY	:= $(call cc-option, -mfentry -DCC_USING_FENTRY)
endif
KBUILD_CFLAGS	+= $(CC_FLAGS_FTRACE) $(CC_USING_FENTRY)
KBUILD_AFLAGS	+= $(CC_USING_FENTRY)
ifdef CONFIG_DYNAMIC_FTRACE
	ifdef CONFIG_HAVE_C_RECORDMCOUNT
		BUILD_C_RECORDMCOUNT := y
		export BUILD_C_RECORDMCOUNT
	endif
endif
endif

# We trigger additional mismatches with less inlining
ifdef CONFIG_DEBUG_SECTION_MISMATCH
KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
endif

# arch Makefile may override CC so keep this after arch Makefile is included
NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
CHECKFLAGS     += $(NOSTDINC_FLAGS)

# warn about C99 declaration after statement
KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)

# disable pointer signed / unsigned warnings in gcc 4.0
KBUILD_CFLAGS += $(call cc-disable-warning, pointer-sign)

# disable stringop warnings in gcc 8+
KBUILD_CFLAGS += $(call cc-disable-warning, stringop-truncation)

# We'll want to enable this eventually, but it's not going away for 5.7 at least
KBUILD_CFLAGS += $(call cc-disable-warning, zero-length-bounds)
KBUILD_CFLAGS += $(call cc-disable-warning, array-bounds)
KBUILD_CFLAGS += $(call cc-disable-warning, stringop-overflow)

# Another good warning that we'll want to enable eventually
KBUILD_CFLAGS += $(call cc-disable-warning, restrict)

# Enabled with W=2, disabled by default as noisy
KBUILD_CFLAGS += $(call cc-disable-warning, maybe-uninitialized)

# disable invalid "can't wrap" optimizations for signed / pointers
KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)

# clang sets -fmerge-all-constants by default as optimization, but this
# is non-conforming behavior for C and in fact breaks the kernel, so we
# need to disable it here generally.
KBUILD_CFLAGS	+= $(call cc-option,-fno-merge-all-constants)

# for gcc -fno-merge-all-constants disables everything, but it is fine
# to have actual conforming behavior enabled.
KBUILD_CFLAGS	+= $(call cc-option,-fmerge-constants)

# Make sure -fstack-check isn't enabled (like gentoo apparently did)
KBUILD_CFLAGS  += $(call cc-option,-fno-stack-check,)

# conserve stack if available
KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)

# disallow errors like 'EXPORT_GPL(foo);' with missing header
KBUILD_CFLAGS   += $(call cc-option,-Werror=implicit-int)

# require functions to have arguments in prototypes, not empty 'int foo()'
KBUILD_CFLAGS   += $(call cc-option,-Werror=strict-prototypes)

# Prohibit date/time macros, which would make the build non-deterministic
KBUILD_CFLAGS   += $(call cc-option,-Werror=date-time)

# enforce correct pointer usage
KBUILD_CFLAGS   += $(call cc-option,-Werror=incompatible-pointer-types)

# Require designated initializers for all marked structures
KBUILD_CFLAGS   += $(call cc-option,-Werror=designated-init)

# change __FILE__ to the relative path from the srctree
KBUILD_CFLAGS	+= $(call cc-option,-fmacro-prefix-map=$(srctree)/=)

# ensure -fcf-protection is disabled when using retpoline as it is
# incompatible with -mindirect-branch=thunk-extern
ifdef CONFIG_RETPOLINE
KBUILD_CFLAGS += $(call cc-option,-fcf-protection=none)
endif

# use the deterministic mode of AR if available
KBUILD_ARFLAGS := $(call ar-option,D)
