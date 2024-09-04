#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        odm/etc/camera/CameraHWConfiguration.config)
            [ "$2" = "" ] && return 0
            sed -i "s/SystemCamera =  0;  0;  0;  1;  0;  1;/SystemCamera =  0;  0;  0;  0;  1;  1;/g" "${2}"
            ;;
        odm/lib64/libAlgoProcess.so)
            [ "$2" = "" ] && return 0
            sed -i "s/android.hardware.graphics.common-V3-ndk.so/android.hardware.graphics.common-V5-ndk.so/" "${2}"
            ;;
        odm/lib64/libCOppLceTonemapAPI.so|odm/lib64/libCS.so|odm/lib64/libSuperRaw.so|odm/lib64/libYTCommon.so|odm/lib64/libyuv2.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF_0_17_2}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
            ;;
        *)
            return 1
            ;;
    esac

    return 0
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

"./../../${VENDOR_COMMON}/${DEVICE_COMMON}/extract-files.sh" "$@"
