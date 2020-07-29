#!/bin/bash
#cp ./binary_mac/* .
export FABRIC_CFG_PATH=$PWD

chmod +x generate-certs

sh ./generate-certs.sh

chmod +x docker-images
sh ./docker-images.sh
docker-compose up -d

