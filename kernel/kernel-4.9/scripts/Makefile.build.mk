# ==========================================================================
# Building
# ==========================================================================
$(info --- Makefile.build.mk)
$(info ------ obj=$(obj))

src := $(obj)

PHONY := __build
__build:

# Init all relevant variables used in kbuild files so
# 1) they have correct type
# 2) they do not inherit any value from the environment
obj-y :=
obj-m :=
lib-y :=
lib-m :=
always :=
targets :=
subdir-y :=
subdir-m :=
EXTRA_AFLAGS   :=
EXTRA_CFLAGS   :=
EXTRA_CPPFLAGS :=
EXTRA_LDFLAGS  :=
asflags-y  :=
ccflags-y  :=
cppflags-y :=
ldflags-y  :=

subdir-asflags-y :=
subdir-ccflags-y :=

# Read auto.conf if it exists, otherwise ignore
$(info ------ [-include] include/config/auto.conf)
-include include/config/auto.conf

$(info ------ [include] scripts/Kbuild.include.mk)
include scripts/Kbuild.include.mk

# For backward compatibility check that these variables do not change
save-cflags := $(CFLAGS)

# The filename Kbuild has precedence over Makefile
kbuild-dir := $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
kbuild-file := $(if $(wildcard $(kbuild-dir)/Kbuild),$(kbuild-dir)/Kbuild,$(kbuild-dir)/Makefile)

$(info ------ kbuild-dir=$(kbuild-dir))
$(info ------ kbuild-file=$(kbuild-file))

ifneq ("$(wildcard $(kbuild-file))", "")
$(info ------ [include] $(kbuild-file))
include $(kbuild-file)
endif
$(info ------ [include] $(srctree)/scripts/Makefile.tegra.mk)
include $(srctree)/scripts/Makefile.tegra.mk

# If the save-* variables changed error out
ifeq ($(KBUILD_NOPEDANTIC),)
        ifneq ("$(save-cflags)","$(CFLAGS)")
                $(error CFLAGS was changed in "$(kbuild-file)". Fix it to use ccflags-y)
        endif
endif

$(info ------ [include] scripts/Makefile.lib.mk)
include scripts/Makefile.lib.mk

ifdef host-progs
ifneq ($(hostprogs-y),$(host-progs))
$(warning kbuild: $(obj)/Makefile - Usage of host-progs is deprecated. Please replace with hostprogs-y!)
hostprogs-y += $(host-progs)
endif
endif

# Do not include host rules unless needed
ifneq ($(hostprogs-y)$(hostprogs-m)$(hostlibs-y)$(hostlibs-m)$(hostcxxlibs-y)$(hostcxxlibs-m),)
$(info ------ [include] scripts/Makefile.host.mk)
include scripts/Makefile.host.mk
endif

# Create output directory if not already present
_dummy := $(shell [ -d $(obj) ] || mkdir -p $(obj))

# Create directories for object files if directory does not exist
# Needed when obj-y := dir/file.o syntax is used
_dummy := $(foreach d,$(obj-dirs), $(shell [ -d $(d) ] || mkdir -p $(d)))

ifndef obj
$(warning kbuild: Makefile.build.mk is included improperly)
endif

# ===========================================================================

ifneq ($(strip $(lib-y) $(lib-m) $(lib-)),)
lib-target := $(obj)/lib.a
obj-y += $(obj)/lib-ksyms.o
endif

ifneq ($(strip $(obj-y) $(obj-m) $(obj-) $(subdir-m) $(lib-target)),)
builtin-target := $(obj)/built-in.o
endif

modorder-target := $(obj)/modules.order

# We keep a list of all modules in $(MODVERDIR)

ifneq ($(KBUILD_BUILTIN),)
$(info ------ KBUILD_BUILTIN=$(KBUILD_BUILTIN))
$(info --------- builtin-target=$(builtin-target))
$(info --------- lib-target=$(lib-target))
$(info --------- extra-y=$(extra-y))
endif

$(info ------ subdir-ym=$(subdir-ym))
$(info ------ always=$(always))

__build: $(if $(KBUILD_BUILTIN),$(builtin-target) $(lib-target) $(extra-y)) \
	 $(if $(KBUILD_MODULES),$(obj-m) $(modorder-target)) \
	 $(subdir-ym) $(always)
	@:

