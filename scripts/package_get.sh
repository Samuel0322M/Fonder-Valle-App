#!/bin/sh

cat <<EOF
Flutter Setup

Running models packages get...
EOF
cd modules/models/
flutter packages get
cd ../..

echo ''
echo 'Running domain packages get...'
cd modules/domain/
flutter packages get
cd ../..

echo ''
echo 'Running data packages get...'
cd modules/data/
flutter packages get
cd ../..

echo ''
echo 'Running user_interface packages get...'
cd modules/user_interface/
flutter packages get
cd ../..

echo ''
echo 'Running api_source packages get...'
cd modules/api_source/
flutter packages get
cd ../..

echo ''
echo 'Running db_source packages get...'
cd modules/db_source/
flutter packages get
cd ../..

echo ''
echo 'Running root packages get...'
flutter packages get