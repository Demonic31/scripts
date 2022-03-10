#!/bin/sh

# TITRE drive_online.sh
# DESCRIPTION : Script de vérification/passage ONLINE des drives TSM
# EXECUTION : TOUS LES JOURS A ??H VIA AWA - JOB
# HISTORIQUE :
# T |  Date      |  Auteur                      |  Description
#---+------------+------------------------------+------------------------------------
# A |  09/03/22  |  Demonic                     |  Création
# -----------------------------------------------------------------------------------

#########################################
##    DECLARATION DES VARIABLES        ##
#########################################

# IDENTIFIANTS TSM
IDTSM=""
MDPTSM=""
# STATUT DES DRIVES
STATUS=""
# LIBRAIRIE CORRSPONDANTE AU DRIVE A TRAITER
LIBRARY=""
# DRIVE A TRAITER
DRIVE=""

#########################################
##    DECLARATION DES FONCTIONS        ##
#########################################

# FONCTION PERMETTANT DE SIMPLIFIER L'EXECUTION DE LA COMMANDE ADMIN TSM DANS LE SCRIPT
tsmcmd(){
dsmadmc -id=$IDTSM -pa=$MDPTSM -datao=yes $*
return $?
}

########################
##    PROGRAMME       ##
########################

# LISTING DES STATUTS DES DRIVES
echo -e "\nLISTING DES STATUTS EN COURS...."

# EXECUTION D'UNE REQUETE DB2 POUR LISTER LES DRIVES A L'ETAT DIFFERENT DE ONLINE
STATUS="$(tsmcmd -commadelimited "SELECT library_name, drive_name FROM drives WHERE online != 'YES'" | sed -e 's/,/ /g')"

echo -e "\nLISTING OK"
# FIN DU LISTING

# CONDITION POUR REPASSER LES DRIVES ONLINE
# VERIFICATION SI LA VARIABLE STATUS COMPORTE LE CODE ERREUR ANR2034E, CELUI CI CORRESPONDANT A AUCUN DRIVE KO
if [[ "$STATUS" == *"ANR2034E SELECT: No match found using this criteria."* ]]; then

    # CONDITION OK : TOUS LES DRIVES SONT OK, LE CODE ERREUR EST BIEN AFFICHE DANS LA VARIABLE STATUS
    echo -e "\nTOUS LES DRIVES SONT ONLINE\n"

else

    # CONDITION KO : 1 OU PLUSIEURS DRIVES SONT KO, ILS SONT LISTE DANS LA VARIABLE STATUS
    # LISTING DES DRIVES KO
    echo -e "\nLISTE DES DRIVES KO :\n$STATUS\n\nRELANCE DES DRIVES...."

    # PASSAGE ONLINE DES DRIVES KO
    # LECTURE LIGNE PAR LIGNE DE LA VARIABLE STATUS POUR RELANCE. 1 LIGNE = 1 DRIVE. CF LISTING CI-DESSUS
    echo "$STATUS" | while read -r line; do

        # RECUPERATION DU 1ER CHAMP DE LA LIGNE, CORRESPONDANT A LA LIBRAIRIE DU DRIVE
        LIBRARY=$(echo "$line" | awk '{print $1}')
        # RECUPERATION DU 2EME CHAMP DE LA LIGNE, CORRESPONDANT AU DRIVE
        DRIVE=$(echo "$line" | awk '{print $2}')

        # PASSAGE ONLINE DU DRIVE
        echo -e "\nPASSAGE ONLINE DU $DRIVE DE LA LIBRAIRIE $LIBRARY\n"
        tsmcmd update drive $LIBRARY $DRIVE online=yes
        echo -e "UPDATE EN COURS\n"

        # FIN DE LA BOUCLE
    done
    # FIN DE LA CONDITION
fi

# FIN DE SCRIPT