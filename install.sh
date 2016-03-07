#!/bin/bash

SHELLRC_FILE="${HOME}/.bashrc"
GOAT_DIR="${HOME}/.goat"
INSTALLATION_DIR="${HOME}/.goat/lib"
CONFIGURATION_DIR="${HOME}/.goat/config"

echo "Installing goat to ${INSTALLATION_DIR} ..."
if [ ! -d "$GOAT_DIR" ]; then
    mkdir $GOAT_DIR
fi
if [ ! -d "$INSTALLATION_DIR" ]; then
    mkdir $INSTALLATION_DIR
fi
cp goat.rb $INSTALLATION_DIR/goat.rb

echo "Adding configuration files ..."
if [ ! -d "$CONFIGURATION_DIR" ]; then
    mkdir $CONFIGURATION_DIR
fi

echo "Adding alias to ${SHELLRC_FILE} ..."

echo '
# Added by goat.
function GoatThere {
    GOATPATH=`ruby'" ${INSTALLATION_DIR}"'/goat.rb $1 $2`
    if [ ! -z "$GOATPATH" ]; then
        cd $GOATPATH
    fi
}
alias goat=GoatThere' >> $SHELLRC_FILE

echo Done!

