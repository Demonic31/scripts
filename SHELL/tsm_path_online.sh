#!/bin/sh

# TITRE path_online.sh
# DESCRIPTION : Script de vérification/passage ONLINE des paths TSM
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
# STATUT DES PATHS
STATUS=""
# SOURCE DU PATH A TRAITER - SRV TSM
SOURCE=""
# DESTINATION DU PATH A TRAITER - DRIVE
DESTINATION=""
# LIBRAIRIE CORRSPONDANTE AU PATH A TRAITER
LIBRARY=""

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

# LISTING DES STATUTS DES PATHS
echo -e "\nLISTING DES STATUTS EN COURS...."

# EXECUTION D'UNE REQUETE DB2 POUR LISTER LES PATHS A L'ETAT DIFFERENT DE ONLINE
STATUS="$(tsmcmd -commadelimited "SELECT source_name, destination_name, library_name FROM paths WHERE online != 'YES'" | sed -e 's/,/ /g')"

echo -e "\nLISTING OK"
# FIN DU LISTING

# CONDITION POUR REPASSER LES PATHS ONLINE
# VERIFICATION SI LA VARIABLE STATUS COMPORTE LE CODE ERREUR ANR2034E, CELUI CI CORRESPONDANT A AUCUN PATHS KO
if [[ "$STATUS" == *"ANR2034E SELECT: No match found using this criteria."* ]]; then

    # CONDITION OK : TOUS LES PATHS SONT OK, LE CODE ERREUR EST BIEN AFFICHE DANS LA VARIABLE STATUS
    echo -e "\nTOUS LES PATHS SONT ONLINE\n"

else

    # CONDITION KO : 1 OU PLUSIEURS PATHS SONT KO, ILS SONT LISTES DANS LA VARIABLE STATUS
    # LISTING DES PATHS KO
    echo -e "\nLISTE DES PATHS KO :\n$STATUS\n\nRELANCE DES PATHS...."

    # PASSAGE ONLINE DES PATHS KO
    # LECTURE LIGNE PAR LIGNE DE LA VARIABLE STATUS POUR RELANCE. 1 LIGNE = 1 PATH. CF LISTING CI-DESSUS
    echo "$STATUS" | while read -r line; do

        # RECUPERATION DU 1ER CHAMP DE LA LIGNE, CORRESPONDANT A LA LIBRAIRIE DU DRIVE
        SOURCE=$(echo "$line" | awk '{print $1}')
        # RECUPERATION DU 2EME CHAMP DE LA LIGNE, CORRESPONDANT AU DRIVE
        DESTINATION=$(echo "$line" | awk '{print $2}')
        # RECUPERATION DU 2EME CHAMP DE LA LIGNE, CORRESPONDANT AU DRIVE
        LIBRARY=$(echo "$line" | awk '{print $3}')

        # PASSAGE ONLINE DU DRIVE
        echo -e "\nPASSAGE ONLINE DU PATH $SOURCE => $DESTINATION DE LA LIBRAIRIE $LIBRARY\n"
        tsmcmd update path $SOURCE $DESTINATION srctype=server desttype=drive library=$LIBRARY online=yes
        echo -e "UPDATE EN COURS\n"

        # FIN DE LA BOUCLE
    done
    # FIN DE LA CONDITION
fi

# FIN DE SCRIPT