#!/bin/bash

SHELLRC_FILE="${HOME}/.bashrc"
INSTALLATION_DIR='/usr/local/lib/goat'
CONFIGURATION_DIR="${HOME}/.goat"

echo "Installing goat to ${INSTALLATION_DIR} ..."
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
    cd `ruby'" ${INSTALLATION_DIR}"'/goat.rb $1 $2 || pwd`
}
alias goat=GoatThere' >> $SHELLRC_FILE

echo Done!
