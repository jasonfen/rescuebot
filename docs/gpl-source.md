# Corresponding source for released images (GPL)

Images carry GPL and other copyleft packages, so each release must make the
matching source available.

## How the build makes this possible

- Every package in an image comes from `snapshot.debian.org` at one pinned
  timestamp, in `image/SNAPSHOT` (suites: trixie, trixie-updates,
  trixie-security, trixie-backports).
- The same timestamp is recorded inside the image at `/etc/rescuebot-release`
  together with the git revision of this repo.
- The build writes `rescuebot-<snapshot>-sources.txt`: one line per source
  package, `name version`, for everything installed in the image.

## What a release must link (per release, not automated yet)

1. The snapshot URLs: `http://snapshot.debian.org/archive/debian/<SNAPSHOT>/` and
   `http://snapshot.debian.org/archive/debian-security/<SNAPSHOT>/`.
2. The `*-sources.txt` file from that build.
3. The repo tag (this repo is GPL-3.0-or-later and holds the live-build config).

Anyone can then fetch matching source with `apt-get source` after pointing a
`deb-src` line at the same snapshot URLs, for example:

    deb-src http://snapshot.debian.org/archive/debian/<SNAPSHOT>/ trixie main non-free-firmware
    deb-src http://snapshot.debian.org/archive/debian/<SNAPSHOT>/ trixie-backports main non-free-firmware
    deb-src http://snapshot.debian.org/archive/debian-security/<SNAPSHOT>/ trixie-security main

Releasing is a later step; the build workflow does not publish anything.

## Caveat

snapshot.debian.org is run by Debian volunteers. If a release must survive its
disappearance, the project should also mirror the source packages, or attach a
source tarball set, to the release. Not done in v1 item 1.
