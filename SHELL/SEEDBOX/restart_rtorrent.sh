#!/bin/bash

while getopts ":u:" opt; do
    case "${opt}" in
        u) user="${OPTARG}";;
    esac
done

# EXTRACTION DU PID DE RTORRENT DU USER
pid=$(ps -u $user -o pid,command | grep '[0-9] rtorrent$' | cut -d "r" -f1)

kill -9 $pid
/root/rtorrent-check