# ssh-fwd-proxy

buy a vpc from vultr
then use this script to eable ssh fwd proxy via kcp

## in vpc, download server_linux_amd64 from https://github.com/xtaci/kcptun and run `chmod +x kcp-server.sh; setsid ./kcp-server.sh`

## modify ssh-proxy.sh, change HOST USER PASS by your vpc.

## in your own pc, dowload client_linux_amd64 from https://github.com/xtaci/kcptun and run `chmod +x ssh-proxy.sh; setsid ./ssh-proxy.sh`
