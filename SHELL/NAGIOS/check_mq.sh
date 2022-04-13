#!/bin/sh

# TITRE check_mq.sh
# DESCRIPTION : Script de check MQ pour centreon
# USAGE : lancement du script en ajoutant les arguments **
# HISTORIQUE :
# T |  Date      |  Auteur                      |  Description
#---+------------+------------------------------+------------------------------------
# A |  13/04/22  |  Demonic/Polaris             |  Création
# -----------------------------------------------------------------------------------


#########################################
##    DECLARATION DES VARIABLES        ##
#########################################

# INITIALISATION DESCRIPTION ALERTE NAGIOS
statusReport=""
# INITIALISATION SEVERITE ALERTE NAGIOS (OK PAR DEFAUT)
severityReport=0

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