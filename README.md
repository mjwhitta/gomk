# gomk

[![Yum](https://img.shields.io/badge/-Buy%20me%20a%20cookie-blue?labelColor=grey&logo=cookiecutter&style=for-the-badge)](https://www.buymeacoffee.com/mjwhitta)

## What is this?

A "simple" `Makefile` solution for Go projects. It attempts to
automate a lot of tasks for you. There are targets such as
`reportcard` which will "grade" your code and provide warnings where
necessary. The default target is `build` and it will compile each
subdirectory in `./cmd`. However, it can be redefined in your
top-level `Makefile`, if needed. See below for an example.

## How to install

Open a terminal, navigate to your git repo, and run the following:

```
$ git submodule add https://github.com/mjwhitta/gomk.git
$ cp gomk/Makefile.template Makefile
```

Alternatively, if not a git repo, you can use `curl`:

```
$ curl -Lo gomk.zip -s \
    "https://github.com/mjwhitta/gomk/archive/refs/heads/main.zip"
$ unzip gomk.zip
$ mv gomk-main gomk
$ cp gomk/Makefile.template Makefile
```

## Usage

After adding gomk as a submodule, and copying the template `Makefile`,
you can modify as needed. The targets defined by gomk end with
`-default` and can be redefined by creating your own without the
`-default`. You can also add your own targets specific to your
project. Below are some examples:

```
# Override the build-default recipe
build: justonething;

# Override the debug-default recipe with an empty recipe
debug: fmt;

# Add new recipes specific to your project
justonething: dir fmt
    @go build -o "$(OUT)" ./cmd/justonething
```

### Special cases

There are three special targets which set some environment variables,
then run the `build` target.

Target      | Description
---         | ---
`cgo`       | Compiles with `cgo` support
`cgogarble` | Compiles with `cgo` support using `garble` compiler
`garble`    | Compiles with `garble` compiler

## Links

- [Source](https://github.com/mjwhitta/gomk)
