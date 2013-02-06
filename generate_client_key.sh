#! /bin/bash
# All Rights Reserved
# Author: Chetan Muneshwar
# Free to use. No garranty. Not responsible for side effects.
sw_opvn_client_setup()
{
CLIENT_NAME=$1
rm -rf keys/$CLIENT_NAME.*
./build-key-pass $CLIENT_NAME

touch keys/$CLIENT_NAME.window.ovpn
touch keys/$CLIENT_NAME.linux_mac.ovpn
touch keys/$CLIENT_NAME.passwd

cd keys/

vpn_ip=""
vpn_password=""
vpn_ptrl=""
vpn_protocol=""
vpn_port=""
vpn_auth=""


echo -e "$CLIENT_NAME" >$CLIENT_NAME.passwd
echo -e "$vpn_password" >>$CLIENT_NAME.passwd


echo -e "# simplewall openvpn key" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "script-security 3" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "client" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "dev tun" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "proto $vpn_protocol " >>$CLIENT_NAME.linux_mac.ovpn
echo -e "remote $vpn_ip $vpn_port " >>$CLIENT_NAME.linux_mac.ovpn
echo -e "resolv-retry infinite " >>$CLIENT_NAME.linux_mac.ovpn
echo -e "nobind" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "keepalive 10 60" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "ping-timer-rem" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "tun-mtu 1500" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "tun-mtu-extra 32 1500" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "mssfix 1450" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "persist-key" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "persist-tun" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "ca ca.crt" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "#user nobody" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "#group nobody" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "cert $CLIENT_NAME.crt" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "key $CLIENT_NAME.key" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "comp-lzo" >>$CLIENT_NAME.linux_mac.ovpn
echo -e "auth-nocache" >>$CLIENT_NAME.linux_mac.ovpn


echo -e "# simplewall openvpn key" >>$CLIENT_NAME.window.ovpn
echo -e "script-security 3" >>$CLIENT_NAME.window.ovpn
echo -e "client" >>$CLIENT_NAME.window.ovpn
echo -e "dev tun" >>$CLIENT_NAME.window.ovpn
echo -e "proto $vpn_protocol " >>$CLIENT_NAME.window.ovpn
echo -e "remote $vpn_ip $vpn_port " >>$CLIENT_NAME.window.ovpn
echo -e "resolv-retry infinite " >>$CLIENT_NAME.window.ovpn
echo -e "nobind" >>$CLIENT_NAME.window.ovpn
echo -e "tun-mtu 1500" >>$CLIENT_NAME.window.ovpn
echo -e "tun-mtu-extra 32 1500" >>$CLIENT_NAME.window.ovpn
echo -e "mssfix 1450" >>$CLIENT_NAME.window.ovpn
echo -e "persist-key" >>$CLIENT_NAME.window.ovpn
echo -e "persist-tun" >>$CLIENT_NAME.window.ovpn
echo -e "ca ca.crt" >>$CLIENT_NAME.window.ovpn
echo -e "cert $CLIENT_NAME.crt" >>$CLIENT_NAME.window.ovpn
echo -e "key $CLIENT_NAME.key" >>$CLIENT_NAME.window.ovpn
echo -e "comp-lzo" >>$CLIENT_NAME.window.ovpn
echo -e "auth-nocache" >>$CLIENT_NAME.window.ovpn

if [ "$vpn_auth" == "3" ] ; then
 echo -e "auth-user-pass" >>$CLIENT_NAME.window.ovpn
 echo -e "auth-user-pass" >>$CLIENT_NAME.linux_mac.ovpn
 zip $CLIENT_NAME.zip $CLIENT_NAME.window.ovpn $CLIENT_NAME.linux_mac.ovpn ca.crt $CLIENT_NAME.crt $CLIENT_NAME.key CLIENT.README 
else
 echo -e "auth-user-pass $CLIENT_NAME.passwd " >>$CLIENT_NAME.window.ovpn
 echo -e "auth-user-pass $CLIENT_NAME.passwd " >>$CLIENT_NAME.linux_mac.ovpn
 zip $CLIENT_NAME.zip $CLIENT_NAME.window.ovpn $CLIENT_NAME.linux_mac.ovpn ca.crt $CLIENT_NAME.crt $CLIENT_NAME.key CLIENT.README $CLIENT_NAME.passwd
fi

openvpn_cl="/etc/openvpn/cl_keys"
if [ -d $openvpn_cl ]  ; then 
 rsync -avz $CLIENT_NAME.zip /etc/openvpn/cl_keys
else
 
 mkdir -p /etc/openvpn/cl_keys
 rsync -avz $CLIENT_NAME.zip /etc/openvpn/cl_keys
fi
}

export KEY_CN=`od -vAn -N4 -tu4 < /dev/urandom |xargs`
if [ $# -lt 2 ] ; then
	echo "Usage need two arguments clientname clientpasswd"
else
	sw_opvn_client_setup $1
	echo "Please enter client passwd again"
	read clientpasswd
	
	vpn_password=$clientpasswd
fi

