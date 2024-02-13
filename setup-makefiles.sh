#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

function lib_to_package_fixup_odm_variants() {
    if [ "$2" != "odm" ]; then
        return 1
    fi

    case "$1" in
        vendor.oplus.hardware.touch-V2-ndk)
        echo "$1_odm"
        ;;
        *)
            return 1
            ;;
    esac
}

function lib_to_package_fixup_vendor_variants() {
    if [ "$2" != "vendor" ]; then
        return 1
    fi

    case "$1" in
        libhwconfigurationutil|vendor.oplus.hardware.cammidasservice-V1-ndk|vendor.oplus.hardware.sendextcamcmd-V1-ndk)
        echo "$1_vendor"
        ;;
        *)
        return 1
        ;;
    esac
}

function lib_to_package_fixup() {
    lib_to_package_fixup_vendor_variants "$@" ||
    lib_to_package_fixup_odm_variants "$@" ||
        lib_to_package_fixup_proto_3_9_1 "$1"
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=aston
export DEVICE_COMMON=sm8550-common
export VENDOR=oneplus
export VENDOR_COMMON=${VENDOR}

"./../../${VENDOR_COMMON}/${DEVICE_COMMON}/setup-makefiles.sh" "$@"
