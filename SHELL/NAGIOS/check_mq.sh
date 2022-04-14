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

# https://www.ibm.com/docs/en/ibm-mq/7.5?topic=reference-mqsc-commands
# https://www.ibm.com/docs/en/ibm-mq/7.5?topic=commands-display-qstatus
# https://www.ibm.com/docs/en/ibm-mq/7.5?topic=reference-building-command-scripts


# AGE : runmqsc | DISPLAY QSTATUS(name) MSGAGE | END
# POUR CALCUL % FILE : runmqsc | DISPLAY QUEUE(name) MAXDEPTH,CURDEPTH | END


# MQINFO de la file MQ
echo "\nMQINFO de la file queue \n"
su - mqm -c "MQINFO.exe <name_Queue>" > $ficLogOCB


# Récupération des valeurs (nb de message, nb de message max, taux)
echo "\nRECUPERATION DES VALEURS \n"
nbMess=`grep "Number of messages in queue" $ficLogOCB | sed 's/.* = (//g' | sed 's/).*//g'`
nbMax=`grep "Maximum number" $ficLogOCB | sed 's/.* = (//g' | sed 's/).*//g'`
tauxRemp=`grep "ratio" $ficLogOCB | sed 's/.* = (//g' | sed 's/).*//g'`


echo "dis chstatus(name)" | runmqsc

MQBROWSE.exe <name_QManager> <name_Queue> -a | grep -E "Send date|Send time|(CPNAME=)[A-Z0-9_]*"