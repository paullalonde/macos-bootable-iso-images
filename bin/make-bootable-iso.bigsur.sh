#! /bin/bash

set -eu

SELF_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

OS_NAME="BigSur"
INSTALLER_NAME="Install macOS Big Sur"
ISO_NAME="install-macos-11-big-sur.iso"
DISK_SIZE=16g
EXTRA_VOLUMES=("/Volumes/Shared Support 1" "/Volumes/Shared Support")

source "${SELF_DIR}/common.inc.sh"

make_bootable_iso
