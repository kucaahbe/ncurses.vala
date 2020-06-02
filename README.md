# Vala (n)curses missing API bindings and usage examples

This repo contains various aspects of using (curses) with Vala programming languange.
Each example demonstrates some specific usage, for details refer to source code.
Upon compiling for each Vala source file corresponding C source file is being generated,
helps with debugging issues related to Vala's garbage collector, e.g. it may free() unused variable,
making code misbehave in unobvious way. TIP: in order to prevent this, the best practice seems to use instance-level
variables as much as possible, keep an eye on local variables and ownership.

Tested on Ubuntu 20.04 (LTS) and OSX 10.15 Catalina (with ncurses from homebrew, default ncurses seems out of commission)

## Prerequisites installation:

### Ubuntu

```
sudo apt install build-essential libncurses libncurses-dev valac
```

### OSX

```
brew install ncurses vala
```

## up and running:

```
make -j

```

Each demo will have fancy .exe extension, run it.
