#!/bin/sh

# Path to molecules.git dir
ROGENTOS_MOLECULE_HOME="${ROGENTOS_MOLECULE_HOME:-/sabayon}"
export ROGENTOS_MOLECULE_HOME

PKGS_DIR="${ROGENTOS_MOLECULE_HOME}/pkgcache"
CHROOT_PKGS_DIR="${CHROOT_DIR}/var/lib/entropy/client/packages"

[[ ! -d "${PKGS_DIR}" ]] && mkdir -p "${PKGS_DIR}"
[[ ! -d "${CHROOT_PKGS_DIR}" ]] && mkdir -p "${CHROOT_PKGS_DIR}"

# make sure it's all clean before mounting
rm -rf "${CHROOT_PKGS_DIR}"/*
echo "Mounting bind to ${CHROOT_PKGS_DIR}"
mount --bind "${PKGS_DIR}" "${CHROOT_PKGS_DIR}" || exit 1

content=$(ls -1 "${CHROOT_DIR}/proc" | wc -l)
if [ "${content}" -le 3 ]; then
	echo "Mounting /proc ..."
	mount -t proc proc "${CHROOT_DIR}/proc"
fi

exit 0
