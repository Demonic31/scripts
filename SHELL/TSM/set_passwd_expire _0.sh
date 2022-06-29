#!/bin/sh

# TITRE set_passwd_expire_0.sh
# DESCRIPTION : Passage de l'expiration du mot de passe des nodes à 0
# HISTORIQUE :
# T |  Date      |  Auteur                      |  Description
#---+------------+------------------------------+------------------------------------
# A |  29/06/22  |  Demonic                     |  Création
# -----------------------------------------------------------------------------------

# LOGGING
# exec > ./log/set_passwd_expire_0_tsm.log 2>&1

#########################################
##    DECLARATION DES VARIABLES        ##
#########################################

_HOME_PATH="$(cd $(dirname $0) && pwd)"
_SCRIPT_PATH="$_HOME_PATH/$(basename $0)"

LIST="$_HOME_PATH/listnode.txt"

. $_HOME_PATH/environment

#########################################
##        DEFINITION FONCTIONS         ##
#########################################

tsmcmd(){
dsmadmc -id=$ID -pa=$PASSWD -datao=yes $*
return $?
}

#########################################
##         PROGRAMME PRINCIPAL         ##
#########################################

#while read node
for node in $(cat $LIST)
do
wait 5s
        echo " "
        echo "****************************************"
        echo "`date '+%d_%m_%Y'` à `date '+%H:%M:%S'`"
        echo "pass exp to 0 for  $node"
        echo "****************************************"

        tsmcmd set passexp 0 node=$node
        CR=$?

done

tsmcmd update admin admin sessionsec=trans