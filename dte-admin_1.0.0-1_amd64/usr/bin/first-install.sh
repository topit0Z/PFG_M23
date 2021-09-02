#!/bin/bash
# Script que se ejecuta al instalar el paquete DTE-Admin
# para realizar configuraciones iniciales
#
#

NOMBRE="DTE Admin - First Install"
VERSION=1.0.0
TITULO="$NOMBRE $VERSION"

#Cargamos las funciones
source ./functions.sh

## Main ##

setNombradoInterfaces
#getNombradoInterfaces
