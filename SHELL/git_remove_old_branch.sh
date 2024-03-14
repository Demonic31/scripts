#!/bin/bash
# TITRE : git_remove_old_branch.sh
# DESCRIPTION : Suppression des branches locales non existantes sur le repo distant
# USAGE : Lancer le script avec Git Bash
# HISTORIQUE :
# T |  Date      |  Auteur                      |  Description
#---+------------+------------------------------+------------------------------------
# A |  06/03/24  |  Demonic                     |  Création
# -----------------------------------------------------------------------------------

# DEBUG : DECOMMENTER LA LIGNE SUIVANTE POUR ACTIVER LE MODE DEBUG
#set -x

###############
#  VARIABLES  #
###############

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
GIT_DIR=$(echo $SCRIPT_DIR | sed 's/Boite_a_outils.*//g')

###############
#  PROGRAMME  #
###############

# AFFICHAGE DEBUT SCRIPT
echo -e "\E[1;32m
        ##############################
        #  SUPPRESSION BRANCHES GIT  #
        ##############################
        \E[0m
Script directory: $SCRIPT_DIR
GIT directory: $GIT_DIR
"

# BOUCLE CHERCHANT TOUS LES .git ET SUPPRIME LES BRANCHES
for git in $GIT_DIR*/.git
do
    (
    REPO=$(echo $git | cut -d'/' -f 6)
    echo -e "\n\E[1;36mSUPPRESSION DES BRANCHES DU REPO $REPO\E[0m\n"
    cd $git/..
    for branch in $(git fetch -p; git branch -vv | grep ': gone]' | awk '{print $1}')
    do
        git branch -D $branch
    done
    )
done

# AFFICHAGE DE LA FIN DE LA SUPPRESSION
echo -e "\E[1;32m

        ##  SUPPRESSION DES BRANCHES TERMINEE  ##

\E[0m
Fermeture automatique dans 5 secondes"

# TEMPO 5S AVANT SORTIE
sleep 5