ifeq ($(KERNEL_OVERLAYS),)
KERNEL_OVERLAYS :=
KERNEL_OVERLAYS += $(CURDIR)/../nvidia
KERNEL_OVERLAYS += $(CURDIR)/../nvgpu
KERNEL_OVERLAYS += $(CURDIR)/../nvgpu-next
KERNEL_OVERLAYS += $(CURDIR)/../nvidia-t23x
else
override KERNEL_OVERLAYS := $(subst :, ,$(KERNEL_OVERLAYS))
endif
override KERNEL_OVERLAYS := $(abspath $(KERNEL_OVERLAYS))
export KERNEL_OVERLAYS

define set_srctree_overlay
  overlay_name := $(lastword $(subst /, ,$(overlay)))
  srctree.$(overlay_name) := $(overlay)
  export srctree.$(overlay_name)
endef
$(foreach overlay,$(KERNEL_OVERLAYS),$(eval $(value set_srctree_overlay)))
