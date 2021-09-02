#!/bin/bash
#
# En este fichero se encuentran todas las funciones de las que hacen uso
# los scripts que componen el DTE-Admin
#

### Funciones auxiliares para el manejo de los diálogos whiptail ###

function _confirmacion {

	whiptail --title "$TITULO" \
	--yesno "$1" 10 78
}

function _info {

	TERM_TMP=$TERM 
	
	TERM=ansi #Debemos cambiar temporalmente el tipo de Terminal debido a un bug de whiptail infobox con xterm
	
	txt="$1"
	
	whiptail --title "$TITULO" \
	--infobox "$txt" 10 70
	
	TERM=$TERM_TMP
}

function _leerFichero {

	subtitulo="$1"
	fichero="$2"

	whiptail --title "$TITULO - $subtitulo" \
	--textbox $fichero 7 70 \
	-scrolltext
}

function _mensaje() {

	msg="$1"
	
	whiptail --title "$TITULO" \
	--msgbox "$msg" \
	10 70
}

function _formulario {

	pregunta="$1"
	default="$2"

	respuesta=$(whiptail --title "$TITULO" \
                     --inputbox "$pregunta" 10 70 "$default" \
                     3>&1 1>&2 2>&3)
	status=$?
	if [ $status = 0 ]
	then
	    echo "$respuesta"
	else
	    echo ""
	fi
}

###	###

### Funciones generales ###

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

# Escanea la red de área local en busca de clientes 
# que trate de realizar un arranque PXE
# y almacena sus direcciones MAC en el fichero $result_file
function escanearMAC {

	if [[ $(ip link show eth0 &> /dev/null) ]]; then

		tmp_file=/tmp/macs_tmp.txt
		
		result_file=/tmp/macs.txt
		
		result_file=$(_formulario "Indique el fichero dónde guardar los resultados:" "$HOME/mac.list" ) #Acabar esta mierda
		
		[ -f $result_file ] && rm -f $result_file #Borramos el fichero de resultados para no duplicar direcciones MAC
		
		(tcpdump -i eth0 -qtel broadcast and port bootpc > $tmp_file 2>/dev/null)& #Analizamos el tráfico de red en busca de arranques PXE
		_mensaje "Escaneando direcciones MAC...\nPulse aceptar para terminar."
		sudo killall tcpdump
		(perl -ane 'print "\U$F[0]\n"' $tmp_file|sort|uniq) > $result_file
		sed -i '/^$/d' $result_file
		rm -f $tmp_file
		
		if [ -s $result_file ]; then
	      		# The file is not-empty.
			_leerFichero "Direcciones MAC encontradas:" $result_file
			_mensaje "Las direcciones MAC se han guardado en $result_file"
		else
			# The file is empty.
			_mensaje "No se han encontrado clientes."
		fi
	else
		_mensaje "¡Error! Debe configurar las interfaces de red antes de escanear direcciones MAC."
	fi
}


function getNombradoInterfaces {

	IF_TYPE=""

	cat /etc/default/grub | grep "net.ifnames=0 biosdevname=0" > /dev/null && IF_TYPE="Clásico (ethX)" || IF_TYPE="Normal (enpXsY, enoX, ...)"
	
	[ "$1" = "show" ] && _mensaje "El nombrado actual de las interfaces de red es:\n$IF_TYPE"
	
	echo $IF_TYPE
}

set_dhcp_net(){
    #echo "auto lo" > $interfaces_file
    #echo "iface lo inet loopback" >> $interfaces_file
    echo ""  >> $interfaces_file
    echo "allow-hotplug eth1" >> $interfaces_file
    echo "iface eth1 inet dhcp" >> $interfaces_file    
}


set_static_net(){
    # set_static_net IP SUBNET GATEWAY
    echo "auto lo" > $interfaces_file
    echo "iface lo inet loopback" >> $interfaces_file
    echo ""  >> $interfaces_file
    echo "auto eth0" >> $interfaces_file
    echo "iface eth0 inet static" >> $interfaces_file
    echo "  address $1" >> $interfaces_file
    echo "  netmask $2" >> $interfaces_file
    #--> En nuestra arquitectura el Gateway es asignado por DHCP en la interfaz eth1, descomentar para cambios de arquitectura de red
    #echo "  gateway $3" >> $interfaces_file   
}

function configurarRed {

	IF_TYPE=$(getNombradoInterfaces)
	
	
	if [[ $(echo $IF_TYPE | grep Clásico) || "$1" = "nocheck" ]]; then
		#Estan normales
		_mensaje "Se van a configurar las interfaces de red:\n\neth0 --> con IP fija para conectar con los clientes.\neth1 --> con DHCP para la salida a internet"
		if [[ $(ip link show eth0) || "$1" = "nocheck" ]]; then
		
			IPADDR=$(_formulario "Indique la dirección IP para eth0:" "10.10.10.10")
			NETMASK=$(_formulario "Indique la máscara de Subred:" "255.255.255.0")
			
			#--> En nuestra arquitectura el Gateway es asignado por DHCP en la interfaz eth1, descomentar para cambios de arquitectura de red
			#GATEWAY=$(_formulario "Indique la dirección de Gateway:" "10.10.10.1") 
			
			set_static_net "$IPADDR" "$NETMASK"
			_mensaje "La interfaz eth0 ha sido configurada correctamente:\n\nDirección IP --> $IPADDR\nMáscara de Subred --> $NETMASK"
			
			if [[ $(ip link show eth1) || "$1" = "nocheck" ]]; then
			
			set_dhcp_net
			_mensaje "La interfaz eth1 ha sido configurada correctamente con DHCP."
			
			[ "$1" = "nocheck" ] || { _info "Reiniciando servicio de red...";systemctl restart networking &> /dev/null;ifup eth0 &> /dev/null;ifup eth1 &> /dev/null; }
			
			else
				_mensaje "¡Error! La interfaz eth1 no existe"
				return 1
			fi
		else
			_mensaje "¡Error! La interfaz eth0 no existe"
			return 1
		fi
	else
		_mensaje "¡Error! Debe cambiar el nombrado de interfaces a Clásico para poder configurarlas con el DTE Admin."
	fi
}

function setNombradoInterfaces {

	FLAG_FILE=$CONF_DIR/if_conf

	IF_TYPE=$(getNombradoInterfaces)

	if (_confirmacion "El nombrado actual de las interfaces de red es:\n$IF_TYPE\n\n¿Desea cambiarlo?"); then
	_info "Aplicando cambios..."
	    	if [[ $(echo $IF_TYPE | grep Normal) ]]; then
			IF_TYPE_FINAL="Clásico (ethX)"	
			sed -ie 's/GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="\1 net.ifnames=0 biosdevname=0"/' /etc/default/grub
			grub-mkconfig -o /boot/grub/grub.cfg &> /dev/null
		else
			IF_TYPE_FINAL="Normal (enpXsY, enoX, ...)"
			
			sed -ie 's/GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX=""/' /etc/default/grub
			grub-mkconfig -o /boot/grub/grub.cfg &> /dev/null
		fi
		_mensaje "El nombrado de las interfaces de red se ha cambiado de $IF_TYPE a $IF_TYPE_FINAL\n\nA continuación se reiniciará el equipo para aplicar los cambios."
		if (_confirmacion "¿Desea configurar la red antes de reniciar?\n De esta forma recuperará su conexión SSH"); then
			configurarRed "nocheck"
		fi
		clear
		reboot&
		exit
	fi	
}

