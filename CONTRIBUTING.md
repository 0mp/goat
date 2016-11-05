# Development

Travis CI is set up and it runs `test/test.sh` and `lint`.

## Build a development goat

`./goatherd target` builds ready to use `goat.sh` and `leash.sh` and puts them
in `target/`. Unless you run `./goatherd install` they won't be available
gloablly.

## Run tests

```sh
cd test
sh ./test.sh
```

## Check POSIX-compliance and avoid common errors

```sh
./lint
```

# Style

- Use 2 spaces for indentation.

- Variables intented to be used as global variables should look like this:

  ```sh
  gGLOBAL_VARIABLE
  ```

- Constant variables like directory names should be declared like this:

  ```sh
  readonly kCONSTANT_VARIABLE='constant value'
  ```

- Variables should be always put in double quotes if possible.

- Every string should be put in single quotes by default or double quotes if
  needed.
