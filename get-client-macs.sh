#!/bin/bash

SECONDS=$(dialog --stdout --title "Tiempo de Captura" --inputbox "Indique el periodo de captura (en segundos):" 7 70)


clear

echo $SECONDS

if (( $SECONDS == 0 )); then

	exit

else
	rm -f /tmp/mac.list &> /dev/null
	rm -f > /tmp/mac.list.clean &> /dev/null
	
	dialog --title "Capturando direcciones MAC" --infobox "Espere $SECONDS segundos" 7 70
	
	timeout $SECONDS tcpdump -qtel broadcast and port bootpc >/tmp/mac.list 2>/dev/null

	(perl -ane 'print "\U$F[0]\n"' /tmp/mac.list|sort|uniq) >/tmp/mac.list.clean

	sed -i '/^$/d' /tmp/mac.list.clean
	
	dialog --title "Direcciones MAC capturadas" --textbox /tmp/mac.list.clean 7 70
	clear
	#num_direcciones=$(cat /tmp/mac.list.clean | wc -l)
	#dialog --title "Direcciones MAC capturadas" --textbox "Se han capturado un total de $num_direcciones direcciones MAC" 7 70
	sleep 2
	clear
	
	#cat /tmp/mac.list.clean
	
	#clear
	#cat /tmp/mac.list.clean
	sshpass -p 'Cjsheet03' scp /tmp/mac.list.clean topito@10.10.10.1:/home/topito
fi
