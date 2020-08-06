#!/bin/sh

CHANNEL_NAME="default"
PROJPATH=$(pwd)
CLIPATH=$PROJPATH/cli/peers
chmod +x configtxgen

echo
echo "##########################################################"
echo "#########  Generating Orderer Genesis block ##############"
echo "##########################################################"
$PROJPATH/configtxgen -profile ThreeOrgsGenesis -outputBlock $CLIPATH/genesis.block

echo
echo "#################################################################"
echo "### Generating channel configuration transaction 'channel.tx' ###"
echo "#################################################################"
$PROJPATH/configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx $CLIPATH/channel.tx -channelID $CHANNEL_NAME
cp $CLIPATH/channel.tx $PROJPATH/web
echo
echo "#################################################################"
echo "####### Generating anchor peer update for BankOrg ##########"
echo "#################################################################"
$PROJPATH/configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate $CLIPATH/BankOrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg BankOrgMSP

echo
echo "#################################################################"
echo "#######    Generating anchor peer update for PassportOrg   ##########"
echo "#################################################################"
$PROJPATH/configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate $CLIPATH/PassportOrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg PassportOrgMSP

echo
echo "##################################################################"
echo "####### Generating anchor peer update for GovtShopOrg ##########"
echo "##################################################################"
$PROJPATH/configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate $CLIPATH/GovtShopOrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg GovtOrgMSP
