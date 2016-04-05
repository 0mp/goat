#!/bin/sh

INSTALLATION_DIR="${HOME}/.goat"
GOATAGENT_FILE="${INSTALLATION_DIR}/goat-agent.sh"
GOAT="${INSTALLATION_DIR}/goat.sh"
KEEPER_NAME="goat-keeper"
ACTIVITY="$1"

copy_goatsh() {
    cp goat.sh "$INSTALLATION_DIR"
}

install_cd_extended_with_goat() {
    printf '%s %s ' \
        "goat can try change directory if cd fails to do so." \
        "Would you like to add this feature? [Y|n] "
    read REPLY
    case "$REPLY" in
        y|Y|'')
            if [ "$SHELLRC_PATH" = "" ]; then
                echo "ERROR: $SHELLRC_PATH has not been provided."
                return 1
            fi
            echo Adding cd extended with goat ...
            printf "\n%s" \
                "cd_extended_wth_goat() {"                          \
                "    [ \"\$1\" = \"\" ] && command cd"              \
                "    command cd \"\$1\" 2>/dev/null || "            \
                "        . $INSTALLATION_DIR/goat-agent.sh \"\$1\"" \
                "}"                                                 \
                ""                                                  \
                "alias cd=\"cd_extended_wth_goat\""                 \
                ""                                                  \
                >> "$SHELLRC_PATH"
            ;;
        *)
            echo "Sure! This feature will not be installed."
            ;;
    esac
}

create_goatagent() {
    touch "$INSTALLATION_DIR"/goat-agent.sh
    printf "%s\n" \
        "# goat-agent"                                \
        ""                                            \
        "goat_there() {"                              \
        "    local output"                            \
        "    output=\"\$(sh "$GOAT" \"\$@\")\""       \
        "    if [ -d \"\$output\" ]; then"            \
        "        command cd \"\$output\""             \
        "    elif [ ! -z \"\$output\" ]; then"        \
        "        echo \"\$output\""                   \
        "    fi"                                      \
        "}"                                           \
        ""                                            \
        "goat_there \"\$@\""                          \
        > "$GOATAGENT_FILE"
}

add_goat_alias() {
    printf '%s ' \
        "What is the .*rc file where the goat alias should be appened?" \
        "[default: ${HOME}/.bashrc]"
    read SHELLRC_PATH

    # Expand the ~ to $HOME.
    SHELL_PATH=$(echo $SHELLRC_PATH | sed -r 's,^\~,'"$HOME"',')

    [ ! "$SHELLRC_PATH" ] && SHELLRC_PATH="$HOME/.bashrc"
    echo "Adding alias to ${SHELLRC_PATH} ..."

    printf "\n%s" \
        "# Added by goat (https://github.com/0mp/goat)"      \
        "alias goat=\". ${INSTALLATION_DIR}/goat-agent.sh\"" \
        ""                                                   \
        >> "$SHELLRC_PATH"
}

install_goat() {
    # Create a directory
    echo "Installing goat to ${INSTALLATION_DIR} ..."
    [ ! -d "$INSTALLATION_DIR" ] && mkdir $INSTALLATION_DIR

    # Copy file
    copy_goatsh

    # Add goat alias to .*rc
    add_goat_alias

    # Create goat-agent
    create_goatagent

    # Add the possiblity to run goat after every failed cd
    install_cd_extended_with_goat
}

remove_goat() {
    printf "Are you sure you want to remove goat? [y|N] "
    read REPLY
    case "$REPLY" in
        y|Y)
            echo Removing goat ...
            if rm -rf "$INSTALLATION_DIR"; then
                echo "Remove the goat alias from you .*rc file to finish."
            else
                echo "There was an error with the removal of $INSTALLATION_DIR"
                exit 1
            fi
            ;;
        *)
            echo Sure! No removing for the time being.
            ;;
    esac
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
    "remove")
        remove_goat
        ;;
    *)
        printf "%s%s\n%s\n" \
            "Keeper is a little bit confused about your request. " \
            "What's that again?"                                   \
            "Usage: ./${KEEPER_NAME} [install|update|remove]"
        exit 1
        ;;
esac && echo Done!