# Linus' kernel sanity checking tool
ifneq ($(KBUILD_CHECKSRC),0)
  ifeq ($(KBUILD_CHECKSRC),2)
    quiet_cmd_force_checksrc = CHECK   $<
          cmd_force_checksrc = $(CHECK) $(CHECKFLAGS) $(c_flags) $< ;
  else
      quiet_cmd_checksrc     = CHECK   $<
            cmd_checksrc     = $(CHECK) $(CHECKFLAGS) $(c_flags) $< ;
  endif
endif

# Do section mismatch analysis for each module/built-in.o
ifdef CONFIG_DEBUG_SECTION_MISMATCH
  cmd_secanalysis = ; scripts/mod/modpost $@
endif

# Compile C sources (.c)
# ---------------------------------------------------------------------------

# Default is built-in, unless we know otherwise
modkern_cflags =                                          \
	$(if $(part-of-module),                           \
		$(KBUILD_CFLAGS_MODULE) $(CFLAGS_MODULE), \
		$(KBUILD_CFLAGS_KERNEL) $(CFLAGS_KERNEL))
quiet_modtag := $(empty)   $(empty)

$(real-objs-m)        : part-of-module := y
$(real-objs-m:.o=.i)  : part-of-module := y
$(real-objs-m:.o=.s)  : part-of-module := y
$(real-objs-m:.o=.lst): part-of-module := y

$(real-objs-m)        : quiet_modtag := [M]
$(real-objs-m:.o=.i)  : quiet_modtag := [M]
$(real-objs-m:.o=.s)  : quiet_modtag := [M]
$(real-objs-m:.o=.lst): quiet_modtag := [M]

$(obj-m)              : quiet_modtag := [M]

# Default for not multi-part modules
modname = $(basetarget)

$(multi-objs-m)         : modname = $(modname-multi)
$(multi-objs-m:.o=.i)   : modname = $(modname-multi)
$(multi-objs-m:.o=.s)   : modname = $(modname-multi)
$(multi-objs-m:.o=.lst) : modname = $(modname-multi)
$(multi-objs-y)         : modname = $(modname-multi)
$(multi-objs-y:.o=.i)   : modname = $(modname-multi)
$(multi-objs-y:.o=.s)   : modname = $(modname-multi)
$(multi-objs-y:.o=.lst) : modname = $(modname-multi)

quiet_cmd_cc_s_c = CC $(quiet_modtag)  $@
cmd_cc_s_c       = $(CC) $(c_flags) $(DISABLE_LTO) -fverbose-asm -S -o $@ $<

$(obj)/%.s: $(src)/%.c FORCE
	$(call if_changed_dep,cc_s_c)

quiet_cmd_cpp_i_c = CPP $(quiet_modtag) $@
cmd_cpp_i_c       = $(CPP) $(c_flags) -o $@ $<

$(obj)/%.i: $(src)/%.c FORCE
	$(call if_changed_dep,cpp_i_c)

# These mirror gensymtypes_S and co below, keep them in synch.
cmd_gensymtypes_c =                                                         \
    $(CPP) -D__GENKSYMS__ $(c_flags) $< |                                   \
    $(GENKSYMS) $(if $(1), -T $(2))                                         \
     $(patsubst y,-s _,$(CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX))             \
     $(if $(KBUILD_PRESERVE),-p)                                            \
     -r $(firstword $(wildcard $(2:.symtypes=.symref) /dev/null))

quiet_cmd_cc_symtypes_c = SYM $(quiet_modtag) $@
cmd_cc_symtypes_c =                                                         \
    set -e;                                                                 \
    $(call cmd_gensymtypes_c,true,$@) >/dev/null;                           \
    test -s $@ || rm -f $@

$(obj)/%.symtypes : $(src)/%.c FORCE
	$(call cmd,cc_symtypes_c)

# LLVM assembly
# Generate .ll files from .c
quiet_cmd_cc_ll_c = CC $(quiet_modtag)  $@
      cmd_cc_ll_c = $(CC) $(c_flags) -emit-llvm -S -o $@ $<

$(obj)/%.ll: $(src)/%.c FORCE
	$(call if_changed_dep,cc_ll_c)

