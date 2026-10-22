# Rescuebot

A bootable live Linux system for repairing and recovering other machines, with recovery tools and Claude Code on board.

## Language

**Rescue Stick**:
A USB drive with Rescuebot installed, which boots live and saves its state back to itself.
_Avoid_: USB version, persistent install

**Live ISO**:
The Rescuebot image booted from read-only media (CD, Ventoy, VM), which keeps no state between boots.
_Avoid_: CD version, ISO version

**Saved State**:
Everything a Rescue Stick keeps between boots, held in one encrypted area unlocked by a passphrase at boot.
_Avoid_: persistence, vault, secure store

**Recovery Key**:
A long random code generated at Stick Setup that unlocks the Saved State in place of the passphrase; regenerating it revokes the old one.
_Avoid_: backup password, passkey, recovery passphrase

**Stateless Boot**:
A boot that keeps nothing afterward: always the case for the Live ISO, and for a Rescue Stick when the Saved State is not unlocked.
_Avoid_: amnesiac mode, guest mode

**Stick Setup**:
The one-time step, run from Rescuebot itself on first boot from a USB stick, that creates the Saved State and turns the stick into a Rescue Stick.
_Avoid_: install, provisioning

**Add-on**:
Optional software a user installs after boot rather than receiving in the image, such as Claude Code or ZFS support. Kept in the Saved State on a Rescue Stick, lost at reboot on a Stateless Boot.
_Avoid_: plugin, extension, package

## Rescue jobs

**Patient**:
The machine being repaired or recovered from. Its disks are **Patient Disks**.
_Avoid_: target, host, victim

**Destination**:
Where recovered data is written: the Saved State, an external drive, or a NAS share, chosen per job. Never a Patient Disk.
_Avoid_: output drive, backup

**Image**:
A sector-level copy of a Patient Disk, or part of one, kept on a Destination; a failing disk is imaged before any other work by default.
_Avoid_: backup, clone, dump

**Write Grant**:
A person's explicit, per-disk permission that makes one disk writable. Every disk other than the Rescue Stick starts read-only; Claude may request a Write Grant but is not permitted to give one.
_Avoid_: unlock (reserved for the Saved State passphrase), arming

**Job**:
One rescue of one Patient, with its record kept in the Saved State: Patient identity, disk inventory and health, actions taken, Write Grants given, Claude transcripts, and where recovered data went.
_Avoid_: session, case, ticket

**Job Summary**:
The human-readable account of a Job written to its Destination alongside the recovered data, for the Patient's owner.
_Avoid_: report, log
