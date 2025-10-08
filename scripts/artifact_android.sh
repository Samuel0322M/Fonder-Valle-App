#!/bin/sh

cat <<EOF
Generate Android artifact

Select module:

    1. Dev APK
    2. Profile APK
    3. Release APK Demo
    4. Release APK Prod
    5. Release Bundle
EOF

read option

if [ $option = 1 ]; then
    clear
    echo "Building Dev APK..."
    flutter clean
    flutter build apk --debug lib/main_dev.dart --dart-define-from-file=lib/env/demo.json
elif [ $option = 2 ]; then
    clear
    rm flutter-artifacts/*
    mkdir flutter-artifacts
    echo "Building Profile APK..."
    flutter clean
    flutter build apk --profile lib/main_dev.dart --dart-define-from-file=lib/env/demo.json
    echo "<<<<<<<<<<<<<<<<<Copy APK>>>>>>>>>>>>>>>>>>>>>"
    cp build/app/outputs/flutter-apk/app-profile.apk flutter-artifacts
elif [ $option = 3 ]; then
    clear
    rm flutter-artifacts/*
    mkdir flutter-artifacts
    echo "<<<<<<<<<<<<<<<<<Building Release APK Demo...>>>>>>>>>>>>>>>>>>>>>"
    flutter clean
    flutter build apk --release lib/main.dart  --dart-define-from-file=lib/env/demo.json  
    echo "<<<<<<<<<<<<<<<<<Copy APK>>>>>>>>>>>>>>>>>>>>>"
    cp -r build/app/outputs/flutter-apk/app-release.apk flutter-artifacts
elif [ $option = 4 ]; then
    clear
    rm flutter-artifacts/*
    mkdir flutter-artifacts
    echo "<<<<<<<<<<<<<<<<<Building Release APK Prod...>>>>>>>>>>>>>>>>>>>>>"
    flutter clean
    flutter build apk --release lib/main.dart  --dart-define-from-file=lib/env/prod.json  
    echo "<<<<<<<<<<<<<<<<<Copy APK>>>>>>>>>>>>>>>>>>>>>"
    cp -r build/app/outputs/flutter-apk/app-release.apk flutter-artifacts
elif [ $option = 5 ]; then
    clear
    rm flutter-artifacts/*
    mkdir flutter-artifacts
    echo "Building Dev Bundle..."
    flutter clean
    flutter build appbundle lib/main.dart --dart-define-from-file=lib/env/prod.json
    echo "<<<<<<<<<<<<<<<<<Copy bundle>>>>>>>>>>>>>>>>>>>>>"
    cp -r build/app/outputs/bundle/release/app-release.aab flutter-artifacts
else
    echo 'Invalid option'
fi