# C (.c) files
# The C file is compiled and updated dependency information is generated.
# (See cmd_cc_o_c + relevant part of rule_cc_o_c)

quiet_cmd_cc_o_c = CC $(quiet_modtag)  $@

ifndef CONFIG_MODVERSIONS
cmd_cc_o_c = $(CC) $(c_flags) -c -o $@ $<

else
# When module versioning is enabled the following steps are executed:
# o compile a .tmp_<file>.o from <file>.c
# o if .tmp_<file>.o doesn't contain a __ksymtab version, i.e. does
#   not export symbols, we just rename .tmp_<file>.o to <file>.o and
#   are done.
# o otherwise, we calculate symbol versions using the good old
#   genksyms on the preprocessed source and postprocess them in a way
#   that they are usable as a linker script
# o generate <file>.o from .tmp_<file>.o using the linker to
#   replace the unresolved symbols __crc_exported_symbol with
#   the actual value of the checksum generated by genksyms

cmd_cc_o_c = $(CC) $(c_flags) -c -o $(@D)/.tmp_$(@F) $<

ifdef CONFIG_LTO_CLANG
# Generate .o.symversions files for each .o with exported symbols, and link these
# to the kernel and/or modules at the end.
cmd_modversions_c =								\
	if $(OBJDUMP) -h $(@D)/.tmp_$(@F) >/dev/null 2>/dev/null; then		\
		if $(OBJDUMP) -h $(@D)/.tmp_$(@F) | grep -q __ksymtab; then	\
			$(call cmd_gensymtypes_c,$(KBUILD_SYMTYPES),$(@:.o=.symtypes)) \
			    > $(@D)/$(@F).symversions;				\
		fi;								\
	else									\
		if $(LLVM_DIS) -o=- $(@D)/.tmp_$(@F) | grep -q __ksymtab; then	\
			$(call cmd_gensymtypes_c,$(KBUILD_SYMTYPES),$(@:.o=.symtypes)) \
			    > $(@D)/$(@F).symversions;				\
		fi;								\
	fi;									\
	mv -f $(@D)/.tmp_$(@F) $@;
else
cmd_modversions_c =								\
	if $(OBJDUMP) -h $(@D)/.tmp_$(@F) | grep -q __ksymtab; then		\
		$(call cmd_gensymtypes_c,$(KBUILD_SYMTYPES),$(@:.o=.symtypes))	\
		    > $(@D)/.tmp_$(@F:.o=.ver);					\
										\
		$(LD) $(LDFLAGS) -r -o $@ $(@D)/.tmp_$(@F) 			\
			-T $(@D)/.tmp_$(@F:.o=.ver);				\
		rm -f $(@D)/.tmp_$(@F) $(@D)/.tmp_$(@F:.o=.ver);		\
	else									\
		mv -f $(@D)/.tmp_$(@F) $@;					\
	fi;
endif
endif

ifdef CONFIG_FTRACE_MCOUNT_RECORD
ifdef BUILD_C_RECORDMCOUNT
ifeq ("$(origin RECORDMCOUNT_WARN)", "command line")
  RECORDMCOUNT_FLAGS = -w
endif

ifdef CONFIG_LTO_CLANG
# With LTO, we postpone running recordmcount until after the LTO link step, so
# let's export the parameters for the link script.
export RECORDMCOUNT_FLAGS
else
# Due to recursion, we must skip empty.o.
# The empty.o file is created in the make process in order to determine
#  the target endianness and word size. It is made before all other C
#  files, including recordmcount.
sub_cmd_record_mcount =					\
	if [ $(@) != "scripts/mod/empty.o" ]; then	\
		$(objtree)/scripts/recordmcount $(RECORDMCOUNT_FLAGS) "$(@)";	\
	fi;
endif

recordmcount_source := $(srctree)/scripts/recordmcount.c \
		    $(srctree)/scripts/recordmcount.h
else # !BUILD_C_RECORDMCOUNT
sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
	"$(if $(CONFIG_64BIT),64,32)" \
	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
	"$(if $(part-of-module),1,0)" "$(@)";

recordmcount_source := $(srctree)/scripts/recordmcount.pl
endif # BUILD_C_RECORDMCOUNT

