#!/bin/sh

cat <<EOF
Scripts Menu

Select Option:

    1. Clean project
    2. Package get
    3. Pub upgrade
    4. Dart build runner
    5. Gen L10n
    6. Test with coverage
    7. Installers
    0. Exit
EOF

read option

if [ $option = 1 ]; then
    clear
    ./scripts/clean.sh
elif [ $option = 2 ]; then
    clear
    ./scripts/package_get.sh
elif [ $option = 3 ]; then
    clear
    ./scripts/pub_upgrade.sh
elif [ $option = 4 ]; then
    clear
    ./scripts/dart_build_runner.sh
elif [ $option = 5 ]; then
    clear
    ./scripts/gen_l10n.sh
elif [ $option = 6 ]; then
    clear
    ./scripts/installers.sh
else
    echo 'Invalid option'
fi
