goat
====

`goat` is a hacky shortcut utility for managing your shortcuts.

You can assign some awesome aliases to those boring paths of yours using
`goat`.

`goat` can run after every failed `cd`. It means if you typed `cd dev` and
there is no `./dev/` directory, `goat` will treat `dev` as a shortcut and try
to go to the corresponding directory.

```text
# Example of the usage of cd extended with goat
[ ~/Pictures/ ] $ goat dev ~/Documents/dev # Create a shortcut to dev
[ ~/Pictures/ ] $ ls # There is no ~/Pictures/dev directory
seahorses wallpapers
[ ~/Pictures/ ] $ cd dev # cd fails so goat tries to take us to dev if known
[ ~/Documents/dev ] $
```

Installation
------------

```sh
git clone https://github.com/0mp/goat
cd goat
./goat-keeper.sh install
source ~/.bashrc
```

Usage
-----

- Create a `<shortcut>` to a `<directory>`

  ```text
  goat <shortcut> <directory>
  ```

- Change directory to a directory assigned to a `<shortcut>`

  ```text
  goat <shortcut>
  ```

- List all your saved shortcuts

  ```text
  goat please list shortcuts
  ```

- Delete a `<shortcut>` from your saved shortcuts

  ```text
  goat please delete <shortcut>
  ```

- Verify whether there is only one shorcut called <shortcut>

  ```text
  goat please verify <shortcut>
  ```

- Delete all saved shortcuts

  ```text
  goat please nuke shortcuts
  ```

- Print the help message

  ```text
  goat
  ```

  ```text
  goat please help me
  ```

Configuration
-------------

Paths and aliases are saved in `~/.goat/shortcuts.goat`.

- Update goat

  ```text
  ./goat-keeper update
  ```

- Remove goat

  ```sh
  ./goat-keeper remove
  ```

License
-------

Licensed under MIT license. Copyright &#169; 2016 Mateusz Piotrowski
