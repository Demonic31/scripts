#!/bin/ksh

# TITRE check_nbproc.sh
# DESCRIPTION : Script de check du nombre de processus
# USAGE : lancement du script en ajoutant l'argument -p <nom du processus> -c <nombre de processus voulu>
# HISTORIQUE :
# T |  Date      |  Auteur                      |  Description
#---+------------+------------------------------+------------------------------------
# A |  16/07/21  |  Demonic                     |  Création
# -----------------------------------------------------------------------------------


#########################################
##    DECLARATION DES VARIABLES        ##
#########################################

# INITIALISATION DESCRIPTION ALERTE NAGIOS
statusReport=""
# INITIALISATION SEVERITE ALERTE NAGIOS (OK PAR DEFAUT)
severityReport=0
# INITIALISATION VARIABLE DU NOM DU PROCESSUS
NOMPROC=""
# INITIALISATION VARIABLE DU NOMBRE TOTAL DE PROCESSUS VOULU
NBOK=""
# INITIALISATION VARIABLE DU NOMBRE TOTAL DE PROCESSUS PRESENT
NBPROC=""

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
        2) severityReport=2;;
    esac
}

# FONCTION USAGE (option -h)
USAGE(){
        echo "Ce script permet de vérifier le nombre de processus actifs pour un processus donné et renvoyer une alerte via Nagios si moins/plus de processus"
        echo "USAGE : check_nbproc.sh -p <processus> -c <nb_de process_voulus>"
        exit 0
}

#########################################
##    RECUPERATION DES ARGUMENTS       ##
#########################################

# ARGUMENT -p : NOM DU PROCESSUS
# ARGUMENT -c : NOMBRE DE PROCESS VOULU
# ARGUMENT -h : USAGE

while getopts ":p:c:h:" opt; do
    case "${opt}" in
        p) NOMPROC="${OPTARG}";;
        c) NBOK="${OPTARG}";;
        h) USAGE;;
    esac
done

########################
##    PROGRAMME       ##
########################

# LISTING DU NOMBRE DE PROCESSUS
NBPROC=$(ps -ef | grep -i "$NOMPROC" | grep -v grep | grep -v "check_" | wc -l)

# CONDITION POUR DETERMINER SI CHECK OK/KO
if [ $NBPROC -eq $NBOK ]; then
    # CHECK OK
    # FORMATTAGE CONTENU NAGIOS
    statusReport="<font color="green"><b>Nombre de processus $NOMPROC OK</b></font>"

else
    # CHECK KO
    # PASSAGE SEVERITE NAGIOS CRITICAL
    setSeverity 2
    # FORMATTAGE CONTENU NAGIOS
    statusReport="<font color="red"><b>Nombre de processus $NOMPROC KO | $NBPROC OK pour $NBOK voulu<i> Processus KO de 23h à 7h, ne pas prendre en compte dans cette période.</i></b></font>"

fi

# AFFICHAGE DU CONTENU NAGIOS SI DEBUG
# decho "severityReport=${severityReport};statusReport=${statusReport}"

# AFFICHAGE RESULTAT CHECK
echo "${statusReport}"

# SORTIE DU SCRIPT AVEC SEVERITE NAGIOS
exit ${severityReport}

# FIN DE SCRIPT
