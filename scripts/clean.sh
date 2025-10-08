#!/bin/sh

cat <<EOF
Flutter Setup

Running models flutter clean...
EOF
echo ''
echo 'Running db_source flutter clean...'
cd modules/db_source/
flutter clean
cd ../..

cd modules/models/
flutter clean
cd ../..

echo ''
echo 'Running domain flutter clean...'
cd modules/domain/
flutter clean
cd ../..

echo ''
echo 'Running data flutter clean...'
cd modules/data/
flutter clean
cd ../..

echo ''
echo 'Running user_interface flutter clean...'
cd modules/user_interface/
flutter clean
cd ../..

echo ''
echo 'Running api_source flutter clean...'
cd modules/api_source/
flutter clean
cd ../..

echo ''
echo 'Running root packages get...'
flutter clean