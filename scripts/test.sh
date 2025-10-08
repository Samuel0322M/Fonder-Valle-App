#!/bin/sh

cd modules/user_interface
echo 'Running test coverage in blocs...'
flutter test --coverage
cd ../../../
cd modules/domain
echo 'Running test coverage in use cases...'
flutter test --coverage
cd ../../
cd modules/data
echo 'Running test coverage in repositories...'
flutter test --coverage
cd ../../
sed 's+SF:+SF:modules/domain/+g' modules/domain/coverage/lcov.info > modules/domain/coverage/lcov_formated.info
sed 's+SF:+SF:modules/data/+g' modules/data/coverage/lcov.info > modules/data/coverage/lcov_formated.info
sed 's+SF:+SF:modules/user_interface/+g' modules/user_interface/coverage/lcov.info > modules/user_interface/coverage/lcov_formated.info
mkdir coverage
lcov --add-tracefile modules/user_interface/coverage/lcov_formated.info -a modules/domain/coverage/lcov_formated.info -a modules/data/coverage/lcov_formated.info -o coverage/coverage_merged.info
genhtml coverage/coverage_merged.info --output=coverage
open -a "Google Chrome" coverage/index.html