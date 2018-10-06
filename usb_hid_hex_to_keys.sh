#!/bin/bash

# Convert hex data extracted from USB pcaps to keyboard characters based on 1.12.1 USB HID spec

# The script expects an input file parsed as an arguement
# The input file should only contain "Leftover Capture Data" aka hex

# Currently, this script is only interested in the 1st (modifier) and 3rd (1st key) bytes in the hex string (up-to 2 key combos - e.g. Shift+d)

input_file="$1"

if [ -z "$input_file" ]; then
	echo "no input file provided"
	echo "pass input file as an arguement when calling the script"
	echo "e.g. ./usb_hid_hex_to_keys.sh file.txt"
	sleep 3
	exit
fi

# import key map
source usb_hid_keys

while read -r hex; do
	#1st "${hex:0:2}"
	#3rd "${hex:4:2}"
	mod_byte="${hex:0:2}"
	key1_byte="${hex:4:2}"

	if [ "$mod_byte" = "02" ]; then
		#shift="true"
		index="2"
	elif [ "$mod_byte" = "20" ]; then
		#shift="true"
		index="2"
	else
		#ignoring other modifiers (Ctrl, Alt, etc) for now
		#shift="false"
		index="1"
	fi
	
	if [ "$key1_byte" = "00" ]; then
		#no key
		continue
	else
		key_lookup="hex_$key1_byte"
		key_stroke="$(echo ${!key_lookup} | awk -F " " '{print $'$index'}')"
		echo "$key_stroke"
	fi

done < "$input_file"
