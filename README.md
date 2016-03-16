goat
====

`goat` is a hacky shortcut utility for managing your shortcuts.

You can assign some awesome aliases to those boring paths of yours using `goat`.

Installation
------------

    git clone https://github.com/0mp/goat
    cd goat
    sh install.sh
    source ~/.bashrc

Usage
-----

- Create a <shortcut> to <directory>.

        goat <shortcut> <directory>

- Change to a directory assigned to <shortcut>.

        goat <shortcut>

- List all your saved shortcuts.

        goat please list shortcuts

- Delete <shortcut> from your saved shortcuts.

        goat please delete <shortcut>

- Print help message.

        goat

        goat please help me

Configuration
-------------

Paths and aliases are saved in `~/.goat/shortcuts.goat`.

License
-------

Licensed under MIT license. Copyright (c) 2016 Mateusz Piotrowski
