#!/bin/sh

DMENU="dmenu -i -l 20 -p"
TERM="st -e"

declare -a options=("Search manpages" "Random manpage" "Quit")

choice=$(printf '%s\n' "${options[@]}" | ${DMENU} 'Manpages:' "$@")

case "$choice" in
	'Search manpages')
		man -k . | awk '{$3="-"; print $0}' | \
		${DMENU} 'Search for: ' | \
		awk '{print $2, $1}' | tr -d '()' | xargs $TERM man
		;;
	'Random manpage')
		man -k . | cut -d' ' -f1 | shuf -n 1 | \
		${DMENU} 'Random manpage:' | xargs $TERM man
		;;
	*)
		exit 0
		;;
esac
