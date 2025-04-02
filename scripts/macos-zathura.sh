#!/bin/bash


if [[  "$OSTYPE" != "darwin"* ]]; then
    echo "Not on MacOS!"
    exit 1
fi

if [[ $(uname -m) != 'arm64' ]]; then
    echo "Intel Mac detected!"
    # See: `:help vimtex-faq-zathura-macos`
    brew install dbus
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"
    sed -i 's/<auth>EXTERNAL<\/auth>/<auth>DBUS_COOKIE_SHA1<\/auth>/' /usr/local/opt/dbus/share/dbus-1/session.conf

    brew services start dbus
    brew services info dbus

    brew tap zegervdv/zathura
    brew install girara --HEAD
    brew install zathura --HEAD --with-synctex
    brew install zathura-pdf-poppler
    mkdir -p "$(brew --prefix zathura)"/lib/zathura
    ln -s "$(brew --prefix zathura-pdf-poppler)"/libpdf-poppler.dylib "$(brew --prefix zathura)"/lib/zathura/libpdf-poppler.dylib

    ret_msg="It is necessary to reboot for (n)vim and Zathura to work"
else
    ret_msg="To set up Zathura on Apple Silicon, follow the guide at:\n\thttps://github.com/zegervdv/homebrew-zathura/issues/99 \n TLDR: kind of a tedious process, it requires to install rosetta and x86_64 brew"
fi

echo -e "\n===============================================================\n"
echo -e "$ret_msg"
echo -e "\n===============================================================\n"

return 0