ifndef CONFIG_LTO_CLANG
cmd_record_mcount =						\
	if [ "$(findstring $(CC_FLAGS_FTRACE),$(_c_flags))" =	\
	     "$(CC_FLAGS_FTRACE)" ]; then			\
		$(sub_cmd_record_mcount)			\
	fi;
endif
endif # CONFIG_FTRACE_MCOUNT_RECORD

ifdef CONFIG_STACK_VALIDATION
ifneq ($(SKIP_STACK_VALIDATION),1)

__objtool_obj := $(objtree)/tools/objtool/objtool

objtool_args = check
ifndef CONFIG_FRAME_POINTER
objtool_args += --no-fp
endif
ifdef CONFIG_GCOV_KERNEL
objtool_args += --no-unreachable
endif

# 'OBJECT_FILES_NON_STANDARD := y': skip objtool checking for a directory
# 'OBJECT_FILES_NON_STANDARD_foo.o := 'y': skip objtool checking for a file
# 'OBJECT_FILES_NON_STANDARD_foo.o := 'n': override directory skip for a file
cmd_objtool = $(if $(patsubst y%,, \
	$(OBJECT_FILES_NON_STANDARD_$(basetarget).o)$(OBJECT_FILES_NON_STANDARD)n), \
	$(__objtool_obj) $(objtool_args) "$(@)";)
objtool_obj = $(if $(patsubst y%,, \
	$(OBJECT_FILES_NON_STANDARD_$(basetarget).o)$(OBJECT_FILES_NON_STANDARD)n), \
	$(__objtool_obj))

endif # SKIP_STACK_VALIDATION
endif # CONFIG_STACK_VALIDATION

define rule_cc_o_c
	$(call echo-cmd,checksrc) $(cmd_checksrc)			  \
	$(call cmd_and_fixdep,cc_o_c)					  \
	$(cmd_modversions_c)						  \
	$(cmd_objtool)						          \
	$(call echo-cmd,record_mcount) $(cmd_record_mcount)
endef

define rule_as_o_S
	$(call cmd_and_fixdep,as_o_S)					  \
	$(cmd_modversions_S)						  \
	$(cmd_objtool)
endef

# List module undefined symbols (or empty line if not enabled)
ifdef CONFIG_TRIM_UNUSED_KSYMS
cmd_undef_syms = $(NM) $@ | sed -n 's/^ \+U //p' | xargs echo
else
cmd_undef_syms = echo
endif

# Built-in and composite module parts
$(obj)/%.o: $(src)/%.c $(recordmcount_source) $(objtool_obj) FORCE
	@echo ------ make $@
	$(call cmd,force_checksrc)
	$(call if_changed_rule,cc_o_c)

# Single-part modules are special since we need to mark them in $(MODVERDIR)

$(single-used-m): $(obj)/%.o: $(src)/%.c $(recordmcount_source) $(objtool_obj) FORCE
	$(call cmd,force_checksrc)
	$(call if_changed_rule,cc_o_c)
	@{ echo $(@:.o=.ko); echo $@; \
	   $(cmd_undef_syms); } > $(MODVERDIR)/$(@F:.o=.mod)

quiet_cmd_cc_lst_c = MKLST   $@
      cmd_cc_lst_c = $(CC) $(c_flags) -g -c -o $*.o $< && \
		     $(CONFIG_SHELL) $(srctree)/scripts/makelst $*.o \
				     System.map $(OBJDUMP) > $@

$(obj)/%.lst: $(src)/%.c FORCE
	$(call if_changed_dep,cc_lst_c)

# Compile assembler sources (.S)
# ---------------------------------------------------------------------------

modkern_aflags := $(KBUILD_AFLAGS_KERNEL) $(AFLAGS_KERNEL)

$(real-objs-m)      : modkern_aflags := $(KBUILD_AFLAGS_MODULE) $(AFLAGS_MODULE)
$(real-objs-m:.o=.s): modkern_aflags := $(KBUILD_AFLAGS_MODULE) $(AFLAGS_MODULE)

