#!/usr/bin/bash

cd ansible_collections
git clone -b junos_pmtu https://github.com/Vovilla/junipernetworks.junos
git clone -b ios_pmtu https://github.com/Vovilla/cisco.ios.git
# git clone https://github.com/ansible/ansible-jupyter-kernel.git
cd ..

if [ "$#" -eq  "0" ]
then  
    docker build -t netops:latest .
else   
    docker build -t netops:$1 .
fi