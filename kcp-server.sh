#!/usr/bin/bash

# https://github.com/xtaci/kcptun.git
# download server_linux_amd64 for linux
# run this script with setsid

logfile=`pwd`/kcp_server.log
kcp_rhost="127.0.0.1"
kcp_rport="22"
local_port="4000"

for ((;;))
do 
    ./server_linux_amd64 -t "$kcp_rhost:$kcp_rport" -l ":$local_port" -mode fast3 -nocomp -sockbuf 16777217 -dscp 46 >> $logfile 2>&1
    echo "kcp_server failed, try again 1s later" >> $logfile

    sleep 1
done