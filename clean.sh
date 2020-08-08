#!/bin/bash

docker rm -f $(docker ps -aq)
images=( web bank-peer orderer govt-peer passport-ca govt-ca bank-ca passport-peer )
for i in "${images[@]}"
do
	echo Removing image : $i
  docker rmi -f $i
done

#docker rmi -f $(docker images | grep none)
images=( dev-govt-peer dev-bank-peer dev-passport-peer)
for i in "${images[@]}"
do
	echo Removing image : $i
  docker rmi -f $(docker images | grep $i )
done

chmod +x stop-explorer.sh
./stop-explorer.sh
