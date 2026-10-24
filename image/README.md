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
| `config/hooks/live/` | sshd off at boot; RAID/LVM auto-assembly off; build-time assertions (no Claude Code, no DKMS, backports kernel, initrd carries cryptsetup and the read-only rule) |
| `config/includes.chroot/` | `rescuebot-ssh-enable`, `rescuebot-stick` (Stick Setup), `rescuebot-grant` (Write Grants), read-only udev rule, live-config and autostart pieces |

SSH: sshd is installed but off, the live user's password is locked, and the image
carries no SSH host keys. `sudo rescuebot-ssh-enable` (run by the person) sets a password,
generates host keys for that boot and starts sshd. Local autologin and passwordless sudo are unchanged.

Rescue Stick: write the ISO to a USB stick with any tool and boot it. Rescuebot offers
Stick Setup (`sudo rescuebot-stick setup`, also in Applications > System), which adds an
encrypted Saved State as partition 3 from 8 GiB to the end of the stick and shows a
Recovery Key once. At each boot live-boot asks for the passphrase (US layout); Enter then
`n` skips it for a Stateless Boot. `rescuebot-stick status | passphrase | recovery-key`
manage it. Only LUKS volumes labelled `persistence` are ever opened at boot, and no other
partition is mounted while looking. Writing a new ISO to the stick destroys the Saved State.

Disk safety: every disk except the Rescue Stick is read-only at the block layer from the
initramfs on, including disks plugged in later (`/etc/udev/rules.d/62-rescuebot-readonly.rules`),
so nothing at boot can write to a Patient Disk, not even a read-only mount replaying a
journal. RAID and LVM are never assembled or activated automatically. A person makes one disk
writable with `sudo rescuebot-grant DISK` (needs a terminal; Claude cannot run it), revokes with
`--revoke`, and sees the state with `--list`. Grants are logged to
`/var/lib/rescuebot/write-grants.log`, kept in the Saved State.

Boot menu: memtest86+ is a legacy-BIOS-only entry (Utilities); the UEFI menu has none because
its EFI binary is not Secure Boot signed.

Rules this tree enforces (see the planning ADRs 0003, 0004, 0008): no Claude Code
in the image, no locally built or DKMS modules, kernel and firmware from
trixie-backports. The package mapping from SystemRescue is in `docs/package-map.md`.
