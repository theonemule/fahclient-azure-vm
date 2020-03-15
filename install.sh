#!/bin/bash

apt update
apt install -y ubuntu-drivers-common

export DEBIAN_FRONTEND=noninteractive 
export DEBCONF_NONINTERACTIVE_SEEN=true

ubuntu-drivers devices
ubuntu-drivers autoinstall 	

# defaults 
USER="anonymous"
PASSKEY=""
TEAM="0"


for i in "$@"
do
	case $i in
		--user=*)
		USER="${i#*=}"
		;;
		--passkey=*)
		PASSKEY="${i#*=}"
		;;
		--team=*)
		TEAM="${i#*=}"
		;;
		--password=*)
		PASSWORD="${i#*=}"
		;;
		*)
		;;
	esac
done

echo "fahclient       fahclient/user  string  $USER
fahclient       fahclient/autostart     boolean true
fahclient       fahclient/power select  full
fahclient       fahclient/passkey       string $PASSKEY
fahclient       fahclient/team  string  $TEAM" > ~/conf.txt

debconf-set-selections ~/conf.txt

wget https://download.foldingathome.org/releases/public/release/fahclient/debian-testing-64bit/v7.4/fahclient_7.4.4_amd64.deb

sudo dpkg -i --force-depends fahclient_7.4.4_amd64.deb

echo "<config>
  <user value='$USER'/> 
  <team value='$TEAM'/>    
  <passkey value='$PASSKEY'/>  
  <power value='full'/>
  <gpu value='true'/>
  <fold-anon value='true'/>
  <allow v='127.0.0.1 0.0.0.0/0  0/0'/>
  <password>$PASSWORD</password>
  <web-allow v='127.0.0.1 0.0.0.0/0 0/0'/>
</config>" > /etc/fahclient/config.xml
