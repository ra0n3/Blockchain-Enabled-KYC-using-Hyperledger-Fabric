#!/bin/bash
set -eu

dockerFabricPull() {
  local FABRIC_TAG=$1
  for IMAGES in peer orderer ccenv; do
      echo "==> FABRIC IMAGE: $IMAGES"
      echo
      docker pull hyperledger/fabric-$IMAGES:$FABRIC_TAG
      docker tag hyperledger/fabric-$IMAGES:$FABRIC_TAG hyperledger/fabric-$IMAGES
  done
}

dockerCaPull() {
      local CA_TAG=$1
      echo "==> FABRIC CA IMAGE"
      echo
      docker pull hyperledger/fabric-ca:$CA_TAG
      docker tag hyperledger/fabric-ca:$CA_TAG hyperledger/fabric-ca
}

BUILD=
DOWNLOAD=
if [ $# -eq 0 ]; then
    BUILD=true
    PUSH=true
    DOWNLOAD=true
else
    for arg in "$@"
        do
            if [ $arg == "build" ]; then
                BUILD=true
            fi
            if [ $arg == "download" ]; then
                DOWNLOAD=true
            fi
    done
fi

if [ $DOWNLOAD ]; then
    : ${CA_TAG:="1.4"}
    : ${FABRIC_TAG:="latest"}

    echo "===> Pulling fabric Images"
    dockerFabricPull ${FABRIC_TAG}

    echo "===> Pulling fabric ca Image"
    dockerCaPull ${CA_TAG}
    echo
    echo "===> List out hyperledger docker images"
    docker images | grep hyperledger*
fi

if [ $BUILD ];
    then
    echo
    echo '############################################################'
    echo '#                 BUILDING CONTAINER IMAGES                #'
    echo '############################################################'
    docker build -t orderer:latest orderer/

    echo
    echo '############################################################'
    echo '#             BUILDING BANK CONTAINERIMAGES                #'
    echo '############################################################'
    docker build -t bank-peer:latest bankPeer/

    echo
    echo '############################################################'
    echo '#            BUILDING PASSPORT CONTAINER IMAGES            #'
    echo '############################################################'
    docker build -t passport-peer:latest passportPeer/

    echo
    echo '############################################################'
    echo '#             BUILDING GOVT CONTAINER IMAGES               #'
    echo '############################################################'
    docker build -t govt-peer:latest govtPeer/

    echo
    echo
    echo '############################################################'
    echo '#             BUILDING WEB CONTAINER IMAGES               #'
    echo '############################################################'
    docker build -t web:latest web/

    echo
    echo '############################################################'
    echo '#            BUILDING BANK CA CONTAINER IMAGES             #'
    echo '############################################################'  
    docker build -t bank-ca:latest bankCA/

    echo
    echo '############################################################'
    echo '#        BUILDING PASSPORT CA CONTAINER IMAGES             #'
    echo '############################################################' 
    docker build -t passport-ca:latest passportCA/

    echo
    echo '############################################################'
    echo '#        BUILDING GOVT CA CONTAINER IMAGES                #'
    echo '############################################################' 
    docker build -t govt-ca:latest govtCA/
    
fi
