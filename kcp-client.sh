#!/usr/bin/bash

# https://github.com/xtaci/kcptun.git
# download client_linux_amd64 for linux

rhost=$1
rport=$2
lport=$3

id=`ps -ef| grep "client_linux_amd64 -r $rhost:$rport -l :$lport" | grep -v grep | awk '{print $2}'`
if [[ $id > 0 ]]; then
    echo `date +"%Y/%m/%d %H:%m:%S"` "kill old kcp client_linux_amd64 $id"
    kill $id
fi

./client_linux_amd64 -r "$rhost:$rport" -l ":$lport" -mode fast3 -nocomp -autoexpire 900 -sockbuf 167772170 -dscp 46
