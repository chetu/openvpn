#! /bin/bash
# ./var_gen.sh IN MS PUNE MYCOMPANY admin@MYCOMPANY.com admin@MYCOMPANY.com MYCOMPANY-OU 
# $1 = CONUTRY
# $2 = STATE
# $3 = CITY
# $4 = COMPANY
# $5 = Email
# $6 = EMAIL
# $7 = Commonname

if [ $# -lt 7 ] ; then
      echo "Need Option Variables
 CONUTRY
 STATE
 CITY
 COMPANY
 Email
 EMAIL
 Commonname 

i.e

sh var_gen.sh IN MS PUNE MYCOMPANY admin@MYCOMPANY.com admin@MYCOMPANY.com MYCOMPANY-OU 


"

      exit 0
fi

sw_ovpn_server_setup()
{
 cd /etc/openvpn/easy-rsa/2.0/
 chmod +rwx *
 ./clean-all  
 source ./vars
 ./build-ca
 ./build-key-server server
 cp -f /etc/openvpn/easy-rsa/2.0/keys/{ca.crt,ca.key,server.crt,server.key} /etc/openvpn/
 ./build-dh
 cp -f /etc/openvpn/easy-rsa/2.0/keys/dh1024.pem /etc/openvpn/ 
 /etc/init.d/openvpn restart
}

var_gen()
{
country=$1
state=$2
city=$3
org=$4
email=$5
keycn=$6
keyou=$7
pkcpath=$8
pkcpin=$9

echo   "
#! /bin/bash
export OPENSSL="/usr/bin/openssl"
export PKCS11TOOL="pkcs11-tool"
export GREP="grep"
export KEY_CONFIG="/etc/openvpn/easy-rsa/2.0/openssl-0.9.8.cnf"
export KEY_DIR="/etc/openvpn/easy-rsa/2.0/keys"
export PKCS11_MODULE_PATH="dummy"
export PKCS11_PIN="dummy"
export KEY_SIZE=1024
export CA_EXPIRE=365
export KEY_EXPIRE=365 

export KEY_COUNTRY="$country"
export KEY_PROVINCE="$state"
export KEY_CITY="$city"
export KEY_ORG="$org"
export KEY_EMAIL="$email"
export KEY_CN=`od -vAn -N4 -tu4 < /dev/urandom |xargs`
export KEY_NAME="$keyou-simplewall"
export KEY_OU=$keyou
#export PKCS11_MODULE_PATH=$pkcpath
#export PKCS11_PIN=$pkcpin
"
}

var_gen $1 $2 $3 $4 $5 $6 $7 >/etc/openvpn/easy-rsa/2.0/vars
sw_ovpn_server_setup
