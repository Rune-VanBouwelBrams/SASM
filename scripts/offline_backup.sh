#!/bin/bash

username="r0838338"
remote_server="leia.uclllabs.be"
ssh_port="22345"

rsync -avz -e "ssh -p $ssh_port" /etc/ "$username@$remote_server:/home/LDAP/r0838338/SaSM_backup"
