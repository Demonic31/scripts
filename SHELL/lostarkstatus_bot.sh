#!/bin/sh

curl -X 'GET' 'http://lostarkchc.herokuapp.com/server/Calvasus' -H 'accept: application/json' > /tmp/lostark/calvasus.json
curl -X 'GET' 'https://lostarkchc.herokuapp.com/steam/playercount' -H 'accept: application/json' > /tmp/lostark/playercount.json
#curl -X 'GET' 'http://lostarkchc.herokuapp.com/server/all' -H 'accept: application/json' > /tmp/lostark/all.json

SERVER_CALVASUS=$(cat /tmp/lostark/calvasus.json | sed -e 's/{"status":200,"data":{"//g' -e 's/":".*/\n/g')
STATUS_CALVASUS=$(cat /tmp/lostark/calvasus.json | sed -e 's/{"status":200,"data":{"Calvasus":"//g' -e 's/"}}/\n/g')

PLAYERCOUNT=$(cat /tmp/lostark/playercount.json | sed -e 's/{"status":200,"data":{"player_count"://g' -e 's/}}/\n/g')

/home/debian/discordbot/discord.sh \
  --title "Lost Ark Server Status" \
  --color "0xFF8C00" \
  --url "https://www.playlostark.com/fr-fr/support/server-status" \
  --thumbnail "https://i.imgur.com/nOWkOD7.png" \
  --field "Serveur;$SERVER_CALVASUS" \
  --field "Statut;$STATUS_CALVASUS" \
  --field "Nombre de joueurs IG;$PLAYERCOUNT;false" \
  --footer "Demonic#3116" \
  --timestamp
