
chmod +x build-explorer-images.sh
chmod +x explorer-crypto.sh
./build-explorer-images.sh
./explorer-crypto.sh
cd explorer
docker-compose up -d