#!/bin/bash
# Build the Rescuebot Live ISO inside the pinned Debian container.
# Usage: image/build.sh [outdir]      (default ./out)
# Needs Docker with --privileged (live-build mounts and chroots).
# Works the same locally and in CI.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
out="$(mkdir -p "${1:-$here/../out}" && cd "${1:-$here/../out}" && pwd)"
snapshot="${SNAPSHOT:-$(cat "$here/SNAPSHOT")}"
gitrev="$(git -C "$here" rev-parse HEAD 2>/dev/null || echo unknown)"

docker build --platform linux/amd64 --build-arg "SNAPSHOT=$snapshot" \
	-t rescuebot-builder -f "$here/Dockerfile" "$here"

# Build on the container's own filesystem, not a bind mount: live-build needs
# real device nodes, ownership and mount semantics.
docker run --rm --privileged --platform linux/amd64 \
	-e "SNAPSHOT=$snapshot" -e "GITREV=$gitrev" \
	-v "$here:/src:ro" -v "$out:/out" \
	rescuebot-builder bash /src/in-container-build.sh
