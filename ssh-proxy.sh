#!/usr/bin/bash

#run this script with setsid

use_kcp="yes"

logfile=`pwd`/ssh-fwd-proxy.log
rhost="$HOST"
kcp_rport="4000"
kcp_lport="8388"

sock_proxy_lport="8080"

ssh_username="$USER"
ssh_passwd="$PASS"

echot() {
	echo `date +"%Y/%m/%d %H:%m:%S"` $1 >> $2
}

init() {
	# kill old ssh
	id=`ps -ef | grep "ssh -C -g -D" | grep -v grep | awk '{print $2}'`
	if [[ $id > 0 ]]; then
		echot "kill old ssh forward $id" $logfile
		kill $id
	fi

	if [[ $use_kcp == "yes" ]]; then
		# kill old kcp client proxy
		id=`ps -ef | grep ./kcp-client.sh | grep -v grep | awk '{print $2}'`
		if [[ $id > 0 ]]; then
			echot "kill old kcp-client.sh $id"  $logfile
			kill $id
		fi

		echot "restart kcp-client.sh" $logfile
		bash ./kcp-client.sh $rhost $kcp_rport $kcp_lport >> $logfile 2>&1 &
		if [[ $? != 0 ]]; then
			echot "start kcp client failed, will exit"  $logfile
			return -1
		fi
		sleep 1
	fi
	return 0
}


for((;;))
do
	if init; then
		echot "star ssh fwd " $logfile
		if [[ $use_kcp == "yes" ]]; then
			echot "use kcp" $logfile
			/usr/bin/expect ./ssh-proxy.exp $ssh_username 127.0.0.1 $kcp_lport $ssh_passwd $sock_proxy_lport >> $logfile 2>&1
		else
			echot "not use kcp" $logfile
			/usr/bin/expect ./ssh-proxy.exp $ssh_username $rhost 22 $ssh_passwd  $sock_proxy_lport >> $logfile 2>&1
		fi
		echot "ssh fwd failed, tye again 3s later" $logfile
	else
		echot "init failed, try again 3s later"  $logfile
	fi

	sleep 3
done
