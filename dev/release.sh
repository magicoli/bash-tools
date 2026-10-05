#!/usr/bin/env bash
# Releases this project, from where it stands to the end (build-tools release)
#
# build-tools needs bash-tools itself, so it is not a dependency of this project: it is the one next to it, or an installed one.

root=$(cd "$(dirname "$0")/.." && pwd)
for tool in "$root/vendor/bin/build-tools" "$root/../build-tools/bin/build-tools" "$(command -v build-tools)"; do
    [[ -x "$tool" ]] && exec "$tool" release "$@"
done
source "$root/src/lib/bash-helpers"
die "build-tools not found: clone it next to this project (../build-tools) or install it"
