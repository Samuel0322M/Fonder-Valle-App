#!/bin/sh

cat <<EOF
Generate iOS artifact

Select module:

    1. Profile
    2. Release
EOF

read option

if [ $option = 1 ]; then
    clear
    rm flutter-artifacts/*
    mkdir flutter-artifacts
    echo "Building Profile IPA..."
    flutter clean
    flutter build ios --profile lib/main_dev.dart --dart-define-from-file=lib/env/demo.json
    cd build/ios/Profile-iphoneos
    mkdir payload
    mv Runner.app payload
    zip -r payload.ipa payload
    cd ../../../
    mv build/ios/Profile-iphoneos/payload.ipa ./flutter-artifacts
elif [ $option = 2 ]; then
    clear
    rm flutter-artifacts/*
    mkdir flutter-artifacts
    echo "Building Release IPA..."
    flutter clean
    flutter build ios --release lib/main.dart --dart-define-from-file=lib/env/prod.json
    cd build/ios/Release-iphoneos
    mkdir payload
    mv Runner.app payload
    zip -r payload.ipa payload
    cd ../../../
    mv build/ios/Release-iphoneos/payload.ipa ./flutter-artifacts
else
    echo 'Invalid option'
fi