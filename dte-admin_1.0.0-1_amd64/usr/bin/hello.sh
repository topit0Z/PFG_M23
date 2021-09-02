#!/bin/bash
#
# Pedro Requena <pf.requena@alumnos.upm.es>
#


VERSION=1.0.0
TITULO="DTE Admin $VERSION"


clear

function instalarM23 {
	result="Instalando M23..."
}

function configurarRed {
	result="Configurando Red..."
}

# Escanea la red de área local en busca de clientes 
# que trate de realizar un arranque PXE
# y almacena sus direcciones MAC en el fichero $result_file
function escanearMAC {

	tmp_file=./tmp.txt
	result_file=./macs.txt
	
	if [ -f $result_file ]; then
		rm -f $result_file
	fi
	
	(sudo tcpdump -qtel broadcast and port bootpc > $tmp_file 2>/dev/null)&
	whiptail --title "$TITULO" --msgbox "Escaneando direcciones MAC...\nPulse aceptar para terminar." 10 70
	sudo killall tcpdump
	(perl -ane 'print "\U$F[0]\n"' $tmp_file|sort|uniq) > $result_file
	sed -i '/^$/d' $result_file
	rm -f $tmp_file
	if [ ! -s $result_file ]; then
      		# The file is not-empty.
		whiptail --title "$TITULO - Direcciones MAC encontradas:" --textbox $result_file 7 70	
	else
		# The file is empty.
		whiptail --title "$TITULO" --msgbox "No se han encontrado clientes." 10 70
	fi
}


# Main #
while true
do
CHOICE=$(
whiptail --title "$TITULO" --menu "Seleccione una opción" 20 40 5\
	"1)" "Instalar M23"   \
	"2)" "Configurar Red"  \
	"3)" "Escanear direcciones MAC"  \
	"4)" "Salir" \
3>&1 1<&2 2>&3) # Se intercambian stdout y stderr porque whiptail utiliza la primera para imprimir los diálogos y la segunda para los datos introducidos, así podemos recogerlos
	case $CHOICE in
		"1)")   
			instalarM23
		;;
		"2)")   
			configurarRed
		;;
		"3)")   
			escanearMAC
		;;
		"4)") 
			clear
			exit
		;;
	esac
done
clear
exit
