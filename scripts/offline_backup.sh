#!/bin/bash
rsync -avz -e "ssh -p22345" /etc r0838338@leia.uclllabs.be:/home/LDAP/r0838338/SaSM_backup
