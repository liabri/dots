#!/bin/bash

# ──────╔═╗────────────────────────────╔╗─────╔╗╔╗
# ──────║╔╝───────────────────────────╔╝╚╗────║║║║
# ╔═╦══╦╝╚╦╗──╔══╦══╦╗╔╗╔╦══╦═╦══╦══╦═╬╗╔╬═╦══╣║║║╔══╦═╗
# ║╔╣╔╗╠╗╔╬╬══╣╔╗║╔╗║╚╝╚╝║║═╣╔╣╔═╣╔╗║╔╗╣║║╔╣╔╗║║║║║║═╣╔╝
# ║║║╚╝║║║║╠══╣╚╝║╚╝╠╗╔╗╔╣║═╣║║╚═╣╚╝║║║║╚╣║║╚╝║╚╣╚╣║═╣║
# ╚╝╚══╝╚╝╚╝──║╔═╩══╝╚╝╚╝╚══╩╝╚══╩══╩╝╚╩═╩╝╚══╩═╩═╩══╩╝
# ────────────║║
# ────────────╚╝
#
# Depends on:
#   Arch repositories: rofi, cpupower-gui
#
# Opens a rofi menu with available power options 


show_menu() {
	# get currently plural
	current_profile="$(cpupower-gui energy | grep -o -P '(?<=-).*(?=)' | head -5 | tail -n +2 | grep -n "Current" | cut -d : -f 1)"

	# get available energy preferences
    list="$(cpupower-gui energy --list-energy-preferences | grep - | sed 's/-//g;s/(Current)//g' | tr -d "[:blank:]" | head -5 | tail -n +2)"

    # open rofi menu, read chosen option
    echo "num: $current_profile"
    echo "list: $list"
    chosen="$(echo -e "$list" | $rofi_command "profiles" -a "$(expr $current_profile - 1)")"

    if [ ! -z $chosen ]; then
		# reset policy
 		sudo cpupower-gui -b

 		# set energy preference
    	sudo cpupower-gui energy --pref $chosen
    fi
}


# rofi command to pipe into, can add any options here
rofi_command="rofi -dmenu -no-fixed-num-lines -yoffset -100 -p"

case "$1" in
    --status)			print_status;;
    *)					show_menu;;
esac