# .S file exports must have their C prototypes defined in asm/asm-prototypes.h
# or a file that it includes, in order to get versioned symbols. We build a
# dummy C file that includes asm-prototypes and the EXPORT_SYMBOL lines from
# the .S file (with trailing ';'), and run genksyms on that, to extract vers.
#
# This is convoluted. The .S file must first be preprocessed to run guards and
# expand names, then the resulting exports must be constructed into plain
# EXPORT_SYMBOL(symbol); to build our dummy C file, and that gets preprocessed
# to make the genksyms input.
#
# These mirror gensymtypes_c and co above, keep them in synch.
cmd_gensymtypes_S =                                                         \
    (echo "\#include <linux/kernel.h>" ;                                    \
     echo "\#include <asm/asm-prototypes.h>" ;                              \
    $(CPP) $(a_flags) $< |                                                  \
     grep "\<___EXPORT_SYMBOL\>" |                                          \
     sed 's/.*___EXPORT_SYMBOL[[:space:]]*\([a-zA-Z0-9_]*\)[[:space:]]*,.*/EXPORT_SYMBOL(\1);/' ) | \
    $(CPP) -D__GENKSYMS__ $(c_flags) -xc - |                                \
    $(GENKSYMS) $(if $(1), -T $(2))                                         \
     $(patsubst y,-s _,$(CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX))             \
     $(if $(KBUILD_PRESERVE),-p)                                            \
     -r $(firstword $(wildcard $(2:.symtypes=.symref) /dev/null))

quiet_cmd_cc_symtypes_S = SYM $(quiet_modtag) $@
cmd_cc_symtypes_S =                                                         \
    set -e;                                                                 \
    $(call cmd_gensymtypes_S,true,$@) >/dev/null;                           \
    test -s $@ || rm -f $@

$(obj)/%.symtypes : $(src)/%.S FORCE
	$(call cmd,cc_symtypes_S)


quiet_cmd_cpp_s_S = CPP $(quiet_modtag) $@
cmd_cpp_s_S       = $(CPP) $(a_flags) -o $@ $<

$(obj)/%.s: $(src)/%.S FORCE
	$(call if_changed_dep,cpp_s_S)

quiet_cmd_as_o_S = AS $(quiet_modtag)  $@

ifndef CONFIG_MODVERSIONS
cmd_as_o_S = $(CC) $(a_flags) -c -o $@ $<

else

ASM_PROTOTYPES := $(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/asm-prototypes.h)

ifeq ($(ASM_PROTOTYPES),)
cmd_as_o_S = $(CC) $(a_flags) -c -o $@ $<

else

# versioning matches the C process described above, with difference that
# we parse asm-prototypes.h C header to get function definitions.

cmd_as_o_S = $(CC) $(a_flags) -c -o $(@D)/.tmp_$(@F) $<

cmd_modversions_S =								\
	if $(OBJDUMP) -h $(@D)/.tmp_$(@F) | grep -q __ksymtab; then		\
		$(call cmd_gensymtypes_S,$(KBUILD_SYMTYPES),$(@:.o=.symtypes))	\
		    > $(@D)/.tmp_$(@F:.o=.ver);					\
										\
		$(LD) $(LDFLAGS) -r -o $@ $(@D)/.tmp_$(@F) 			\
			-T $(@D)/.tmp_$(@F:.o=.ver);				\
		rm -f $(@D)/.tmp_$(@F) $(@D)/.tmp_$(@F:.o=.ver);		\
	else									\
		mv -f $(@D)/.tmp_$(@F) $@;					\
	fi;
endif
endif

$(obj)/%.o: $(src)/%.S $(objtool_obj) FORCE
	$(call if_changed_rule,as_o_S)

targets += $(real-objs-y) $(real-objs-m) $(lib-y)
targets += $(extra-y) $(MAKECMDGOALS) $(always)

# Linker scripts preprocessor (.lds.S -> .lds)
# ---------------------------------------------------------------------------
quiet_cmd_cpp_lds_S = LDS     $@
      cmd_cpp_lds_S = $(CPP) $(cpp_flags) -P -C -U$(ARCH) \
	                     -D__ASSEMBLY__ -DLINKER_SCRIPT -o $@ $<

$(obj)/%.lds: $(src)/%.lds.S FORCE
	$(call if_changed_dep,cpp_lds_S)

# ASN.1 grammar
# ---------------------------------------------------------------------------
quiet_cmd_asn1_compiler = ASN.1   $@
      cmd_asn1_compiler = $(objtree)/scripts/asn1_compiler $< \
				$(subst .h,.c,$@) $(subst .c,.h,$@)

