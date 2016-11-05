# goat

[![Build Status](https://travis-ci.org/0mp/goat.svg?branch=master)](https://travis-ci.org/0mp/goat)

### Quick example

```sh
[ ~/Pictures/ ] $ goat dev ~/Documents/dev # create a shortcut to dev
[ ~/Pictures/ ] $ ls # there is no ~/Pictures/dev directory
seahorses wallpapers
[ ~/Pictures/ ] $ cd dev # cd fails so goat will use its 'dev' shortcut
[ ~/Documents/dev ] $
```

>
>
> _
> `goat` is a hacky shortcut utility for managing your shortcuts!
>
> _~ 0mp_

<!-- -->

> Oh my! This is a **POSIX-compliant** shell _movement boosting_ **hack** for
> **real ninjas**. I'm cloning it straight away!
>
> _~ 0mp, again_

<!-- -->

> Rad! I can do `cd ....` now instead of performing a horse galloping-like
> waltz `../` being my dance floor.
>
> _~ YA0mp_

Sometimes you jump around your filesystem tree a lot and you end up putting a
couple of ugly aliases into your shell's rc file.

With `goat` you can easily manage your ninja shortcuts - just type `goat p
~/Projects` to introduce a new shortcut and then `goat p` (or even `cd p`!) to
jump to its destination.

## Installation

```sh
git clone https://github.com/0mp/goat
cd goat
./goatherd target
./goatherd install
. ~/.bashrc
```

`goat` should work with other shells as well. I encourage you to tweak
`*.config` files to change things like the default installation directory and
shell.

## Usage overview

```sh
# Create a shortcut to a directory:
goat shortcut directory

# Change directory to a directory assigned to a shortcut:
goat shortcut

# Go up the filesystem tree with '...' instead of '../../':
goat ...

# List all your saved shortcuts:
goat please list shortcuts

# Delete an absolute shortcut from your saved shortcuts:
goat please delete shortcut

# Delete all saved shortcuts:
goat please nuke shortcuts

# Print the help message:
goat
# or:
goat please help me
```

## Configuration

`goat lives in in `$HOME/.goat/` by default and shortcuts are
stored in `$HOME/.goat/shortcuts.config`.

See `goatherd.config`, `src/leash.config` and `src/goat.config` to configure
your custom installation of `goat`.

## Development

The see `CONTRIBUTING.md`.

License
-------

Licensed under MIT license. Copyright &#169; 2016 Mateusz Piotrowski
