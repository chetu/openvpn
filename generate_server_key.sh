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
 cp -f keys/{ca.crt,ca.key,server.crt,server.key} /etc/openvpn/
 ./build-dh
 cp -f keys/dh1024.pem /etc/openvpn/ 
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

echo -e  "
export EASY_RSA="`pwd`"
export OPENSSL="openssl"
export PKCS11TOOL="pkcs11-tool"
export GREP="grep"
export KEY_CONFIG=`$EASY_RSA/whichopensslcnf $EASY_RSA`
export KEY_DIR="$EASY_RSA/keys"
export PKCS11_MODULE_PATH="dummy"
export PKCS11_PIN="dummy"
export KEY_SIZE=1024
export CA_EXPIRE=3650
export KEY_EXPIRE=3650

export KEY_COUNTRY="$country"
export KEY_PROVINCE="$state"
export KEY_CITY="$city"
export KEY_ORG="$org"
export KEY_EMAIL="$email"
export KEY_EMAIL=$email
export KEY_CN=$keycn
export KEY_NAME=$keyou
export KEY_OU=$keyou
#export PKCS11_MODULE_PATH=$pkcpath
#export PKCS11_PIN=$pkcpin
"
}
var_gen $1 $2 $3 $4 $5 $6 $7 >/etc/openvpn/easy-rsa/2.0/vars
sw_ovpn_server_setup

