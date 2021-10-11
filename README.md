# gomk

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
$ git submodule add https://gitlab.com/mjwhitta/gomk.git
$ cp gomk/Makefile.template Makefile
$ make init
```

Alternatively, if not a git repo, you can use `curl`:

```
$ curl -Lo gomk.tgz -s \
    "https://gitlab.com/mjwhitta/gomk/-/archive/master/gomk-master.tar.gz"
$ tar -f gomk.tgz -xz
$ mv gomk-master gomk
$ cp gomk/Makefile.template Makefile
$ make init
```

## Usage

After adding gomk as a submodule, and copying the template `Makefile`,
you can modify as needed. The targets defined by gomk end with
`-default` and can be redefined by creating your own without the
`-default`. You can also add your own targets specific to your
project. Below are some examples:

```
# Override the build-default recipe
build: reportcard dir
    @go build -o "$(OUT)" ./cmd/justonething

# Override the debug-default recipe with an empty recipe (@true is
# required)
debug: reportcard dir
    @true

# Add new recipes specific to your project
superclean: clean
	@echo "Clean up all the stuff!"
```

## Links

- [Source](https://gitlab.com/mjwhitta/gomk)
