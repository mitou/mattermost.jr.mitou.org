#!/bin/bash
if [ ${ENVRC_LOADED} = "OK" ];then 
    envsubst < ./mattermost.json >config.json
    gcloud kms encrypt --location asia-northeast1 --keyring primary-keyring  --key primary-key --plaintext-file config.json --ciphertext-file config.json.encrypted
    ENCRYPTED=$(cat ./config.json.encrypted|base64)
    cat secret-configs.yml.template | sed "s|__ENCRYPTED__|${ENCRYPTED}|" > ../kubernetes/mattermost/secret-configs.yml

    rm config.json
    rm config.json.encrypted
else
    echo "env variables seems not to be loaded. Are you using direnv?"
fi