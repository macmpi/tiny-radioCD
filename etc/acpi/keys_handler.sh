#!/bin/sh

# Part of tiny-radioCD project, originally designed & hand-crafted by macmpi
# check License at project home https://github.com/macmpi/tiny-radioCD

# This is the default ACPI handler script that is configured in
# /etc/acpi/events/anykey to be called for every ACPI event.

# Key codes are derivatives of linux kernel codes and are defined in
# https://github.com/tedfelix/acpid2/blob/master/input_layer.c
# <dev-class>:<dev-name>:<notif-value>:<sup-value>

logger -t ${0##*/} "$2"

case "$2" in

BACK)
	/etc/acpi/remote/RANDOM &
;;
DOWN)
	/etc/acpi/remote/POWEROFF &
;;
CDEJECT)
	/etc/acpi/remote/EJECT &
;;
CDEJECTCLOSE)
	/etc/acpi/remote/EJECT &
;;
FF)
	/etc/acpi/remote/NEXT &
;;
HOMEPAGE)
	/etc/acpi/remote/TRACK_1 &
;;
KPENTER)
	/etc/acpi/remote/NIL &
;;
LEFT)
	/etc/acpi/remote/REWIND_TRACK &
;;
MENU)
	/etc/acpi/remote/SEQUENCE &
;;
MUTE)
	/etc/acpi/remote/MUTE &
;;
CDNEXT)
	/etc/acpi/remote/NEXT &
;;
CDPAUSE)
	/etc/acpi/remote/PLAY_PAUSE &
;;
CDPLAY2)
	/etc/acpi/remote/PLAY_PAUSE &
;;
CDPLAY)
	/etc/acpi/remote/PLAY_PAUSE &
;;
PBTN)
	/etc/acpi/remote/POWEROFF &
;;
CDPREV)
	/etc/acpi/remote/PREVIOUS &
;;
REW)
	/etc/acpi/remote/PREVIOUS &
;;
RIGHT)
	/etc/acpi/remote/SWAP_PLAYLISTS &
;;
UP)
	/etc/acpi/remote/EJECT &
;;
VOLDN)
	/etc/acpi/remote/VOLUMEDOWN &
;;
VOLUP)
	/etc/acpi/remote/VOLUMEUP &
;;
esac

exit 0

