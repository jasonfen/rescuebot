#!/bin/bash
# Runs inside the builder container. Copies the config to local disk, builds,
# and copies the ISO and release metadata to /out.
set -euo pipefail

rm -rf /build/work && mkdir -p /build/work
cp -a /src/auto /src/config /src/SNAPSHOT /build/work/
cd /build/work

# Build record shipped inside the image (used later by the upgrade tool and
# for the GPL source pointer).
mkdir -p config/includes.chroot/etc
cat > config/includes.chroot/etc/rescuebot-release <<REL
RESCUEBOT_SNAPSHOT=${SNAPSHOT}
RESCUEBOT_GIT_REV=${GITREV}
RESCUEBOT_DEBIAN_SUITE=trixie
RESCUEBOT_SNAPSHOT_URL=http://snapshot.debian.org/archive/debian/${SNAPSHOT}/
RESCUEBOT_SECURITY_SNAPSHOT_URL=http://snapshot.debian.org/archive/debian-security/${SNAPSHOT}/
REL

# Reproducible timestamps: tie to the snapshot date.
export SOURCE_DATE_EPOCH="$(date -u -d "${SNAPSHOT:0:4}-${SNAPSHOT:4:2}-${SNAPSHOT:6:2}" +%s)"

lb config
lb build 2>&1 | tee /build/work/build.log

iso="$(ls /build/work/*.iso | head -n1)"
name="rescuebot-${SNAPSHOT}-amd64.iso"
cp "$iso" "/out/$name"
cp /build/work/live-image-amd64.contents /out/rescuebot-${SNAPSHOT}-amd64.contents 2>/dev/null || true
cp /build/work/live-image-amd64.packages /out/rescuebot-${SNAPSHOT}-amd64.packages 2>/dev/null || true
cp /build/work/build.log "/out/rescuebot-${SNAPSHOT}-build.log"

# Source package list for the GPL source pointer: every binary package in the
# image mapped to its source package and version. Matching source is fetchable
# from the same snapshot (see docs/gpl-source.md).
chroot /build/work/chroot dpkg-query -W -f '${source:Package} ${source:Version}\n' | sort -u \
	> "/out/rescuebot-${SNAPSHOT}-sources.txt"

(cd /out && sha256sum "$name" > "${name}.sha256")
ls -l /out
