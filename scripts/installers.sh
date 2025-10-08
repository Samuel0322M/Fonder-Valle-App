#!/bin/sh

cat <<EOF
Generate artifacts

Select module:

    1. Android
    2. iOS
    3. Web
    4. Windows
    5. macOS
    0. Cancel
EOF

read option

if [ $option = 1 ]; then
    clear
    ./scripts/artifact_android.sh
elif [ $option = 2 ]; then
    clear
    ./scripts/artifact_ios.sh
elif [ $option = 3 ]; then
    clear
    ./scripts/artifact_web.sh
else
    echo ''
fi