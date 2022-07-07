function make_bootable_iso() {
  local INSTALLER_PATH="/Applications/${INSTALLER_NAME}.app"

  if [[ ! -d "${INSTALLER_PATH}" ]]; then
    echo "Cannot find the installer app at '${INSTALLER_PATH}'." 1>&2
    echo "Consult the README to download it, then try again." 1>&2
    exit 10
  fi

  local BASE_DIR="${SELF_DIR}/.."
  local TEMP_DIR="${BASE_DIR}/.temp"
  local IMAGES_DIR="${BASE_DIR}/images"
  mkdir -p "${TEMP_DIR}" "${IMAGES_DIR}"

  rm -f "${TEMP_DIR}"/*

  local OS_PATH="${TEMP_DIR}/${OS_NAME}"
  local DMG_PATH="${OS_PATH}.dmg"
  local CDR_PATH="${OS_PATH}.cdr"
  local ISO_PATH="${IMAGES_DIR}/${ISO_NAME}"
  local MOUNT_PATH="/Volumes/${OS_NAME}"

  echo "Creating ISO image ..."
  hdiutil create -o "${OS_PATH}" -size "${DISK_SIZE}" -volname "${OS_NAME}" -layout SPUD -fs HFS+J

  echo "Attaching ISO image ..."
  hdiutil attach "${DMG_PATH}" -noverify -nobrowse -mountpoint "${MOUNT_PATH}"

  echo "Creating installation media ..."
  sudo "${INSTALLER_PATH}/Contents/Resources/createinstallmedia" --nointeraction --volume "${MOUNT_PATH}"

  echo "Detaching installation volume ..."
  for ((i = 0; i < ${#EXTRA_VOLUMES[@]}; i++))
  do
    hdiutil detach "${EXTRA_VOLUMES[$i]}"
  done

  hdiutil detach "/Volumes/${INSTALLER_NAME}"

  echo "Converting ISO image ..."
  hdiutil convert "${DMG_PATH}" -format UDTO -o "${CDR_PATH}"

  mv "${CDR_PATH}" "${ISO_PATH}"
  sha256 "${ISO_PATH}" >"${ISO_PATH}.sha256"

  rm -f "${TEMP_DIR}"/*
}
