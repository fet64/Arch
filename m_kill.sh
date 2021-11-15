#!/bin/sh

set -euo pipefail

DMENU="dmenu -i -l 20 -p"

selected="$(ps --user "$USER" -F | \
	${DMENU} "Search for process to kill:" "$@" | \
	awk '{ print $2" "$11}')";

if [[ -n $selected ]]; then
	answer="$(echo -e "No\nYes" | ${DMENU} "Kill $selected?" "$@")"
	if [[ $answer == "Yes" ]]; then
		kill -9 "${selected%% *}"
		echo "Process $selected has been killed." && exit 0
	else
		echo "Program terminated." && exit 1
	fi
fi
