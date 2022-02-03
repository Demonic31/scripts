#!/bin/sh
# Créateur Eric Legigan
# Version 1.0 du 08/04/2020 : Première version
# Version 1.1 du 09/04/2020 : Ajout de l'option de téléchargement des fichiers, correstion après test avec le VIN d'un RCC
# Version 1.2 du 09/04/2020 : Ajout du mode Debug en ajoutant un second paramètre "true" pour afficher plus d'informations, test des versions actuelles GPS et firmware et gestion des mises à jour proposées.

curlurl="https://api.groupe-psa.com/applications/majesticf/v1/getAvailableUpdate?client_id=1eeecd7f-6c2b-486a-b59c-8e08fca81f54"
curlCookie="PSACountry=FR"
curlContentType="application/json"
curlAccept="application/json, text/plain, */*"

if [ $# -eq 0 ]
  then
    echo "Merci de fournir le VIN de véhicule en paramètre."
	exit
fi


VIN=$1
debug=$2
echo "Script de télécharement des mises à jours NAC et RCC"
echo "Traitement du véhicule avec le VIN suivant : "$VIN

data="{\"vin\":\"$VIN\",\"softwareTypes\":[{\"softwareType\":\"ovip-int-firmware-version\"},{\"softwareType\":\"rcc-firmware\"}]}";

reponse=`curl -s -H "Cookie: $curlCookie" -H "Accept: $curlAccept" -H "Content-type: $curlContentType" -X POST -d $data $curlurl`

case "$reponse" in
    *ovip-int-firmware-version* ) model=NAC; data2="{\"vin\":\"$VIN\",\"softwareTypes\":[{\"softwareType\":\"ovip-int-firmware-version\"},{\"softwareType\":\"map-eur\"}]}";;
	*rcc-firmware* ) model=RCC; data2="{\"vin\":\"$VIN\",\"softwareTypes\":[{\"softwareType\":\"rcc-firmware\"},{\"softwareType\":\"map-eur\"}]}";;
    * ) echo "Erreur...";;
esac

reponse2=`curl -s -H "Cookie: $curlCookie" -H "Accept: $curlAccept" -H "Content-type: $curlContentType" -X POST -d $data2 $curlurl`
echo "Model : "$model

echo $reponse2 > result.json

case "$model" in
	NAC )
	GPSversion=`jq ".software[0].currentSoftwareVersion" result.json| sed -r 's/^"|"$//g'`
	GPSLicencefile=`jq ".software[0].update[0].licenseURL" result.json| sed -r 's/^"|"$//g'`
	GPSupdatetype=`jq ".software[0].softwareType" result.json| sed -r 's/^"|"$//g'`
	GPSupdateurl=`jq ".software[0].update[0].updateURL" result.json| sed -r 's/^"|"$//g'`
	GPSupdateversion=`jq ".software[0].update[0].updateVersion" result.json| sed -r 's/^"|"$//g'`
	Softversion=`jq ".software[1].currentSoftwareVersion" result.json| sed -r 's/^"|"$//g'`
	SoftLicencefile=`jq ".software[1].update[0].licenseURL" result.json| sed -r 's/^"|"$//g'`
	Softupdatetype=`jq ".software[1].softwareType" result.json| sed -r 's/^"|"$//g'`
	Softupdateurl=`jq ".software[1].update[0].updateURL" result.json| sed -r 's/^"|"$//g'`
	Softupdateversion=`jq ".software[1].update[0].updateVersion" result.json| sed -r 's/^"|"$//g'`

	case "$debug" in
		true ) echo $reponse2 | python -mjson.tool
		echo "............................................"
		echo "Version actuelle des cartes GPS : "$GPSversion
		echo "Type de mise à jour : "$GPSupdatetype
		echo "Lien de la mise à jour : "$GPSupdateurl
		echo "Lien du fichier de licence : "$GPSLicencefile
		echo "Version de la mise à jour : "$GPSupdateversion
		echo "............................................"
		echo "Version actuelle du firmware :"$Softversion
		echo "Type de mise à jour : "$Softupdatetype
		echo "Lien de la mise à jour : "$Softupdateurl
		echo "Lien du fichier de licence : "$SoftLicencefile
		echo "Version de la mise à jour : "$Softupdateversion
		echo "............................................"
	esac

	if [ -z $GPSupdateversion ]
	then
		echo "......................................................"
		echo "Pas de mise à jour GPS !!!"
		echo "......................................................"
	else
		if [ $GPSupdateversion != $GPSversion ]
		then
			echo "......................................................"
			echo "Une mise à jour GPS est disponible : " $GPSupdateversion" pour la version actuelle : " $GPSversion
			echo "......................................................"
		fi
	fi
	
	if [ -z $Softupdateversion ]
	then
		echo "......................................................"
		echo "Pas de mise à jour firmware !!!"
		echo "......................................................"
	else
		if [ $Softupdateversion != $Softversion ]
		then
			echo "......................................................"
			echo "Une mise à jour firmware est disponible : " $Softupdateversion" pour la version actuelle : " $Softversion
			echo "......................................................"
		fi
	fi
	while true; do
		read -p "Voulez-vous télécharger les fichiers ?" on
		case $on in
			[Oo]* ) wget --continue --content-disposition $SoftLicencefile $Softupdateurl $GPSupdateurl ; break;;
			[Nn]* ) exit;;
			* ) echo "Svp répondez oui ou non.";;
		esac
	done;;

	RCC )
	Softversion=`jq ".software[0].currentSoftwareVersion" result.json| sed -r 's/^"|"$//g'`
	SoftLicencefile=`jq ".software[0].update[0].licenseURL" result.json| sed -r 's/^"|"$//g'`
	Softupdatetype=`jq ".software[0].softwareType" result.json| sed -r 's/^"|"$//g'`
	Softupdateurl=`jq ".software[0].update[0].updateURL" result.json| sed -r 's/^"|"$//g'`
	Softupdateversion=`jq ".software[0].update[0].updateVersion" result.json| sed -r 's/^"|"$//g'`

	case "$debug" in
		true ) echo $reponse2 | python -mjson.tool
		echo "............................................"
		echo "Version actuelle du firmware :"$Softversion
		echo "Type de mise à jour : "$Softupdatetype
		echo "Lien de la mise à jour : "$Softupdateurl
		echo "Lien du fichier de licence : "$SoftLicencefile
		echo "Version de la mise à jour : "$Softupdateversion
		echo "............................................"
	esac
	
	if [ -z $Softupdateversion ]
	then
		echo "......................................................"
		echo "Pas de mise à jour firmware !!!"
		echo "......................................................"
	else
		if [ $Softupdateversion != $Softversion ]
		then
			echo "......................................................"
			echo "Une mise à jour firmware est disponible : " $Softupdateversion " pour la version actuelle : " $Softversion
			echo "......................................................"
		fi
	fi
	while true; do
		read -p "Voulez-vous télécharger les fichiers ?" on
		case $on in
			[Oo]* ) wget --continue --content-disposition $SoftLicencefile $Softupdateurl ; break;;
			[Nn]* ) exit;;
			* ) echo "Svp répondez oui ou non.";;
		esac
	done;;
    * ) echo "Modèle non indentifié...";;
esac