.PRECIOUS: $(objtree)/$(obj)/%-asn1.c $(objtree)/$(obj)/%-asn1.h

$(obj)/%-asn1.c $(obj)/%-asn1.h: $(src)/%.asn1 $(objtree)/scripts/asn1_compiler
	$(call cmd,asn1_compiler)

# Build the compiled-in targets
# ---------------------------------------------------------------------------

# To build objects in subdirs, we need to descend into the directories
$(sort $(subdir-obj-y)): $(subdir-ym) ;

#
# Rule to compile a set of .o files into one .o file
#
ifdef builtin-target

ifdef CONFIG_LTO_CLANG
  ifdef CONFIG_MODVERSIONS
    # combine symversions for later processing
    update_lto_symversions =				\
	rm -f $@.symversions; 				\
	for i in $(filter-out FORCE,$^); do		\
		if [ -f $$i.symversions ]; then		\
			cat $$i.symversions 		\
				>> $@.symversions;	\
		fi;					\
	done;
  endif
  # rebuild the symbol table with llvm-ar to include IR files
  update_lto_symtable = ;				\
	mv -f $@ $@.tmp;				\
	$(LLVM_AR) rcsT$(KBUILD_ARFLAGS) $@ 		\
		$$($(AR) t $@.tmp); 			\
	rm -f $@.tmp
endif

ifdef CONFIG_THIN_ARCHIVES
  cmd_make_builtin = $(update_lto_symversions)	\
	rm -f $@; $(AR) rcSTP$(KBUILD_ARFLAGS)
  cmd_make_empty_builtin = rm -f $@; $(AR) rcSTP$(KBUILD_ARFLAGS)
  quiet_cmd_link_o_target = AR      $@
else
  cmd_make_builtin = $(LD) $(ld_flags) -r -o
  cmd_make_empty_builtin = rm -f $@; $(AR) rcs$(KBUILD_ARFLAGS)
  quiet_cmd_link_o_target = LD      $@
endif

# If the list of objects to link is empty, just create an empty built-in.o
cmd_link_o_target = $(if $(strip $(obj-y)),\
		      $(cmd_make_builtin) $@ $(filter $(obj-y), $^) \
		      $(cmd_secanalysis),\
		      $(cmd_make_empty_builtin) $@)

$(builtin-target): $(obj-y) FORCE
	$(call if_changed,link_o_target)

targets += $(builtin-target)

$(info ------ CONFIG_LTO_CLANG=$(CONFIG_LTO_CLANG))
$(info ------ CONFIG_MODVERSIONS=$(CONFIG_MODVERSIONS))
$(info ------ CONFIG_THIN_ARCHIVES=$(CONFIG_THIN_ARCHIVES))
$(info ------ obj-y=$(obj-y))
endif # builtin-target

#
# Rule to create modules.order file
#
# Create commands to either record .ko file or cat modules.order from
# a subdirectory
modorder-cmds =						\
	$(foreach m, $(modorder),			\
		$(if $(filter %/modules.order, $m),	\
			cat $m;, echo kernel/$m;))

$(modorder-target): $(subdir-ym) FORCE
	$(Q)(cat /dev/null; $(modorder-cmds)) > $@

#
# Rule to compile a set of .o files into one .a file
#
ifdef lib-target
quiet_cmd_link_l_target = AR      $@

ifdef CONFIG_THIN_ARCHIVES
  cmd_link_l_target = 					\
	$(update_lto_symversions)			\
	rm -f $@; 					\
	$(AR) rcsTP$(KBUILD_ARFLAGS) $@ $(lib-y)	\
	$(update_lto_symtable)
else
  cmd_link_l_target = rm -f $@; $(AR) rcs$(KBUILD_ARFLAGS) $@ $(lib-y)
endif

$(lib-target): $(lib-y) FORCE
	$(call if_changed,link_l_target)

targets += $(lib-target)

