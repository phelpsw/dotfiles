#!/bin/bash

ENCRYPTED_CREDS=~/.config/vpncreds.txt.gpg
CRED_PATH=/etc/openvpn/creds/vpncreds.txt

gpg --output $CRED_PATH --decrypt $ENCRYPTED_CREDS
rc=$?; if [[ $rc != 0 ]]; then
    echo "failed to decrypt vpn credentials"
    exit $rc;
fi

sudo timeout 60 systemctl stop openvpn-client@netflix.service
rc=$?; if [[ $rc != 0 ]]; then
    echo "vpn failed to connect"
fi

rm $CRED_PATH
rc=$?; if [[ $rc != 0 ]]; then
    echo "WARNING: failed to delete plain text vpn creds"
    exit $rc;
fi
