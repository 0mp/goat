# goat

[![Build Status](https://travis-ci.org/0mp/goat.svg?branch=master)](https://travis-ci.org/0mp/goat)
[![POSIX Compliance](https://img.shields.io/badge/POSIX-compliant-blue.svg)](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)
[![Version](https://img.shields.io/github/release/0mp/goat.svg)](https://github.com/0mp/goat/releases/latest)

### Overview

> I used to retrieve carefully-constructed `cd` commands from my history. 
> But then, I got a goat.
>
> _~&#32;[Jonathan Paugh][jpaugh] on [Google+]_

```sh
[ ~/Pictures ] $ goat dev ~/Documents/devel # create a link to the dev directory
[ ~/Pictures ] $ ls # see that there is no ~/Pictures/dev directory here
seahorses wallpapers
[ ~/Pictures ] $ cd dev # the goat framework's got you covered!
[ ~/Documents/devel ] $
```

> Oh my! This is a **POSIX-compliant** shell _movement boosting_ **hack** for
> **real ninjas**.<br>
> #[posix\_me\_harder][posix_me_harder] #[posixly\_correct][posixly_correct]
>
> _~&#32;0mp_

Sometimes you jump around your filesystem tree a lot and you end up putting a
couple of ugly aliases into your shell's rc file.

> I should try it, even if it is dumb!
>
> _~&#32;[dse] on [What the Daily WTF?] about goat v1.1.1_

With goat you can easily manage your ninja shortcuts - just type `goat p
~/Projects` to introduce a new link and then `cd p` to jump to its destination.

> Rad! I can do `cd ....` now instead of performing a horse galloping-like
> waltz with `../` being my miserable dance floor. I'm cloning this goat
> straight away!
>
> _~&#32;YA0mp_

BTW, Bash completion is now fully working with goat's shortcuts.

## Installation

```sh
git clone https://github.com/0mp/goat
cd goat
./setup
# Consider running `printf "%s\n" '~/bin:$PATH' >> ~/.bashrc`
# if ~/bin isn't already in your $PATH.
. ~/.bashrc
```

See `./setup --help` for advanced options.

## Usage overview

```sh
# Create a link (h4xdir) to a directory:
goat h4xdir ~/Documents/dev

# Follow a link to change a directory:
cd h4xdir

# Follow a link (and don't stop there!):
cd h4xdir/awesome-project

# Go up the filesystem tree with '...' (same as `cd ../../`):
cd ...

# List all your links:
goat list

# Delete a link (or more):
goat delete h4xdir lojban

# Delete all the links which point to directories with the given prefix:
goat deleteprefix $HOME/Documents

# Delete all saved links:
goat nuke

# Delete broken links:
goat fix

# Print the help message:
goat help
```

## Development

See `CONTRIBUTING.md`.

### Testing

```sh
./lint
./test
```

## License

Licensed under BSD license. Copyright &#169; 2016-2018 Mateusz Piotrowski

[posix_me_harder]: http://wiki.wlug.org.nz/POSIX_ME_HARDER
[posixly_correct]: http://wiki.wlug.org.nz/POSIXLY_CORRECT
[dse]: https://what.thedailywtf.com/user/dse
[What the Daily WTF?]: https://what.thedailywtf.com/topic/16122/quick-links-thread/2121
[Google+]: https://plus.google.com/113949504369826627206/posts/bqSfYTrQxLN
[jpaugh]: https://github.com/jpaugh
