#! /usr/bin/env bash

# get ip of the printer
resolve="$(avahi-resolve --name EPSON0A7833.local)"
if [[ "${resolve}" == *"Failed to resolve"* ]]
then
	echo "Can't resolve the printer, please confirm the Printer is turned on and try again."
	exit -1
else
	parts=( $resolve )
	ip=${parts[1]}
	echo "Printer IP is: "$ip
	newipline="myscanner.udi    = esci:networkscan://"${ip}":1865"
	echo $newipline
	lineno="$(grep -n '^myscanner\.udi' /etc/imagescan/imagescan.conf | cut -s -f1 -d:)"
	if [ ! -z $lineno ]
	then
		echo $lineno
		sed -i "s/^myscanner\.udi.*/${newipline}/" /etc/imagescan/imagescan.conf
	else
		echo "Please check if imagescan is installed."
	fi
fi


