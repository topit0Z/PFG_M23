<?PHP
/*
Description: Script para la instalación de la clave pública de repositorios externos
Priority: 50
*/


include ("/m23/data+scripts/packages/m23CommonInstallRoutines.php");
include ("/m23/inc/distr/debian/clientConfigCommon.php");

function run($id)
{
        echo("curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl -sSL https://dl.cloudsmith.io/public/asbru-cm/release/gpg.7684B0670B1C65E8.key | sudo apt-key add -
curl -sSL https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
curl -sSL https://dl.teamviewer.com/download/linux/signature/TeamViewer2017.asc | sudo apt-key add -
");

	sendClientStatus($id,"done");
	executeNextWork();
};
?>