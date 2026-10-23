#!/bin/bash
# Post-build checks on the final ISO. Exits non-zero on any violation.
# Usage: check-iso.sh path/to.iso
set -euo pipefail
iso="$1"
listing="$(xorriso -indev "$iso" -find / -type f 2>/dev/null)"

# Positive control: the listing must contain files we know are there, otherwise
# an empty result below means nothing.
for must in /live/vmlinuz /live/filesystem.squashfs /live/memtest.bin; do
	grep -qxF "'$must'" <<<"$listing" || { echo "CHECK FAILED: expected $must missing from ISO listing (or listing broken)" >&2; exit 1; }
done

# memtest86+'s EFI binary is unsigned: it must not ship (BIOS memtest.bin stays).
if grep -qiE "memtest.*\.efi'$" <<<"$listing"; then
	echo "CHECK FAILED: memtest EFI binary present on ISO:" >&2
	grep -iE "memtest.*\.efi'$" <<<"$listing" >&2
	exit 1
fi
echo "ISO checks passed: $iso"
