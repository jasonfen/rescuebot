# Rescuebot image build

live-build config for the Rescuebot Live ISO: Debian 13 (trixie), amd64, hybrid
ISO booting UEFI (Secure Boot, Debian-signed shim/grub/kernel) and legacy BIOS.

    image/build.sh [outdir]      # needs Docker; builds in a privileged container

Output in `outdir` (default `./out`): the ISO, its `.sha256`, the package
manifest, the source-package list (see `docs/gpl-source.md`) and the build log.
On Apple silicon, Docker runs the amd64 builder under emulation (slow, about 35
minutes, but it works). CI runs the same script on a native amd64 runner.

| Path | What |
|---|---|
| `SNAPSHOT` | snapshot.debian.org timestamp every package is built from |
| `auto/config` | `lb config` options, mirrors, Secure Boot setting |
| `config/package-lists/` | package lists (base, Claude Code prerequisites, recovery, network, desktop) |
| `config/archives/` | trixie-backports source and the pin that sends kernel and firmware there |
| `config/bootloaders/` | boot menus: desktop (default), console only, safe graphics |
| `config/hooks/live/` | sshd off at boot; build-time assertions (no Claude Code, no DKMS, backports kernel) |

Rules this tree enforces (see the planning ADRs 0003, 0004, 0008): no Claude Code
in the image, no locally built or DKMS modules, kernel and firmware from
trixie-backports. The package mapping from SystemRescue is in `docs/package-map.md`.
