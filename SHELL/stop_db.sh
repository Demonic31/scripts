#!/bin/bash
# TITRE : stop_db.sh
# DESCRIPTION : Vérification statut et arrêt base de donnée Oracle
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
STATUT_PS=$(ps -ef | grep pmon_$ORACLE_SID | grep -vc grep)

# SELON LE STATUT DE LA BASE PASSAGE DE LA VARIABLE STATUT A UP / DOWN
case $STATUT_PS in
    0) STATUT="DOWN";;
    1) STATUT="UP";;
esac

# CONDITION POUR ARRET/DEMARRAGE INSTANCE
if [[ $STATUT != "DOWN" ]] 
then
    echo "shutdown immediate" | sqlplus / as sysdba
else
    echo -e "La base $ORACLE_SID est déjà à l'état DOWN"
fi