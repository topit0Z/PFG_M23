<?PHP
/*
Description: Script para la instalación de paquetes snap.
Priority: 26
*/


include ("/m23/data+scripts/packages/m23CommonInstallRoutines.php");
include ("/m23/inc/distr/debian/clientConfigCommon.php");

function run($id)
{
        echo("snap install android-studio --classic
snap install postman
");

	sendClientStatus($id,"done");
	executeNextWork();
};
?>

