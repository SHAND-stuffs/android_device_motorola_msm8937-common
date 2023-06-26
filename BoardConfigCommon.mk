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
TARGET_KERNEL_CONFIG := \
    vendor/msm8937-perf_defconfig
ifeq ($(TARGET_KERNEL_VERSION),4.19)
TARGET_KERNEL_CONFIG += \
    vendor/msm8937-legacy.config
endif
TARGET_KERNEL_CONFIG += \
    vendor/common.config \
    vendor/feature/android-12.config \
    vendor/feature/exfat.config \
    vendor/feature/kprobes.config \
    vendor/feature/lmkd.config \
    vendor/feature/uclamp.config \
    vendor/motorola/msm8937/common.config

ifeq ($(TARGET_KERNEL_VERSION),4.19)
TARGET_KERNEL_CONFIG += \
    vendor/feature/wireguard.config
TARGET_KERNEL_SOURCE := kernel/motorola/msm8937-4.19
else
TARGET_KERNEL_SOURCE := kernel/motorola/msm8937
endif

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432 # virtual
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456 # not the partition we uses for cache
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864 # virtual
BOARD_USES_METADATA_PARTITION := true

# SELinux
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_COMMON_PATH)/sepolicy/vendor

# Inherit from the proprietary version
#ifeq ($(TARGET_KERNEL_VERSION),4.19)
#include vendor/motorola/msm8937-common-4.19/BoardConfigVendor.mk
#else
include vendor/motorola/msm8937-common/BoardConfigVendor.mk
#endif