dummy-object = $(obj)/.lib_exports.o
ksyms-lds = $(dot-target).lds
ifdef CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX
ref_prefix = EXTERN(_
else
ref_prefix = EXTERN(
endif

filter_export_list = sed -ne '/___ksymtab/s/.*+\([^ "]*\).*/$(ref_prefix)\1)/p'
link_export_list = rm -f $(dummy-object);\
	echo | $(CC) $(a_flags) -c -o $(dummy-object) -x assembler -;\
	$(LD) $(ld_flags) -r -o $@ -T $(ksyms-lds) $(dummy-object);\
	rm $(dummy-object) $(ksyms-lds)

quiet_cmd_export_list = EXPORTS $@

ifdef CONFIG_LTO_CLANG
# objdump doesn't understand IR files and llvm-dis doesn't support archives,
# so we'll walk through each file in the archive separately
cmd_export_list = 					\
	rm -f $(ksyms-lds);				\
	for o in $$($(AR) t $<); do			\
		if $(OBJDUMP) -h $$o >/dev/null 2>/dev/null; then \
			$(OBJDUMP) -h $$o | 		\
				$(filter_export_list) 	\
				>>$(ksyms-lds);		\
		else					\
			$(LLVM_DIS) -o=- $$o |		\
				$(filter_export_list) 	\
				>>$(ksyms-lds);		\
		fi; 					\
	done;						\
	$(link_export_list)
else
cmd_export_list = $(OBJDUMP) -h $< | $(filter_export_list) >$(ksyms-lds); \
	$(link_export_list)
endif

$(obj)/lib-ksyms.o: $(lib-target) FORCE
	$(call if_changed,export_list)

targets += $(obj)/lib-ksyms.o

endif

#
# Rule to link composite objects
#
#  Composite objects are specified in kbuild makefile as follows:
#    <composite-object>-objs := <list of .o files>
#  or
#    <composite-object>-y    := <list of .o files>
#  or
#    <composite-object>-m    := <list of .o files>
#  The -m syntax only works if <composite object> is a module
link_multi_deps =                     \
$(filter $(addprefix $(obj)/,         \
$($(subst $(obj)/,,$(@:.o=-objs)))    \
$($(subst $(obj)/,,$(@:.o=-y)))       \
$($(subst $(obj)/,,$(@:.o=-m)))), $^)

cmd_link_multi-link = $(LD) $(ld_flags) -r -o $@ $(link_multi_deps) $(cmd_secanalysis)

ifdef CONFIG_THIN_ARCHIVES
  quiet_cmd_link_multi-y = AR      $@
  cmd_link_multi-y = $(update_lto_symversions) \
	rm -f $@; $(AR) rcSTP$(KBUILD_ARFLAGS) $@ $(link_multi_deps) \
	$(update_lto_symtable)
else
  quiet_cmd_link_multi-y = LD      $@
  cmd_link_multi-y = $(cmd_link_multi-link)
endif

quiet_cmd_link_multi-m = LD [M]  $@

ifdef CONFIG_LTO_CLANG
  # don't compile IR until needed
  cmd_link_multi-m = $(cmd_link_multi-y)
else
  cmd_link_multi-m = $(cmd_link_multi-link)
endif

$(multi-used-y): FORCE
	$(call if_changed,link_multi-y)

$(multi-used-m): FORCE
	$(call if_changed,link_multi-m)
	@{ echo $(@:.o=.ko); echo $(link_multi_deps); \
	   $(cmd_undef_syms); } > $(MODVERDIR)/$(@F:.o=.mod)

$(call multi_depend, $(multi-used-y), .o, -objs -y)
$(call multi_depend, $(multi-used-m), .o, -objs -y -m)

targets += $(multi-used-y) $(multi-used-m)


# Descending
# ---------------------------------------------------------------------------

PHONY += $(subdir-ym)
$(subdir-ym):
	$(Q)$(MAKE) $(build)=$@

# Add FORCE to the prequisites of a target to force it to be always rebuilt.
# ---------------------------------------------------------------------------

PHONY += FORCE

FORCE:

# Read all saved command lines and dependencies for the $(targets) we
# may be building above, using $(if_changed{,_dep}). As an
# optimization, we don't need to read them if the target does not
# exist, we will rebuild anyway in that case.

targets := $(wildcard $(sort $(targets)))
cmd_files := $(wildcard $(foreach f,$(targets),$(dir $(f)).$(notdir $(f)).cmd))

ifneq ($(cmd_files),)
  include $(cmd_files)
endif

# Declare the contents of the .PHONY variable as phony.  We keep that
# information in a variable se we can use it in if_changed and friends.

.PHONY: $(PHONY)
$(info )
