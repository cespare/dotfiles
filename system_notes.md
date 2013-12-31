# Notes

A random assortment of configuration/compile settings that I'd like to not forget.

## New XFCE setup

* Install xubuntu
* Install Chrome
* Copy in files from backup/previous installation:
  - ~/.ssh
  - ~/projects
  - ~/apps
  - ~/bin
  - ~/.fonts
  - ~/.rbenv
  - ~/.weechat
* `mkdir ~/.ssh-control`
* Install: keychain, git, vim, vim-gtk, zsh, tmux, xbindkeys, xdotool, weechat-curses, screen,
  ttf-mscorefonts-installer
* Clone dotviles, vim-config and move into place
* Log out and back in for xmodmap (or just run it manually)
* Go into xfce keyboard shorcuts and delete most of them. Keep:
  - xfce4-appfinder (bind to super-space)
  - screenshooter shortcuts
  - xflock
* In xfce keyboard settings: change key repeat and delay:
  - delay: 250
  - speed: 40
* Add xbindkeys to startup applications
* Copy in /etc/fstab from previous installation and make sure everything's peachy
* Copy in /etc/cron.daily/fstrim from previous installation (note future ubuntu versions should obviate this)

## vim

    $ sudo apt-get build-dep vim
    $ ./configure --with-features=huge --enable-gui=gtk2 --enable-pythoninterp --enable-rubyinterp --prefix=$HOME --enable-perlinterp

## rtorrent

* Install libtorrent and rtorrent from my forks: github.com/cespare/(lib|r)torrent.
* `./autogen.sh` in both
* `./configure --prefix=$HOME` in libtorrent
* `make && make install` in libtorrent
* `PKG_CONFIG_PATH=$HOME/lib/pkgconfig ./configure --prefix=$HOME` in rtorrent
* `make && make install` in rtorrent

## ruby

* Linux prerequisite packages: build-essential zlib1g-dev libssl-dev openssl libreadline-dev sqlite3 libsqlite3-dev libxslt-dev libxml2-dev curl
* Gems: `bundler`, `awesome_print`
