# goat

[![Build Status](https://travis-ci.org/0mp/goat.svg?branch=master)](https://travis-ci.org/0mp/goat)
[![POSIX Compliance](https://img.shields.io/badge/POSIX-compliant-blue.svg)](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)
[![Version](https://img.shields.io/github/release/0mp/goat.svg)](https://github.com/0mp/goat/releases/latest)

### Quick example

```sh
[ ~/Pictures ] $ goat dev ~/Documents/devel # create a link to the dev directory
[ ~/Pictures ] $ ls # see that there is no ~/Pictures/dev directory here
seahorses wallpapers
[ ~/Pictures ] $ cd dev # the goat framework's got you covered!
[ ~/Documents/dev ] $
```

### Overview

> Oh my! This is a **POSIX-compliant** shell _movement boosting_ **hack** for
> **real ninjas**. #shortcutmanagment #[posix\_me\_harder][posix_me_harder]
> \#[posixly\_correct][posixly_correct]
>
> _~ 0mp, again_

Sometimes you jump around your filesystem tree a lot and you end up putting a
couple of ugly aliases into your shell's rc file.

> I should try it, even if it is dumb!
>
> _~ [dse] at [What the Daily WTF?] about goat v1.1.1_

With goat you can easily manage your ninja shortcuts - just type `goat p
~/Projects` to introduce a new link and then `cd p` to jump to its destination.

> Rad! I can do `cd ....` now instead of performing a horse galloping-like
> waltz with `../` being my miserable dance floor. I'm cloning this goat
> straight away!
>
> _~ YA0mp_

## Installation

```sh
git clone https://github.com/0mp/goat
cd goat
./setup
# Consider running `printf "%s\n" 'PATH:~/bin:$PATH' >> ~/.bashrc`
# if ~/bin isn't already in your $PATH.
. ~/.bashrc
```

See `./setup --help` for setup options.

## Usage overview

```sh
# Create a link (h4xdir) to a directory:
goat h4xdir ~/Documents/dev

# Follow the link to change the directory:
cd h4xdir

# Go up the filesystem tree with '...' instead of '../../':
cd ...

# List all your saved shortcuts:
goat list

# Delete an absolute shortcut from your saved shortcuts:
goat delete h4xdir

# Delete all saved shortcuts:
goat nuke

# Print the help message:
goat help
```

## Configuration

You might wish to tinker with the `setup` in order to customize the installation
parameters. To install `goat` you've got to:

- Put `goat` in a directory in your `$PATH`.
- Add a custom `cd` function from the `setup` file to your shell rc file.
- Make sure that `goat` stores the links in a place you want by setting
  `$GOAT_PATH` in `goat`.

## Development

See `CONTRIBUTING.md`.

### Testing

```sh
./lint
GOAT_PATH= ./test
```

## License

Licensed under MIT license. Copyright &#169; 2016, 2017 Mateusz Piotrowski

[posix_me_harder]: http://wiki.wlug.org.nz/POSIX_ME_HARDER
[posixly_correct]: http://wiki.wlug.org.nz/POSIXLY_CORRECT
[dse]: https://what.thedailywtf.com/user/dse
[What the Daily WTF?]: https://what.thedailywtf.com/topic/16122/quick-links-thread/2121
