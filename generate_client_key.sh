#! /bin/bash
# Simplewall All Rights Reserved
# Author: Chetan Muneshwar
sw_opvn_client_setup()
{
CLIENT_NAME=$1
rm -rf keys/$CLIENT_NAME.*
./build-key $CLIENT_NAME

touch keys/$CLIENT_NAME.window.ovpn
touch keys/$CLIENT_NAME.linux_mac.ovpn
touch keys/$CLIENT_NAME.passwd

cd keys/

vpn_ip="`sqlite /usr/local/apache2/htdocs/simplewall/systemcomponent/simplewall.s3db 'select eth1_address from tbl_device'|xargs`"
vpn_password="`sqlite /usr/local/apache2/htdocs/simplewall/systemcomponent/simplewall.s3db "select password from tbl_vpn_users where username='$CLIENT_NAME'"|xargs`"
vpn_ptrl="`sqlite /usr/local/apache2/htdocs/simplewall/systemcomponent/simplewall.s3db 'select protocol from tbl_vpn_settings;'|xargs`"
vpn_protocol="`echo $vpn_ptrl | tr '[:upper:]' '[:lower:]'`"
vpn_port="`sqlite /usr/local/apache2/htdocs/simplewall/systemcomponent/simplewall.s3db 'select port from tbl_vpn_settings;'|xargs`"
vpn_auth="`sqlite /usr/local/apache2/htdocs/simplewall/systemcomponent/simplewall.s3db 'select mode from tbl_vpn_auth;' |xargs`"


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

openvpn_cl="/usr/local/apache2/htdocs/simplewall/systemcomponent/openvpn/client_keys"
if [ -d $openvpn_cl ]  ; then 
 rsync -avz $CLIENT_NAME.zip /usr/local/apache2/htdocs/simplewall/systemcomponent/openvpn/client_keys/
else
 
 mkdir -p /usr/local/apache2/htdocs/simplewall/systemcomponent/openvpn/client_keys
 rsync -avz $CLIENT_NAME.zip /usr/local/apache2/htdocs/simplewall/systemcomponent/openvpn/client_keys/
fi
}

export KEY_CN=`od -vAn -N4 -tu4 < /dev/urandom |xargs`
sw_opvn_client_setup $1
