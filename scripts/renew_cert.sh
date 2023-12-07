#!bin/bash

/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt_test

certbot --staging --apache -d "rune-vanbouwelbrams.sasm.uclllabs.be, secure.rune-vanbouwelbrams.sasm.uclllabs.be, supersecure.rune-vanbouwelbrams.sasm.uclllabs.be"

systemctl restart apache2
