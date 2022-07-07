#! /bin/bash

set -eu

SELF_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

OS_NAME="Catalina"
OS_VERSION="10.15.6"
INSTALLER_NAME="Install macOS Catalina"
ISO_NAME="install-macos-10.15-catalina.iso"
DISK_SIZE=12g
EXTRA_VOLUMES=()

source "${SELF_DIR}/common.inc.sh"

make_bootable_iso
