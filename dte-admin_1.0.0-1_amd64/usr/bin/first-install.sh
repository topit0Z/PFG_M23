#!/bin/bash
# Script que se ejecuta al instalar el paquete DTE-Admin
# para realizar configuraciones iniciales
#
#

NOMBRE="DTE Admin - First Install"
VERSION=1.0.0
TITULO="$NOMBRE $VERSION"


interfaces_file=/etc/network/interfaces
BIN_DIR=/usr/bin

#Cargamos las funciones
source $BIN_DIR/functions.sh


## Main ##
setNombradoInterfaces
