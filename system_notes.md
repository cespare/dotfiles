# Notes

A random assortment of configuration/compile settings that I'd like to not forget.

## New XFCE setup

* Install xubuntu
* Install Chrome
* Install DropBox
* Install keepassxc from source; see guide at https://github.com/keepassxreboot/keepassxc/wiki/Building-KeePassXC
* Copy in files from backup/previous installation:
  - ~/.ssh
  - ~/.fonts
  - ~/.weechat
* Install: keychain, git, vim, vim-gtk, zsh, xbindkeys, xdotool, weechat-curses, screen,
  ttf-mscorefonts-installer, openssh-server, gnome-screenshot
* Clone dotviles, vim-config and move into place
* Log out and back in for xmodmap (or just run it manually)
* Go into xfce keyboard shorcuts and delete most of them. Keep:
  - xfce4-appfinder (bind to super-space)
  - screenshooter shortcuts
  - xflock
* In xfce keyboard settings: change key repeat and delay:
  - delay: 250
  - speed: 40
* In xfce appearance settings, set (this is with 4k monitors):
  - Default font: Noto Sans 9
  - Enable anti-aliasing (no hinting)
  - Custom DPI of 128
* In the window manager shortcuts, set "switch windows for the same application" to alt+`.
* In xfce mouse & touchpad settings, set pointer speed to:
  - acceleration: 1.0
  - sensitivity: 4 px
  (For 1600 DPI hardware setting)
* Configure ssh server not to accept passwords but only pub key
* Copy in /etc/fstab from previous installation and make sure everything's peachy
* Copy in /etc/cron.daily/fstrim from previous installation (note future ubuntu versions should obviate this)
* Work around the cursor size bug using the solution here:
  https://bugs.launchpad.net/ubuntu/+source/unity-greeter/+bug/1024482
* Work around Dropbox icon indicator not working:
  https://askubuntu.com/questions/795857/script-for-fixing-missing-dropbox-icon/795864#795864
* Make grub not use a splash screen:
  - Edit /etc/default/grub and change "quiet splash" to "text"
  - Run `update-grub2` to update it

## vim

    $ sudo apt build-dep vim
    $ ./configure --with-features=huge --enable-gui=gtk2 --enable-pythoninterp --enable-rubyinterp --prefix=$HOME --enable-perlinterp

## tmux

    $ sudo apt build-dep tmux
    $ ./configure --prefix=$HOME
    $ make && make install

## ag

    $ g clone https://github.com/ggreer/the_silver_searcher ag
    $ cd ag
    $ sudo apt build-dep silversearcher-ag
    $ ./build.sh --prefix=$HOME
    $ make install

## fzf

    $ go get -u github.com/junegunn/fzf
    $ cp ~/p/go/src/github.com/junegunn/fzf/bin/* ~/bin

## ruby

* Linux prerequisite packages: build-essential zlib1g-dev libssl-dev openssl libreadline-dev sqlite3 libsqlite3-dev libxslt-dev libxml2-dev curl
* Gems: `bundler`, `awesome_print`

## rtorrent

* Install libtorrent and rtorrent from my forks: github.com/cespare/(lib|r)torrent.
* `./autogen.sh` in both
* `./configure --prefix=$HOME` in libtorrent
* `make && make install` in libtorrent
* `PKG_CONFIG_PATH=$HOME/lib/pkgconfig ./configure --prefix=$HOME` in rtorrent
* `make && make install` in rtorrent

## Renoise / ALSA

Renoise wants to use ALSA or Jack. But Ubuntu does Pulseaudio. If you let Renoise use the ALSA output device,
PA output (basically everything that isn't Renoise) stops working.

Solution: make an ALSA loopback device (basically a fake soundcard) and let renoise use that.

    $ sudo modprobe snd-aloop

Add to `/etc/modules` to load by default.

    $ sudo cat /proc/asound/cards

That should now show the loopback device. Start up Renoise and configure it to use the ALSA loopback device.

Run `aloop` to route the loopback to the main output:

    $ alsaloop -c 2 -C hw:Loopback,1,0 -P default

(Adjust based on what `/proc/asound/cards` shows.)

In Renoise configuration, under Keys, uncheck "Override window manager shortcuts".

# Obsolete?

## yubikey + gmail

* Install udev rule here: http://forum.yubico.com/viewtopic.php?t=1545&p=5991
