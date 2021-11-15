#!/bin/sh

set -euo pipefail

DMENU="dmenu -i -l 20 -p"
LOCKER="slock"

dwm=$( ps -o pid,cmd ax | awk '/dwm/{ if ($2 == "dwm") print $1 }' )

declare -a options=(
	"Lock screen"
	"Logout"
	"Reboot"
	"Shutdown"
	"Suspend"
	"Quit"
)

declare -a yesno=(
	"Yes"
	"No"
)

choice=$(printf '%s\n' "${options[@]}" | ${DMENU} 'Shutdown menu:' "${@}") 

case $choice in
	'Logout')
		if [[ $(printf '%s\n' "${yesno[@]}" | ${DMENU} "${choice}?" ) == "Yes" ]]; then
			[[ ! -z "$dwm" ]] && kill -s TERM $dwm
		fi
		;;
	'Lock screen')
		${LOCKER}
		;;
	'Reboot')
		if [[ $(printf '%s\n' "${yesno[@]}" | ${DMENU} "${choice}?" ) == "Yes" ]]; then
			systemctl reboot
		fi
		;;
	'Shutdown')
		if [[ $(printf '%s\n' "${yesno[@]}" | ${DMENU} "${choice}?" ) == "Yes" ]]; then
			systemctl poweroff
		fi
		;;
	'Suspend')
		if [[ $(printf '%s\n' "${yesno[@]}" | ${DMENU} "${choice}?" ) == "Yes" ]]; then
			systemctl suspend
		fi
		;;
	'Quit')
		exit 0
		;;
	*)
		exit 0
		;;
esac
		
