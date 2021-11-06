#!/bin/sh
set -e

tmp="$(mktemp)"
trap 'rm "$tmp"' EXIT

OUT="$tmp" SHELLCHECK=1 ./build.sh
shellcheck "$tmp"
