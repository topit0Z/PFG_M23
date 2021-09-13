<?PHP
/*
Description: Script para la instalación de la clave pública de repositorios externos
Priority: 24
*/


include ("/m23/data+scripts/packages/m23CommonInstallRoutines.php");
include ("/m23/inc/distr/debian/clientConfigCommon.php");

function run($id)
{
        echo("sudo apt install curl
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl -sSL https://dl.cloudsmith.io/public/asbru-cm/release/gpg.7684B0670B1C65E8.key | sudo apt-key add -
curl -sSL https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
curl -sSL https://dl.teamviewer.com/download/linux/signature/TeamViewer2017.asc | sudo apt-key add -
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA854F61C4D0D9572BB95E5245D5502FAD7A805
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F88F6D313016330404F710FC9A2FD067A2E3EF7B
sudo apt update
");

	sendClientStatus($id,"done");
	executeNextWork();
};
?>