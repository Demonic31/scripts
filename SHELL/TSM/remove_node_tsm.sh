#!/bin/sh

# TITRE remove_node_tsm.sh
# DESCRIPTION :
# HISTORIQUE :
# T |  Date      |  Auteur                      |  Description
#---+------------+------------------------------+------------------------------------
# A |  14/04/22  |  Demonic                     |  Création
# -----------------------------------------------------------------------------------

# LOGGING
# exec > ./log/remove_node_tsm.log 2>&1

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

for node in $(cat $LIST)
do
wait 5s
        echo " "
        echo "****************************************"
        echo "`date '+%d_%m_%Y'` à `date '+%H:%M:%S'`"
        echo "remove filespace + node for $node"
        echo "****************************************"

        tsmcmd del fi $node *
        tsmcmd remove node $node
        CR=$?

done

tsmcmd update admin admin sessionsec=trans