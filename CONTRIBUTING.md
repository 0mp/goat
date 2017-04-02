# Development

## Use `./lint` to test POSIX compliance and avoid common errors

```sh
./lint
```

## Testing

Set `$GOAT_PATH` to nothing in order to create a testing environment.

```sh
GOAT_PATH= ./test
```

# Style

It is loosely based on [the FreeBSD style(9)][style9]. It is not a shell
scripting style guide but you'll get the idea.

[style9]: https://www.freebsd.org/cgi/man.cgi?query=style&sektion=9
