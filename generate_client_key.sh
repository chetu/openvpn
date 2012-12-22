#! /bin/bash

sw_opvn_client_setup()
{
CLIENT_NAME=$1
source ./vars
rm -rf keys/$CLIENT_NAME.*
./build-key $CLIENT_NAME
cd keys/
zip $CLIENT_NAME.zip ca.crt ca.key $CLIENT_NAME.crt $CLIENT_NAME.csr $CLIENT_NAME.key
#cp $CLIENT_NAME.zip /usr/local/apache2/htdocs/simplewall/systemcomponent/openvpn/client_kyes/
cp $CLIENT_NAME.zip /etc/openvpn/Client_key_to_distribute
}
var_gen()
{

# ./sw_ovpn_client_keygen.sh KKK IN MS PUNE SW SW@sw.com  SW SW
country=$2
state=$3
city=$4
org=$5
email=$6
keycn=$7
keyou=$8

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
"
}
var_gen  $2 $3 $4 $5 $6 $7 $8 >/etc/openvpn/easy-rsa/2.0/vars


sw_opvn_client_setup $1

