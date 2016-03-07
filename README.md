goat
====

About
-----

`goat` is a hacky shortcut utility for managing your shortcuts.

You can assign some awesome aliases to those boring paths of yours using `goat`.

Installation
------------

    git clone https://github.com/0mp/goat
    cd goat
    sh install.sh
    source ~/.bashrc
    
*Note: The installation script assumes that you are using Bash and you keep your aliases in `~/.bashrc`. If it is not true then you'll need to modify `install.sh` a little bit.*

Usage
-----

- Assign an alias to a path

        $ goat awesome_alias bring_path

- Go to a directory with an awesome alias

        $ goat awesome_alias

Configuration
-------------

Paths and aliases are saved in `~/.goat/database.yml`.

Dependencies
------------

You'll need Ruby.

License
-------

Licensed under MIT license. Copyright (c) 2016 Mateusz Piotrowski
