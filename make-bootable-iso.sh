#! /bin/bash

set -eu

SELF_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function usage() {
  echo "usage: make-bootable-iso.sh <options>"                   1>&2
  echo "options:"                                                1>&2
  echo "  --os <name>  Required. The name of macOS to install."  1>&2
  echo "               On of: catalina, bigsur, monterey."       1>&2
  exit 20
}

function make_bootable_iso() {
  local INSTALLER_PATH="/Applications/${INSTALLER_NAME}.app"

  if [[ ! -d "${INSTALLER_PATH}" ]]; then
    echo "*** Downloading installer app ..."
    softwareupdate --download --fetch-full-installer --full-installer-version "${OS_VERSION}"
  fi

  local TEMP_DIR="${SELF_DIR}/.temp"
  local IMAGES_DIR="${SELF_DIR}/images"
  mkdir -p "${TEMP_DIR}" "${IMAGES_DIR}"

  rm -f "${TEMP_DIR}"/*

  local OS_PATH="${TEMP_DIR}/${OS_NAME}"
  local DMG_PATH="${OS_PATH}.dmg"
  local CDR_PATH="${OS_PATH}.cdr"
  local CHECKSUM_NAME="${ISO_NAME}.sha256"
  local MOUNT_PATH="/Volumes/${OS_NAME}"

  echo "*** Creating ISO image ..."
  hdiutil create -o "${OS_PATH}" -size "${DISK_SIZE}" -volname "${OS_NAME}" -layout SPUD -fs HFS+J

  echo "*** Attaching ISO image ..."
  hdiutil attach "${DMG_PATH}" -noverify -nobrowse -mountpoint "${MOUNT_PATH}"

  echo "*** Creating installation media ..."
  sudo "${INSTALLER_PATH}/Contents/Resources/createinstallmedia" --nointeraction --downloadassets --volume "${MOUNT_PATH}"

  echo "*** Detaching installation volume ..."
  for ((i = 0; i < ${#EXTRA_VOLUMES[@]}; i++))
  do
    hdiutil detach "${EXTRA_VOLUMES[$i]}"
  done

  hdiutil detach "/Volumes/${INSTALLER_NAME}"

  echo "***  Converting ISO image ..."
  hdiutil convert "${DMG_PATH}" -format UDTO -o "${CDR_PATH}"

  echo "***  Computing checksum ..."
  pushd "${IMAGES_DIR}" >/dev/null
  rm -f "${ISO_NAME}" "${CHECKSUM_NAME}"
  mv "${CDR_PATH}" "${ISO_NAME}"
  sha256sum "${ISO_NAME}" >"${CHECKSUM_NAME}"
  chmod 644 "${ISO_NAME}" "${CHECKSUM_NAME}"
  sudo chown root:wheel "${ISO_NAME}" "${CHECKSUM_NAME}"
  popd >/dev/null

  rm -f "${TEMP_DIR}"/*
}

OS=''

while [[ $# -gt 0 ]]
do
  case "$1" in
    --os)
    OS="$2"
    shift
    shift
    ;;

    *)
    usage
  esac
done

if [[ -z "${OS}" ]]; then
  usage
fi

case "${OS}" in
  catalina)
  OS_NAME=Catalina
  OS_VERSION="10.15.7"
  INSTALLER_NAME="Install macOS Catalina"
  ISO_NAME="install-macos-10.15-catalina.iso"
  DISK_SIZE=12g
  EXTRA_VOLUMES=()
  ;;

  bigsur)
  OS_NAME=BigSur
  OS_VERSION="11.6.7"
  INSTALLER_NAME="Install macOS Big Sur"
  ISO_NAME="install-macos-11-big-sur.iso"
  DISK_SIZE=16g
  EXTRA_VOLUMES=("/Volumes/Shared Support 1" "/Volumes/Shared Support")
  ;;

  monterey)
  OS_NAME=Monterey
  OS_VERSION="12.4"
  INSTALLER_NAME="Install macOS Monterey"
  ISO_NAME="install-macos-12-monterey.iso"
  DISK_SIZE=16g
  EXTRA_VOLUMES=()
  ;;

  *)
  echo "Unsupported OS '${OS}'." 1>&2
  exit 21
esac

make_bootable_iso
