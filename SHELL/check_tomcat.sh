#!/bin/bash

# TITRE check_tomcat.sh
# DESCRIPTION : Script de check du nombre de TOMCAT statusOK/KO
# USAGE : lancement du script en ajoutant l'argument -a <début du nom des tomcats> (ex pour appli : ./check_tomcat.sh -a app)
# HISTORIQUE :
# T |  Date      |  Auteur                      |  Description
#---+------------+------------------------------+------------------------------------
# A |  05/03/21  |  Demonic                     |  Création
# -----------------------------------------------------------------------------------


#########################################
##    DECLARATION DES VARIABLES        ##
#########################################

# INITIALISATION DESCRIPTION ALERTE NAGIOS
statusReport=""
# INITIALISATION SEVERITE ALERTE NAGIOS (OK PAR DEFAUT)
severityReport=0
# INITIALISATION VARIABLE DU NOMBRE TOTAL DE TOMCAT
NBNOMINAL=""
# INITIALISATION VARIABLE DU NOMBRE TOTAL DE TOMCAT statusOK
NBOK=""
# INITIALISATION VARIABLE DU NOMBRE TOTAL DE TOMCAT statusKO
NBKO=""
# INITIALISATION VARIABLE DU NOM DE TOMCATS KO
LISTEKO=""

#########################################
##    DECLARATION DES FONCTIONS        ##
#########################################

# decho(){
#         [ ${debug} -gt 0 ] && echo $*
# }

# FONCTION POUR DEFINIR LA SEVERITE DE L'ALERTE
setSeverity(){
    severityToSet=${1}
    case ${severityToSet} in
        0)[ ${severityReport} -lt 1 ] && severityReport=0;;
        1)[ ${severityReport} -lt 2 ] && severityReport=1;;
        2)severityReport=2;;
    esac
}

# FONCTION USAGE (option -h)
USAGE(){
        echo "Ce script permet de vérifier le nombre de TOMCAT statusactifs et renvoyer une alerte via Nagios si KO"
        echo "USAGE : check_tomcat.sh -a <3 premières lettres des tomcat>"
        echo "exemple pour appli : check_tomcat.sh -a app"
        echo "Info : Le script va filtrer les services via la commande : service app* et compter les lignes actives/inactives"
        exit 0
}

#########################################
##    RECUPERATION DES ARGUMENTS       ##
#########################################

# ARGUMENT -a : NOM DU TOMCAT
# ARGUMENT -h : USAGE
# POUR LE -a, AJOUT DE * A LA VARIABLE POUR SORTIR LA TOTALITE DES TOMCATS VOULUS (ex : pour appli, TOMCAT="app*")

while getopts ":a:h:" opt; do
    case "${opt}" in
        a) TOMCAT="${OPTARG}*";;
        h) USAGE;;
    esac
done

########################
##    PROGRAMME       ##
########################

# LISTING DU NOMBRE DE TOMCAT ETAT NOMINAL (OK+KO)
NBNOMINAL=$(service $TOMCAT status| grep "Active:" | wc -l)

# LISTING DU NOMBRE DE TOMCAT OK
NBOK=$(service $TOMCAT status| grep -i "active (running)" | wc -l)

# CONDITION POUR DETERMINER SI CHECK OK/KO
if [ $NBNOMINAL -eq $NBOK ]; then
    # CHECK OK
    # PASSAGE VARIABLE NBKO A 0
    NBKO="0"
    LISTEOK=$(service $TOMCAT status| grep -B2 -i "running" | grep ".service - " | sed 's/$/<br>/g' | sed ':a;N;$!ba;s/\n//g')
    # FORMATTAGE CONTENU NAGIOS
    statusReport="<font color="green"><b>TOMCAT OK</b></font><br>Nombre de TOMCAT OK : $NBOK <br>Nombre de TOMCAT KO : $NBKO<br><font color="green">TOMCAT OK : <br>$LISTEOK</font>"

else
    # CHECK KO
    # PASSAGE SEVERITE NAGIOS CRITICAL
    setSeverity 2
    # PASSAGE VARIABLE NBKO A LA BONNE VALEUR
    NBKO=$(($NBNOMINAL-$NBOK))
    # RECUPERATION DES NOMS TOMCATS KO
    LISTEKO=$(service $TOMCAT status| grep -B2 -v "running" | grep ".service - " | sed 's/$/<br>/g' | sed ':a;N;$!ba;s/\n//g')
    # FORMATTAGE CONTENU NAGIOS
    statusReport="<font color="red"><b>TOMCAT KO</b></font><br>Nombre de TOMCAT OK : $NBOK <br>Nombre de TOMCAT KO : $NBKO<br><font color="red"><b>TOMCAT KO : <br>$LISTEKO</b></font>"

fi

# AFFICHAGE DU CONTENU NAGIOS SI DEBUG
# decho "severityReport=${severityReport};statusReport=${statusReport}"

# AFFICHAGE RESULTAT CHECK
echo "${statusReport}"

# SORTIE DU SCRIPT AVEC SEVERITE NAGIOS
exit ${severityReport}

# FIN DE SCRIPT