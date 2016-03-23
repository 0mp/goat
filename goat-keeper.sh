#!/bin/sh

INSTALLATION_DIR="$HOME/.goat"
GOATAGENT_FILE="$INSTALLATION_DIR/goat-agent.sh"
GOAT="$INSTALLATION_DIR/goat.sh"
KEEPER_NAME="goat-keeper"
ACTIVITY="$1"

copy_goatsh() {
    cp goat.sh $INSTALLATION_DIR
}

create_goatagent() {
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
}

install_goat() {
    # Create a directory
    echo "Installing goat to ${INSTALLATION_DIR} ..."
    [ ! -d "$INSTALLATION_DIR" ] && mkdir $INSTALLATION_DIR

    # Copy file
    copy_goatsh

    # Add goat alias to .*rc
    read -p "What is the .*rc file where the goat alias should be appened? [default: ${HOME}/.bashrc] " SHELLRC_FILE

    [ ! "$SHELLRC_FILE" ] && SHELLRC_FILE="$HOME/.bashrc"
    echo "Adding alias to ${SHELLRC_FILE} ..."

    echo '
    # Added by goat (https://github.com/0mp/goat)
    alias goat=". '"$INSTALLATION_DIR"'/goat-agent.sh"' >> "$SHELLRC_FILE"

    # Creating goat-agent
    create_goatagent
}

update_goat() {
    # Check the .goat existance.
    echo Check if goat is already installed.
    if [ ! -d "$INSTALLATION_DIR" ]; then
        echo "goat doesn't seem to be installed yet."
        echo "Run $KEEPER_NAME to insatll goat."
        exit 1
    fi

    # Update goat.
    echo Updating goat ...
    copy_goatsh
    create_goatagent
}


case "$ACTIVITY" in
    "install")
        install_goat
        ;;
    "update")
        update_goat
        ;;
    *)
        echo "\
Keeper is a little bit confused about your request. What's that again?
Usage: ./$KEEPER_NAME [install|update]"
esac && echo Done!

