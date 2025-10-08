#!/bin/sh

cat <<EOF
Flutter Setup

Running models packages upgrade...
EOF
cd modules/models/
flutter packages upgrade
cd ../..

echo ''
echo 'Running domain packages upgrade...'
cd modules/domain/
flutter packages upgrade
cd ../..

echo ''
echo 'Running data packages upgrade...'
cd modules/data/
flutter packages upgrade
cd ../..

echo ''
echo 'Running user_interface packages upgrade...'
cd modules/user_interface/
flutter packages upgrade
cd ../..

echo ''
echo pwd
echo 'Running api_source packages upgrade...'
cd modules/api_source/
flutter packages upgrade
cd ../..

echo ''
echo 'Running db_source packages upgrade...'
cd modules/db_source/
flutter packages upgrade
cd ../..

echo ''
echo 'Running root packages upgrade...'
flutter packages upgrade