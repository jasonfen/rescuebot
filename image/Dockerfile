# Build environment for the Rescuebot Live ISO.
# live-build needs a Debian host; this gives the same one locally and in CI.
# The builder itself is pinned to the same snapshot date as the image
# (see build/SNAPSHOT) so the tools that assemble the ISO are reproducible too.
FROM debian:trixie

ARG SNAPSHOT=20261021T000000Z

RUN rm -f /etc/apt/sources.list.d/debian.sources \
 && printf 'deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/%s trixie main\ndeb [check-valid-until=no] http://snapshot.debian.org/archive/debian/%s trixie-updates main\ndeb [check-valid-until=no] http://snapshot.debian.org/archive/debian-security/%s trixie-security main\n' "$SNAPSHOT" "$SNAPSHOT" "$SNAPSHOT" > /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      live-build debootstrap squashfs-tools xorriso mtools dosfstools \
      grub-pc-bin grub-efi-amd64-bin grub-common isolinux syslinux syslinux-common \
      shim-signed grub-efi-amd64-signed \
      ca-certificates curl gnupg zstd cpio rsync \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /build
