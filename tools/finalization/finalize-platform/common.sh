#!/bin/bash
#
# Copyright (C) 2026 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Calculate the top of the android source tree
top="${ANDROID_BUILD_TOP:-$(dirname "${BASH_SOURCE[0]}")/../../../../..}"

# Add the host bin directory to the PATH so that tools can be found by CI
export PATH="$top/${OUT_DIR:-out}/host/linux-x86/bin:$PATH"

# Change directory relative to the top of the Android tree
function croot() {
    \cd "$top/$1"
}

# Define the m function to run the build.
# This function uses the TARGET_PRODUCT, TARGET_RELEASE, and TARGET_BUILD_VARIANT environment variables if they are set.
# Otherwise, it uses default values (sdk, sdk_finalization, and userdebug respectively).
function m() {
    "$top/build/soong/soong_ui.bash" --make-mode \
        "TARGET_PRODUCT=${TARGET_PRODUCT:-sdk}" \
        "TARGET_RELEASE=${TARGET_RELEASE:-sdk_finalization}" \
        "TARGET_BUILD_VARIANT=${TARGET_BUILD_VARIANT:-userdebug}" \
        "$@"
}

# Print a debug message
function info() {
    local timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
    if [[ -t 1 ]]; then
        echo -e "\e[90m${timestamp} \e[33mINFO\e[0m $1"
    else
        echo -e "${timestamp} INFO $1"
    fi
}

# Print an error message
function error() {
    local timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
    if [[ -t 1 ]]; then
        echo -e "\e[90m${timestamp} \e[31mERROR\e[0m $1"
    else
        echo -e "${timestamp} ERROR $1"
    fi
}

# vi: expandtab sw=4 ts=4
