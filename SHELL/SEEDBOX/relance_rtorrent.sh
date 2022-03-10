#!/bin/bash

# A MODIFIER AVEC LES USERS SOUHAITES
users=(stan thomas audrey mickael guenot denis) 

for user in ${users[@]}; do
    # A ADAPTER AU BESOIN
    file=/home/$user/.session/rtorrent.lock 

    # EXTRACTION DU PID DE RTORRENT DU USER
    pid=$(ps -u $user -o pid,command | grep '[0-9] rtorrent$' | cut -d "r" -f1)

    # SI RTORRENT EST ACTIF LE PID NE SERA PAS VIDE
    if [ ! $pid ];then
        # ON SUPPRIME rtorrent.lock CAR CA EMPECHE RTORRENT DE DEMARRER
        rm -f $file
        # RESTART RTORRENT USER
        bash /etc/init.d/$user-rtorrent restart
        # LOG
        echo "$(date) : le rtorrent de $user a ete redemarre" >> /var/log/rtorrent-check.log
    fi
done