Copy easy-rsa  folder to /etc/openvpn


cp -R /usr/share/doc/openvpn-2.x.x/easy-rsa/ /etc/openvpn/


next copy shell script from git 

generate_server_key.sh : it is used for making server key of openssl server 
	script is used for perfect key and dh key setup , repeated run clear all client keys and other server side key of previous run 


generate_client_key.sh :used for adding unlimited client keys for openvpn tls client 





