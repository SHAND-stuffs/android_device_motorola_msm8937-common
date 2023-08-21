#
# Copyright (C) 2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Partitions
SSI_PARTITIONS := product system system_ext
TREBLE_PARTITIONS := odm vendor
ALL_PARTITIONS := $(SSI_PARTITIONS) $(TREBLE_PARTITIONS)

$(foreach p, $(call to-upper, $(ALL_PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := ext4) \
    $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))

# Inherit from common mithorium-common
include device/xiaomi/mithorium-common/BoardConfigCommon.mk

DEVICE_COMMON_PATH := device/motorola/msm8937-common
USES_DEVICE_MOTOROLA_MSM8937_COMMON := true

# Display
TARGET_SCREEN_DENSITY ?= 280

# Kernel
BOARD_KERNEL_CMDLINE += androidboot.boot_devices=soc/7824900.sdhci androidboot.selinux=permissive
BOARD_RAMDISK_USE_XZ := true
TARGET_KERNEL_SOURCE := kernel/motorola/msm8937
TARGET_KERNEL_VERSION := 4.19

TARGET_KERNEL_CONFIG := \
    vendor/$(TARGET_BOARD_PLATFORM)-perf_defconfig \
    vendor/msm8937-legacy.config \
    vendor/common.config \
    vendor/feature/android-12.config \
    vendor/feature/lmkd.config \
    vendor/feature/no-camera-stack.config \
    vendor/motorola/msm8937/common.config

TARGET_KERNEL_RECOVERY_CONFIG := \
    vendor/$(TARGET_BOARD_PLATFORM)-perf_defconfig \
    vendor/msm8937-legacy.config \
    vendor/common.config \
    vendor/feature/no-camera-stack.config \
    vendor/feature/no-wlan-driver.config \
    vendor/motorola/msm8937/common.config

ifeq ($(TARGET_DISABLE_AUDIO),true)
TARGET_KERNEL_CONFIG += vendor/feature/no-audio-stack.config
TARGET_KERNEL_RECOVERY_CONFIG += vendor/feature/no-audio-stack.config
endif

BOARD_KERNEL_SEPARATED_DT ?= true
ifeq ($(BOARD_KERNEL_SEPARATED_DT),true)
BOARD_KERNEL_IMAGE_NAME := Image.gz
endif

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 25165824
BOARD_USES_METADATA_PARTITION := true

# SELinux
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_COMMON_PATH)/sepolicy/vendor
ifeq ($(call math_gt_or_eq,$(PLATFORM_SDK_VERSION),31),true)
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_COMMON_PATH)/sepolicy/vendor-a12
else
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_COMMON_PATH)/sepolicy/vendor-a11
endif

# Inherit from the proprietary version
include vendor/motorola/msm8937-common/BoardConfigVendor.mk
