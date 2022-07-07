#! /bin/bash

set -eu

SELF_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

OS_NAME="Monterey"
OS_VERSION="12.4"
INSTALLER_NAME="Install macOS Monterey"
ISO_NAME="install-macos-12-monterey.iso"
DISK_SIZE=16g
EXTRA_VOLUMES=()

source "${SELF_DIR}/common.inc.sh"

make_bootable_iso
