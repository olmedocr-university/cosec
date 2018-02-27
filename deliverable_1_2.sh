#!/bin/bash

MYIP=163.117.244.97
IPFROMADMIN=163.117.221.151

# Update headers to install openssh
sudo apt-get update
# Install openssh in order to allow ssh connections into the server
sudo apt-get install openssh-server openssh-client -y 

# Change firewall default policy to drop all incoming packets
sudo iptables -P INPUT DROP

#Enable input packets in loopback interface (apache - mysql use it)
sudo iptables -A INPUT -i lo -j ACCEPT

#Accept only ssh connections from the admin's ip
sudo iptables -A INPUT -p tcp -d $MYIP --dport ssh -s $IPFROMADMIN  -j ACCEPT 

# Accept al incoming connections to apache-tomcat
sudo iptables -A INPUT -p tcp -d $MYIP --dport http -j ACCEPT
 
############################ NOT WORKING ############################

# acepta todas las conexiones entrantes que ya hayan sido establecidas o relacionadas con una peticon DNS
sudo iptables -A INPUT -p udp -d $MYIP --sport domain -m state --state RELATED,ESTABLISHED -j ACCEPT 
sudo iptables -A INPUT -p tcp -d $MYIP --sport domain -m state --state RELATED,ESTABLISHED -j ACCEPT 

# acepta todas las conexiones entrantes que ya hayan sido establecidas o relacionadas con una peticion saliente del puerto HTTP del origen (por ejemplo cuando se ejecuta apt-get update)
sudo iptables -A INPUT -p tcp -d $MYIP --sport http -m state --state RELATED,ESTABLISHED -j ACCEPT 

############################## WORKING ##############################

