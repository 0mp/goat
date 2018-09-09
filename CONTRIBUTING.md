# Development

Required software:

 - ShellCheck
 - checkbashisms
 - mandoc

## Use `./lint` to test POSIX compliance and avoid common errors

```sh
make lint
```

## Testing

```sh
./test
```

# Style

It is loosely based on [the FreeBSD style(9)][style9]. It is not a shell
scripting style guide but you'll get the idea.

[style9]: https://www.freebsd.org/cgi/man.cgi?query=style&sektion=9
