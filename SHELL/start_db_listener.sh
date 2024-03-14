#!/bin/bash
# TITRE : start_db_listener.sh
# DESCRIPTION : Vérification statut et démarrage listener base de donnée Oracle
# USAGE : N/A
# HISTORIQUE :
# T |  Date      |  Auteur                      |  Description
#---+------------+------------------------------+------------------------------------
# A |  03/01/24  |  Demonic                     |  Création
# -----------------------------------------------------------------------------------

# DEBUG : DECOMMENTER LA LIGNE SUIVANTE POUR ACTIVER LE MODE DEBUG
#set -x

###############
#  VARIABLES  #
###############

#INSTANCE=$ORACLE_SID # INDIQUER LE NOM DE L'INSTANCE

###############
#  PROGRAMME  #
###############

# VERIFICATION ETAT DE LA BASE (UP / DOWN). Si retour 1 alors base UP, si retour 0 alors base DOWN 
STATUT_PS=$(ps -ef | grep LISTENER | grep -vc grep)

# SELON LE STATUT DE LA BASE PASSAGE DE LA VARIABLE STATUT A UP / DOWN
case $STATUT_PS in
    0) STATUT="DOWN";;
    1) STATUT="UP";;
esac

# CONDITION POUR ARRET/DEMARRAGE INSTANCE
if [[ $STATUT != "UP" ]] 
then
    lsnrctl start LISTENER
else
    echo -e "Le listener de la base $ORACLE_SID est déjà à l'état UP"
fi