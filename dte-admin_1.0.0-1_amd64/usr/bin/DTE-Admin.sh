#!/bin/bash
# DTE Admin
# Pedro Requena <pf.requena@alumnos.upm.es>
#

NOMBRE="DTE Admin"
VERSION=1.0.0
TITULO="$NOMBRE $VERSION"

source ./functions.sh


LOG_DIR=/var/log/DTE-Admin

PASSWORD=


# Main #
#PASSWORD=$(_formulario "Introduzca su contraseña para sudo")

#Creamos el directorios de Logs si no existe
[ -d $LOG_DIR ] || mkdir -p $LOG_DIR

while true
do
#
CHOICE=$(
	whiptail --title "$TITULO" --menu "Seleccione una opción" 20 75 5\
	"1)" "Instalar M23"   \
	"2)" "Configurar Red"  \
	"3)" "Escanear direcciones MAC"  \
	"4)" "Cambiar el criterio de nombrado de las interfaces de red" \
	"5)" "Salir" \
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
			nombradoInterfaces
		;;
		"5)") 
			clear
			exit
		;;
	esac
done
clear
exit
