#!/bin/sh

cat <<EOF
Generate Web artifact

Select module:

    1. Dev - Demo
    2. Profile - Demo
    3. Release - Demo
    4. Release - Prod
EOF

read option

if [ $option = 1 ]; then
    clear
    rm flutter-artifacts/*
    mkdir flutter-artifacts
    echo "Building Dev..."
    flutter clean
    flutter build web --debug lib/main_dev.dart --dart-define-from-file=lib/env/demo.json
    cp build/web flutter-artifacts
elif [ $option = 2 ]; then
    clear
    rm flutter-artifacts/*
    mkdir flutter-artifacts
    echo "Building Profile..."
    flutter clean
    flutter build web --profile lib/main_dev.dart --dart-define-from-file=lib/env/demo.json
    cp build/web flutter-artifacts
elif [ $option = 3 ]; then
    clear
    rm flutter-artifacts/*
    mkdir flutter-artifacts
    echo "<<<<<<<<<<<<<<<<<Building Release WEB...>>>>>>>>>>>>>>>>>>>>>"
    flutter clean
    flutter build web --release lib/main.dart --dart-define-from-file=lib/env/demo.json  
    echo "<<<<<<<<<<<<<<<<<Copy bundle>>>>>>>>>>>>>>>>>>>>>"
    cp -r build/web flutter-artifacts
elif [ $option = 4 ]; then
    clear
    rm flutter-artifacts/*
    mkdir flutter-artifacts
    echo "<<<<<<<<<<<<<<<<<Building Release WEB...>>>>>>>>>>>>>>>>>>>>>"
    flutter clean
    flutter build web --release lib/main.dart --dart-define-from-file=lib/env/prod.json  
    echo "<<<<<<<<<<<<<<<<<Copy bundle>>>>>>>>>>>>>>>>>>>>>"
    cp -r build/web flutter-artifacts
else
    echo 'Invalid option'
fi