#!/bin/bash

INSTALLATION_DIR="${HOME}/.goat"
GOATAGENT_FILE="$INSTALLATION_DIR/goat-agent.sh"
GOAT="$INSTALLATION_DIR/goat.sh"

# Create a directory
echo "Installing goat to ${INSTALLATION_DIR} ..."
[ ! -d "$INSTALLATION_DIR" ] && mkdir $INSTALLATION_DIR

# Copy file
cp goat.sh $INSTALLATION_DIR

# Add goat alias to .*rc
read -p "What is the .*rc file where the goat alias should be appened? [${HOME}/.bashrc] " SHELLRC_FILE

[ ! "$SHELLRC_FILE" ] && SHELLRC_FILE="$HOME/.bashrc"
echo "Adding alias to ${SHELLRC_FILE} ..."

echo '
# Added by goat (https://github.com/0mp/goat)
alias goat=". '"$INSTALLATION_DIR"'/goat-agent.sh"' >> "$SHELLRC_FILE"

# Creating goat-agent
touch "$INSTALLATION_DIR"/goat-agent.sh
echo '# goat-agent
goat_there() {
    local output
    output="$(sh '"$GOAT"' "$@")"
    if [ -d "$output" ]; then
        cd $output
    elif [ ! -z "$output" ]; then
        echo "$output"
    fi
}
goat_there "$@"' > "$GOATAGENT_FILE"


echo Done!
