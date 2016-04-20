goat
====

`goat` is a hacky shortcut utility for managing your shortcuts.

You can assign some awesome aliases to those boring paths of yours using `goat`.

`goat` can run after every failed `cd`. It means if you typed `cd dev` and there is no `./dev/` directory, `goat` will treat `dev` as a shortcut and try to go to the coresponding directory.

    # Example of the usage of cd extended with goat
    [ ~/Pictures/ ] $ goat dev ~/Documents/dev # Create a shortcut to dev
    [ ~/Pictures/ ] $ ls # There is no ~/Pictures/dev directory
    seahores wallpapers
    [ ~/Pictures/ ] $ cd dev # cd fails so goat tries to take us to dev if known
    [ ~/Documents/dev ] $

Installation
------------

    git clone https://github.com/0mp/goat
    cd goat
    ./goat-keeper install
    source ~/.bashrc

Usage
-----

- Create a \<shortcut> to a \<directory>

        goat <shortcut> <directory>

- Change directory to a directory assigned to a \<shortcut>

        goat <shortcut>

- List all your saved shortcuts

        goat please list shortcuts

- Delete a \<shortcut> from your saved shortcuts

        goat please delete <shortcut>

- Delete all saved shortcuts

        goat please nuke shortcuts

- Print the help message
    ```
    goat
    ```
    ```
    goat please help me
    ```

Configuration
-------------

Paths and aliases are saved in `~/.goat/shortcuts.goat`.

- Update goat

        ./goat-keeper update

- Remove goat

        ./goat-keeper remove

License
-------

Licensed under MIT license. Copyright &#169; 2016 Mateusz Piotrowski
