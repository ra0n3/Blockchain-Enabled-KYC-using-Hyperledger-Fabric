#!/bin/sh
set -e

echo
echo "#################################################################"
echo "#######        Generating cryptographic material       ##########"
echo "#################################################################"
PROJPATH=$(pwd)
CLIPATH=$PROJPATH/cli/peers
ORDERERS=$CLIPATH/ordererOrganizations
PEERS=$CLIPATH/peerOrganizations

rm -rf $CLIPATH

chmod +x cryptogen

$PROJPATH/cryptogen generate --config=$PROJPATH/crypto-config.yaml --output=$CLIPATH

chmod +x generate-cfgtx.sh

sh generate-cfgtx.sh

#Creating the peer directories to store the cryptos

rm -rf $PROJPATH/{orderer,bankPeer,passportPeer,govtPeer}/crypto
mkdir $PROJPATH/{orderer,bankPeer,passportPeer,govtPeer}/crypto
cp -r $ORDERERS/orderer-org/orderers/orderer0/{msp,tls} $PROJPATH/orderer/crypto
cp -r $PEERS/bank-org/peers/bank-peer/{msp,tls} $PROJPATH/bankPeer/crypto
cp -r $PEERS/passport-org/peers/passport-peer/{msp,tls} $PROJPATH/passportPeer/crypto
cp -r $PEERS/govt-org/peers/govt-peer/{msp,tls} $PROJPATH/govtPeer/crypto
cp $CLIPATH/genesis.block $PROJPATH/orderer/crypto/

# Creating CA

BANKCAPATH=$PROJPATH/bankCA
PASSPORTCAPATH=$PROJPATH/passportCA
GOVTCAPATH=$PROJPATH/govtCA

rm -rf {$BANKCAPATH,$PASSPORTCAPATH,$GOVTCAPATH}/{ca,tls}
mkdir -p {$BANKCAPATH,$PASSPORTCAPATH,$GOVTCAPATH}/{ca,tls}

#copy generated creds to the bank ca path
cp $PEERS/bank-org/ca/* $BANKCAPATH/ca
cp $PEERS/bank-org/tlsca/* $BANKCAPATH/tls

# Renaming with correct extension and name for all keys

mv $BANKCAPATH/ca/*_sk $BANKCAPATH/ca/key.pem
mv $BANKCAPATH/ca/*-cert.pem $BANKCAPATH/ca/cert.pem
mv $BANKCAPATH/tls/*_sk $BANKCAPATH/tls/key.pem
mv $BANKCAPATH/tls/*-cert.pem $BANKCAPATH/tls/cert.pem

#copy generated creds to the passport ca path
cp $PEERS/passport-org/ca/* $PASSPORTCAPATH/ca
cp $PEERS/passport-org/tlsca/* $PASSPORTCAPATH/tls

# Renaming with correct extension and name for all keys
mv $PASSPORTCAPATH/ca/*_sk $PASSPORTCAPATH/ca/key.pem
mv $PASSPORTCAPATH/ca/*-cert.pem $PASSPORTCAPATH/ca/cert.pem
mv $PASSPORTCAPATH/tls/*_sk $PASSPORTCAPATH/tls/key.pem
mv $PASSPORTCAPATH/tls/*-cert.pem $PASSPORTCAPATH/tls/cert.pem

#copy generated creds to the govt ca path
cp $PEERS/govt-org/ca/* $GOVTCAPATH/ca
cp $PEERS/govt-org/tlsca/* $GOVTCAPATH/tls

# Renaming with correct extension and name for all keys
mv $GOVTCAPATH/ca/*_sk $GOVTCAPATH/ca/key.pem
mv $GOVTCAPATH/ca/*-cert.pem $GOVTCAPATH/ca/cert.pem
mv $GOVTCAPATH/tls/*_sk $GOVTCAPATH/tls/key.pem
mv $GOVTCAPATH/tls/*-cert.pem $GOVTCAPATH/tls/cert.pem


WEBCERTS=$PROJPATH/web/certs
rm -rf $WEBCERTS
mkdir -p $WEBCERTS
cp $PROJPATH/orderer/crypto/tls/ca.crt $WEBCERTS/ordererOrg.pem
cp $PROJPATH/bankPeer/crypto/tls/ca.crt $WEBCERTS/bankOrg.pem
cp $PROJPATH/passportPeer/crypto/tls/ca.crt $WEBCERTS/passportOrg.pem
cp $PROJPATH/govtPeer/crypto/tls/ca.crt $WEBCERTS/govtOrg.pem

cp $PEERS/bank-org/users/Admin@bank-org/msp/keystore/* $WEBCERTS/Admin@bank-org-key.pem
cp $PEERS/bank-org/users/Admin@bank-org/msp/signcerts/* $WEBCERTS/
cp $PEERS/passport-org/users/Admin@passport-org/msp/keystore/* $WEBCERTS/Admin@passport-org-key.pem
cp $PEERS/passport-org/users/Admin@passport-org/msp/signcerts/* $WEBCERTS/
cp $PEERS/govt-org/users/Admin@govt-org/msp/keystore/* $WEBCERTS/Admin@govt-org-key.pem
cp $PEERS/govt-org/users/Admin@govt-org/msp/signcerts/* $WEBCERTS/
