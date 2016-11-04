#!/bin/sh

SHORTCUTS_FILE="$HOME/.goat/shortcuts.goat"

# Stderr echo wrapper
errcho(){
    >&2 echo $@
}

# Load a certain entry from the file
#
# Variables:
#   $1 -> a shortcut for which we want to find a mathching entry
#
# Returns:
#   - an entry starting with '/' if everything is fine
#   - an empty string if grep failed or there is no such entry
#   - "1" if there is an error
get_entry() {
    local status=0
    local shortcut="$1"
    local searched_entry="^$shortcut	"
    local grep_result
    grep_result=$(grep -n "$searched_entry" "$SHORTCUTS_FILE" 2>/dev/null)

    # Check if there is only one result found by grep
    number_of_lines=$(echo "$grep_result" | wc -l)
    if [ "$number_of_lines" -gt 1 ]; then
        errcho "ERROR: goat found more than one destinations for the '$shortcut' shortcut. The '$SHORTCUTS_FILE' file is corrupted."
        echo "1"
    elif [ "$number_of_lines" -lt 1 ]; then
        errcho "ERROR: goat tried to get the entry for '$shortcut' but it failed"
        echo "1"
    else
        echo "$grep_result"
    fi

}

# Remove a certain entry from a file. If there is no such entry do nothing
# Variables:
#   $1 -> a shortcut for which we want to remove a matching entry
remove_shortcut() {
    local shortcut="$1"
    local removed_entry="$shortcut	"
    local line
    line=$(grep -n "$removed_entry" "$SHORTCUTS_FILE" | cut -d: -f1)
    if [ ! -z "$line" ]; then
        sed -e "${line}d" "$SHORTCUTS_FILE" > "$SHORTCUTS_FILE".bak && mv "$SHORTCUTS_FILE".bak "$SHORTCUTS_FILE"
        errcho "INFO: goat removed the '$1' shortcut"
    else
        errcho "INFO: goat didn't remove '$1'; maybe it doesn't exist?"
    fi
}

remove_broken() {
	while read p; do
		local location=$(echo $p | cut -d ' ' -f2)
		local shortcut=$(echo $p | cut -d ' ' -f1)
    		if [ $(cd "$location" 1>/dev/null 2>/dev/null && echo 0 || echo 1) -eq 1 ]; then
			remove_shortcut $shortcut	
    		fi
	done <$SHORTCUTS_FILE
}

# Show usage information
show_help() {
    echo "\
Usage:
    goat <shortcut> <directory>
            Create a <shortcut> to <directory>.

    goat <shortcut>
            Change to a directory assigned to <shortcut>.

    goat please list shortcuts
            List all your saved shortcuts.

    goat please nuke shortcuts
            Delete all saved shortcuts.

    goat please delete <shortcut>
            Delete <shortcut> from your saved shortcuts.

    goat
            Print this help message.

    goat please help me
            Print this help message."

    return 0
}

# Go to the destination
# Variables:
#   $1 -> a shortcut which can be matched with a directory we want to go to
# Returns:
#   - a path when we found a coresponding path for the given shortcut
#   - 1 when there was an error
go() {
    local shortcut="$1"
    local entry
    entry="$(get_entry "$shortcut")"

    # Check if get_entry failed
    [ "$entry" = "1" ] && return 1

    local path
    path="$(echo "$entry" | cut -d'	' -f2)"

    if [ -z "$path" ]; then
        errcho "ERROR: goat doesn't know where '${shortcut}' should lead to."
        return 1
    elif [ ! -d "$path" ]; then
        errcho "ERROR: goat cannot reach the '${path}' directory."
        return 1
    else
        echo "$path"
    fi
}

# Create a new shortcut
# Variables:
#   $1 -> a new shortcut
#   $2 -> a path for the new shortcut
# Returns:
#   - 1 if there was an error
#   - 0 if everything was fine
create() {
    local shortcut="$1"
    local path
    path="$2"

    # Check if the path exists
    if [ $(cd "$path" 1>/dev/null 2>/dev/null && echo 0 || echo 1) -eq 1 ]; then
        errcho "ERROR: goat thinks that '${path}' isn't a valid path."
        return 1
    fi

    # Get the absolute path
    path=$(cd -- "$path" && pwd -P 2>/dev/null | pwd)

    # Remove the old shortcut
    remove_shortcut "$shortcut" 2>/dev/null

    # Add new shortcut
    echo "$shortcut	$path" >> "$SHORTCUTS_FILE"

    return 0
}

# Administrate your goat
# Variables:
#   $1 -> "please"
#   $2, $3 -> depends
# Returns:
#   0, if everything went fine
#   1, if there was an error
configure() {
    local exit_status=0

    if [ "$1" = "please" ]; then
        if [ "$2" = "delete" ]; then
	    if [ "$3" = "broken" ]; then
	    	remove_broken || exit_status=1 
	    else
		remove_shortcut "$3" || exit_status=1
	    fi
        elif [ "$2" = "help" ] && [ "$3" = "me" ]; then
            show_help
        elif [ "$2" = "list" ] && [ "$3" = "shortcuts" ]; then
            cat "$SHORTCUTS_FILE" || exit_status=1
        elif [ "$2" = "nuke" ] && [ "$3" = "shortcuts" ]; then
            rm "$SHORTCUTS_FILE" || exit_status=1
        else
            echo "ERROR: goat just doesn't know what to do with itself."
            exit_status=1
        fi
    else
        echo "FAUX PAS: goat doesn't like that kind of tone."
        exit_status=1
    fi
    return $exit_status
}

# Handle user input
# Creates the shortcuts file if it does not exists.
#
handle_input() {
    local exit_status=0

    # Test existance of the file with shortcuts
    [ ! -f "$SHORTCUTS_FILE" ] && touch "$SHORTCUTS_FILE"

    if [ $# -eq 0 ]; then
        show_help || exit_status=1
    elif [ $# -eq 1 ]; then
        go "$1" || exit_status=1
    elif [ $# -eq 2 ]; then
        create "$1" "$2" || exit_status=1
    elif [ $# -eq 3 ]; then
        configure "$1" "$2" "$3" || exit_status=1
    fi

    exit $exit_status
}

handle_input "$@"
