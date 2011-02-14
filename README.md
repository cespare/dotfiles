Cespare's Dotfiles
------------------

This is a repository containing my typical configuration files. It has a bunch of useful stuff that I like to
have backed up and ready to put on a new machine to make it usable. Note that my vim configuration is a
separate repository.

Some notes about specific files/directories:

* `.bashrc.cespare` The way I configure bash is by sourcing `.bashrc.cespare` from whatever bashrc my platform
  gives me. (If I'm making a `.bashrc` from scratch, then I'll just put this in it:
      source $HOME/.bashrc.cespare
  There are platform- and work-specific `.bashrc` files which are pulled in as needed by `.bashrc.cespare`.
  I try to add things to the most general `.bashrc`.
* When I build software by hand, I symlink the executable in `$HOME/bin`. This stuff should not be in version
  control.
* `scripts/` This is a directory of useful little scripts. Some of them are very platform-specific. Some are
  things I wrote years ago. There's no guarantee any of them are sane/useful/safe.
