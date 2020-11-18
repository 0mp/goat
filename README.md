# goat

[![Version](https://img.shields.io/github/release/0mp/goat.svg)](https://github.com/0mp/goat/releases/latest)

### Overview

> I used to retrieve carefully-constructed `cd` commands from my history. 
> But then, I got a goat.
>
> _~&#32;[Jonathan Paugh][jpaugh] on [Google+]_

```script
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

See `Makefile` for more details.

### System-wide installation

```script
# make install
```

### Local installation

If you'd rather install it locally for your user only then: 

```script
$ make PREFIX="$HOME/.local" install
```

Aferwards:

- Make sure that `~/.local/bin` is in your `PATH`:

  ```script
  $ cat <<'EOF' >> ~/.bashrc
  case "$PATH" in
      *$HOME/.local/bin*) ;;
      *) PATH="$HOME/.local/bin:$PATH" ;;
  esac
  EOF
  ```

- Make sure that files inside `~/.local/etc/bash_completion.d` are actually
  sourced by the Bash completion library:

  ```script
  $ cat <<'EOF' >> ~/.bash_completion
  if [[ -d ~/.bash_completion.d ]]
  then
      for f in ~/.local/etc/bash_completion.d/*
      do
          [[ -f $f ]] && source "$f"
      done
  fi
  EOF
  ```

## Usage overview

```script
Create a shortcut named “f” to ~/Documents/dev/freebsd (no need to use
the link command explicitly here):

      $ goat f ~/Documents/dev/freebsd

Follow a link to change a directory with cd(1):

      $ cd f

Take the “f” shortcut and enter its destination subdirectory with just
one command:

      $ pwd
      /home/0mp
      $ cd f/ports
      $ pwd
      /usr/home/0mp/freebsd/ports

Create a shortcut named “p” to the current directory:

      $ goat p .

Go up the filesystem tree with ... (same as the standard “cd ../../”):

      $ cd ...

List all your links:

      $ goat list
      dots    ->      /usr/home/0mp/.dotfiles
      down    ->      /usr/home/0mp/Downloads
      f       ->      /usr/home/0mp/freebsd
      p       ->      /usr/home/0mp/freebsd/ports
      pa      ->      /usr/home/0mp/freebsd/patches
      src     ->      /usr/home/0mp/freebsd/svn/src
      svn     ->      /usr/home/0mp/freebsd/svn

Delete a link (or more):

      $ goat delete f p

Delete all the links which point to directories with the given prefix:

      $ goat deleteprefix "$HOME/Documents"
```

## License

Licensed under BSD license. Copyright &#169; 2016-2018 Mateusz Piotrowski

[posix_me_harder]: http://wiki.wlug.org.nz/POSIX_ME_HARDER
[posixly_correct]: http://wiki.wlug.org.nz/POSIXLY_CORRECT
[dse]: https://what.thedailywtf.com/user/dse
[What the Daily WTF?]: https://what.thedailywtf.com/topic/16122/quick-links-thread/2121
[Google+]: https://plus.google.com/113949504369826627206/posts/bqSfYTrQxLN
[jpaugh]: https://github.com/jpaugh
