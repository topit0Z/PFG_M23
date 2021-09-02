#!/bin/bash
# DTE Admin
# Pedro Requena <pf.requena@alumnos.upm.es>
#


NOMBRE="DTE Admin"
VERSION=1.0.0
TITULO="$NOMBRE $VERSION"

LOG_DIR=/var/log/DTE-Admin
CONF_DIR=/etc/DTE-Admin
FLAG_FILE=$CONF_DIR/if_conf

PASSWORD=""

interfaces_file=/etc/network/interfaces

#Cargamos las funciones
source ./functions.sh


# Main #
#PASSWORD=$(_formulario "Introduzca su contraseña para sudo")

#Creamos el directorios de Logs si no existe
[ -d $LOG_DIR ] || mkdir -p $LOG_DIR

# Check user
	USER=$(whoami 2> /dev/null)
	if [ "$USER" != "root" ]
	then
		_mensaje "¡Error! Debe tener privilegios de root para ejecutar el DTE Admin"
		exit 1
  	fi

while true
do
#
CHOICE=$(
	whiptail --title "$TITULO" --menu "Seleccione una opción" 20 75 8\
	"1)" "Instalar M23"   \
	"2)" "Configurar Red"  \
	"3)" "Escanear direcciones MAC"  \
	"4)" "Consultar nombrado de las interfaces de red" \
	"5)" "Cambiar nombrado de las interfaces de red" \
	"6)" "Salir" \
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
			getNombradoInterfaces "show"
		;;
		"5)")   
			setNombradoInterfaces
		;;
		"6)") 
			clear
			exit
		;;
	esac
done
clear
exit