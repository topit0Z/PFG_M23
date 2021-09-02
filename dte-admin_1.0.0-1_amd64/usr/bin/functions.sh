#!/bin/bash

function _leerFichero {

	subtitulo="$1"
	fichero="$2"

	whiptail --title "$TITULO - $subtitulo" \
	--textbox $fichero 7 70 \
	-scrolltext
}

function _mensaje {
	msg="$1"
	
	whiptail --title "$TITULO" \
	--msgbox $msg \
	10 70
}

function _formulario {

	pregunta="$1"
	default="$2"

	respuesta=$(whiptail --title $TITULO \
                     --inputbox $pregunta 10 70 $default \
                     3>&1 1>&2 2>&3)
	status=$?
	if [ $status = 0 ]
	then
	    echo "$respuesta"
	else
	    echo ""
	fi
}

function instalarM23 {

	LOG_FILE=$LOG_DIR/instalarM23.log
	
	echo "#################" >> $LOG_FILE
	echo "##### `date` #####" >> $LOG_FILE
	echo "#################" >> $LOG_FILE
	
	# Si no existe la clave del repositorio APT de M23, la añadimos
	(apt-key list 2> /dev/null | grep "Hauke Goos-Habermann" &> /dev/null) || (wget -T1 -t1 -q http://m23.sourceforge.net/m23-Sign-Key.asc -O - | apt-key add -)
	
	# Si no existe el repositorio de M23 en los sources de APT, lo añadimos
	[ -f /etc/apt/sources.list.d/m23.list ] || echo 'deb http://m23inst.goos-habermann.de ./' > /etc/apt/sources.list.d/m23.list
	
	#Actualizamos la base de datos de APT
	apt update &>> $LOG_FILE
	
	export DEBIAN_FRONTEND=noninteractive
	
	#Instalamos M23 y sus dependencias
	apt install -y m23
	
	export DEBIAN_FRONTEND=""
	
	_mensaje "La instalación de M23 ha finalizado."
	
	#¿Donde metemos el dpkg-reconfigure?
}

function configurarRed {
	result="Configurando Red..."
}

# Escanea la red de área local en busca de clientes 
# que trate de realizar un arranque PXE
# y almacena sus direcciones MAC en el fichero $result_file
function escanearMAC {

	tmp_file=/tmp/macs_tmp.txt
	
	result_file=/tmp/macs.txt
	
	result_file=$(_formulario "" ) #Acabar esta mierda
	
	[ -f $result_file ] && rm -f $result_file #Borramos el fichero de resultados para no duplicar direcciones MAC
	
	(sudo tcpdump -qtel broadcast and port bootpc > $tmp_file 2>/dev/null)& #Analizamos el tráfico de red en busca de arranques PXE
	_mensaje "Escaneando direcciones MAC...\nPulse aceptar para terminar."
	sudo killall tcpdump
	(perl -ane 'print "\U$F[0]\n"' $tmp_file|sort|uniq) > $result_file
	sed -i '/^$/d' $result_file
	rm -f $tmp_file
	
	
	if [ -s $result_file ]; then
      		# The file is not-empty.
		_leerFichero "Direcciones MAC encontradas:" $result_file
	else
		# The file is empty.
		_mensaje "No se han encontrado clientes."
	fi
}


function nombradoInterfaces {

	cat /etc/default/grub | grep "net.ifnames=0 biosdevname=0" || sed -ie 's/GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="\1 net.ifnames=0 biosdevname=0"/' /etc/default/grub
	grub-mkconfig -o /boot/grub/grub.cfg
	
	_mensaje "hello"
}
