#!/usr/bin/env bash
set -eu
OS=$(uname -s)

if [ "$OS" == "OpenBSD" ]; then
    get_volume="$(mixerctl -n outputs.master)"
    this_volume=${get_volume/,*/}
    mixerctl -q outputs.master=$((this_volume - 25))
else
    ossmix vmix0-outvol -- -2.5
fi

