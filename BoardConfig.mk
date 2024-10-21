#
# Copyright (C) 2021-2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Include the common OEM chipset BoardConfig.
include device/oneplus/sm8550-common/BoardConfigCommon.mk

DEVICE_PATH := device/oneplus/aston

# Assert
TARGET_OTA_ASSERT_DEVICE := OP5CF9L1,CPH2585,CPH2611,aston

# Display
TARGET_SCREEN_DENSITY := 450

# Kernel
TARGET_KERNEL_CONFIG += vendor/oplus/aston.config

# Kernel
ifeq ($(TARGET_BUILD_PERMISSIVE),true)
BOARD_BOOTCONFIG := \
    androidboot.selinux=permissive
endif

TARGET_KERNEL_PREBUILTS_PATH := $(DEVICE_PATH)/aston-kernel
ifeq ($(TARGET_USE_PREBUILT_KERNEL),true)
  TARGET_FORCE_PREBUILT_KERNEL := true
  TARGET_PREBUILT_KERNEL := $(TARGET_KERNEL_PREBUILTS_PATH)/kernel
  TARGET_PREBUILT_DTB := $(TARGET_KERNEL_PREBUILTS_PATH)/dtb/dtb.img
  BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
  BOARD_INCLUDE_DTB_IN_BOOTIMG :=
  BOARD_PREBUILT_DTBOIMAGE := $(TARGET_KERNEL_PREBUILTS_PATH)/dtb/dtbo.img
  BOARD_KERNEL_SEPARATED_DTBO :=
endif

ifeq ($(TARGET_USE_PREBUILT_KERNEL_MODULES),true)
  TARGET_KERNEL_EXT_MODULES :=
  TARGET_KERNEL_EXT_MODULES_ROOT :=

  BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(strip $(shell cat $(TARGET_KERNEL_PREBUILTS_PATH)/vendor_ramdisk/modules.load))
  BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE := $(TARGET_KERNEL_PREBUILTS_PATH)/vendor_ramdisk/modules.blocklist
  BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(TARGET_KERNEL_PREBUILTS_PATH)/vendor_ramdisk/modules.load.recovery))
  BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(TARGET_KERNEL_PREBUILTS_PATH)/vendor_dlkm/modules.load))
  BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE :=  $(TARGET_KERNEL_PREBUILTS_PATH)/vendor_dlkm/modules.blocklist
  PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(TARGET_KERNEL_PREBUILTS_PATH)/vendor_dlkm/,$(TARGET_COPY_OUT_VENDOR_DLKM)/lib/modules) \
    $(call find-copy-subdir-files,*,$(TARGET_KERNEL_PREBUILTS_PATH)/vendor_ramdisk/,$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules) \
    $(call find-copy-subdir-files,*,$(TARGET_KERNEL_PREBUILTS_PATH)/system_dlkm/,$(TARGET_COPY_OUT_SYSTEM_DLKM)/lib/modules/android15-5.15)
else
  # Kernel modules
  BOARD_SYSTEM_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)/modules.load.system_dlkm))
  BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE := $(DEVICE_PATH)/modules.blocklist
  BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)/modules.load))
  BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE := $(BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE)
  BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)/modules.load.vendor_boot))
  BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)/modules.load.recovery))
  BOOT_KERNEL_MODULES := $(strip $(shell cat $(DEVICE_PATH)/modules.load.recovery $(DEVICE_PATH)/modules.include.vendor_ramdisk))
  SYSTEM_KERNEL_MODULES := $(strip $(shell cat $(DEVICE_PATH)/modules.include.system_dlkm))
endif

# Power
TARGET_POWER_LIBPERFMGR_MODE_EXTENSION_LIB := //$(DEVICE_PATH)/power:libperfmgr-ext-aston

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Recovery
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 103

# Touch
TARGET_USES_OPLUS_TOUCH := true

# Vibrator
SOONG_CONFIG_NAMESPACES += OPLUS_LINEAGE_VIBRATOR_HAL
SOONG_CONFIG_OPLUS_LINEAGE_VIBRATOR_HAL := \
    USE_EFFECT_STREAM
SOONG_CONFIG_OPLUS_LINEAGE_VIBRATOR_HAL_USE_EFFECT_STREAM := true

# Include the proprietary files BoardConfig.
include vendor/oneplus/aston/BoardConfigVendor.mk
