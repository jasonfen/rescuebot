# Recovery toolset: SystemRescue to Debian mapping

Baseline is the SystemRescue 13.02 package list
(https://www.system-rescue.org/Detailed-packages-list/, fetched 2026-10-22),
mapped by purpose to Debian 13 packages, plus the extra tools the v1 design
names. The shipped lists are in `image/config/package-lists/`. Libraries and
runtime dependencies in the SystemRescue list are not mapped one by one; apt
pulls the Debian equivalents.

Availability below was checked against the pinned snapshot (trixie, trixie-backports,
non-free-firmware), not from memory.

## Kept (Debian name where it differs)

| Purpose | Debian packages |
|---|---|
| Imaging, cloning | gddrescue (ddrescue), ddrutility, partclone, partimage, fsarchiver, clonezilla, testdisk (includes PhotoRec), foremost, sleuthkit, pv |
| Partitioning, boot repair | gparted, parted, gdisk, gpart, fatresize, fatsort, efibootmgr, efitools, efivar, grub-pc-bin, grub-efi-amd64-bin, grub-common, syslinux, kpartx |
| Filesystems | dosfstools, e2fsprogs, exfatprogs, f2fs-tools, jfsutils, xfsprogs, xfsdump, nilfs-tools (nilfs-utils), ntfs-3g, btrfs-progs, udftools, mtools, squashfs-tools, fuse3 |
| Encryption, RAID, LVM | cryptsetup, mdadm, lvm2, multipath-tools, thin-provisioning-tools, dislocker, ecryptfs-utils |
| Windows accounts, archives | chntpw, wimtools (wimlib), cabextract, 7zip, zip, unzip, xz-utils, zstd, lz4, lzop, par2 |
| Disk and hardware health | smartmontools, gsmartcontrol, nvme-cli, hdparm, sdparm, sg3-utils, lsscsi, nwipe, wipe, zerofree, lshw, hwinfo, hardinfo, dmidecode, pciutils, usbutils, inxi, lm-sensors, flashrom, ipmitool, memtester, stress-ng, usb-modeswitch, memtest86+ (legacy-BIOS boot menu only via `--memtest`; its unsigned EFI binary is stripped from the ISO) |
| Network | network-manager (+ gnome applet, openvpn, vpnc), wpasupplicant, iw, wireless-tools, rfkill, ethtool, openvpn, wireguard-tools, nmap, tcpdump, mtr-tiny (mtr), traceroute, iperf3, netcat-openbsd, sshfs, cifs-utils, nfs-common (nfs-utils), smbclient, lftp, rsync, rclone, borgbackup (borg), rdiff-backup, ppp, minicom, picocom |
| Desktop | Xfce (session, wm, panel, settings, terminal, appfinder, taskmanager, screenshooter, power-manager), thunar, mousepad (for featherpad/geany), xarchiver, ristretto, galculator, keepassxc, firefox-esr (firefox-esr-bin), remmina, x11vnc, pavucontrol |
| Editors, shell | vim, nano, mc, tmux, screen, htop, atop, ncdu, tree, jq, hexedit, ghex, less |
| Firmware, microcode | firmware-linux and the vendor firmware packages (non-free-firmware), intel-microcode, amd64-microcode, wireless-regdb |

## Added beyond SystemRescue

ddrutility, partimage, foremost, sleuthkit and the v1-named tools that
SystemRescue lacks are in the Kept table. Claude Code install prerequisites
(bash, curl, ca-certificates, gnupg, ripgrep, git, libstdc++6, libgcc-s1) are
in `10-claude-prereqs.list.chroot`; Claude Code itself is not installed (ADR 0003).

## Dropped, with reason

| SystemRescue package(s) | Why dropped |
|---|---|
| pacman, yay, archinstall, arch-install-scripts, mkinitcpio*, reflector, archlinux-keyring, expac, localepurge | Arch tooling. Replaced by apt, initramfs-tools, live-build. |
| bcachefs-lts, bcachefs-tools | Not in Debian 13 (checked). Candidate Add-on. |
| dmraid | Not in Debian 13 (checked). mdadm handles Intel/IMSM fake-RAID; revisit if a Patient needs legacy dmraid. |
| ms-sys | Not in Debian 13 (checked). |
| dd_rescue | Not in Debian 13 under that name (checked); gddrescue is the standard tool. |
| whdd | Not in Debian. |
| unrar | Non-free section, not enabled (only main + non-free-firmware). 7zip reads RAR. |
| zfs (SystemRescue builds it in) | Add-on by ADR 0004; needs locally built modules. |
| yubikey-*, pam-u2f, stoken, oath-toolkit, pcsclite, ccid | FIDO2/token unlock is out of v1 (design D17). |
| refind, timeshift, grsync, speedtest-cli, irssi, elinks, geany, featherpad, xfburn, rkhunter, darkhttpd, dnsmasq (server), nfs server bits, udpcast, drbl, wvdial, pptpclient, xl2tpd | Not needed for rescue; keep the image under the 2 GiB release-asset limit. Easy to add back. |
| thunar-volman, udisks2, gvfs (not in SystemRescue's list by name, but normal Xfce companions) | Deliberately omitted: they automount, which ADR 0002 forbids for Patient Disks. |
| kernel packages (linux-lts, linux-firmware-*) | Replaced by linux-image-amd64 and firmware-* from trixie-backports. |
