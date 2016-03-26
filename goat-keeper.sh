#!/bin/sh

INSTALLATION_DIR="$HOME/.goat"
GOATAGENT_FILE="$INSTALLATION_DIR/goat-agent.sh"
GOAT="$INSTALLATION_DIR/goat.sh"
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
            echo Adding cd extended with goat ...
            echo \
                "\n""cd_extended_wth_goat() {"                          \
                "\n""    [ \"\$1\" = \"\" ] && command cd"              \
                "\n""    command cd \"\$1\" 2>/dev/null || "            \
                            ". $INSTALLATION_DIR/goat-agent.sh \"\$1\"" \
                "\n""}"                                                 \
                "\n"                                                    \
                "\n""alias cd=\"cd_extended_wth_goat\"                  \
                " >> "$SHELLRC_FILE"
            ;;
        *)
            echo "Sure! This feature will not be installed."
            ;;
    esac
}

create_goatagent() {
    touch "$INSTALLATION_DIR"/goat-agent.sh
    echo    "# goat-agent"                              \
        "\n""goat_there() {"                            \
        "\n""    local output"                          \
        "\n""    output=\"\$(sh \"\$GOAT\" \"\$@\")\""  \
        "\n""    if [ -d \"\$output\" ]; then"          \
        "\n""        command cd \"\$output\""           \
        "\n""    elif [ ! -z \"\$output\" ]; then"      \
        "\n""        echo \"\$output\""                 \
        "\n""    fi"                                    \
        "\n""}"                                         \
        "\n""goat_there \"\$@\""                        \
        "\n"                                            \
        > "$GOATAGENT_FILE"
}

add_goat_alias() {
    printf '%s %s ' \
        "What is the .*rc file where the goat alias should be appened?" \
        "[default: ${HOME}/.bashrc]"
    read SHELLRC_FILE

    [ ! "$SHELLRC_FILE" ] && SHELLRC_FILE="$HOME/.bashrc"
    echo "Adding alias to ${SHELLRC_FILE} ..."

    echo \
        "\n""# Added by goat (https://github.com/0mp/goat)"             \
        "\n""alias goat=\". '\"\$INSTALLATION_DIR\"'/goat-agent.sh\""   \
        "\n"                                                            \
        >> "$SHELLRC_FILE"
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

uninstall_goat() {
    printf "Are you sure you want to uninstall goat? [y|N] "
    read REPLY
    case "$REPLY" in
        y|Y)
            echo Uninstalling goat ...
            if rm -rf "$INSTALLATION_DIR"; then
                echo "Remove the goat alias from you .*rc file to finish."
            else
                echo "There was an error with the removal of $INSTALLATION_DIR"
                exit 1
            fi
            ;;
        *)
            echo Sure! No uninstalling for the time being.
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
    "uninstall")
        uninstall_goat
        ;;
    "update")
        update_goat
        ;;
    *)
        echo    "Keeper is a little bit confused about your request. "  \
                    "What's that again?"                                \
            "\n"'Usage: ./$KEEPER_NAME [install|update]'
        ;;
esac && echo Done!

