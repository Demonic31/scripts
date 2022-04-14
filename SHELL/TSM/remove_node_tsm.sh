#!/bin/sh

tsmcmd(){
dsmadmc -id=script -pa=scripttsm -datao=yes $*
return $?
}

pwd=$(pwd)
list="$pwd/listnode.txt"

for node in $(cat $list)
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