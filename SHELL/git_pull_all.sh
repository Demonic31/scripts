#!/bin/bash
# TITRE : git_pull_all.sh
# DESCRIPTION : Mise à jour via 'git pull' de tous les repos de la machine local
# USAGE : Lancer le script avec Git Bash
# HISTORIQUE :
# T |  Date      |  Auteur                      |  Description
#---+------------+------------------------------+------------------------------------
# A |  23/02/24  |  Demonic                     |  Création
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
        ##################
        #  MAJ REPO GIT  #
        ##################
        \E[0m
Script directory: $SCRIPT_DIR
GIT directory: $GIT_DIR
"

# BOUCLE CHERCHANT TOUS LES .git ET LANCE UN 'git pull'
for i in $GIT_DIR*/.git
do
    (
        REPO=$(echo $i | cut -d'/' -f 6)
        echo -e "\n\E[1;36mMAJ DU REPO $REPO\E[0m\n"
        cd $i/..
        git pull
    )
done

# AFFICHAGE DE LA FIN DE LA MAJ
echo -e "\n\E[1;32m

        ##  MAJ DES REPOS TERMINEE  ##

\E[0m
Fermeture automatique dans 5 secondes"

# TEMPO 5S AVANT SORTIE
sleep 5