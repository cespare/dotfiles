# Notes

A random assortment of configuration/compile settings that I'd like to not forget.

## New XFCE setup

* Install xubuntu
* Install Chrome
* Install DropBox
* Copy in files from backup/previous installation:
  - ~/.ssh
  - ~/.fonts
  - ~/.weechat
* Install:
  - git
  - vim
  - vim-gtk
  - zsh
  - xbindkeys
  - xdotool
  - screen
  - ttf-mscorefonts-installer
  - openssh-server
  - gnome-screenshot
  - tmux
  - keepassxc
  - keychain
* Ensure keychain is set up (.zshrc.private etc will have
  an invocation like `eval $(keychain --quiet --eval --agents ssh id_rsa)`
* Clone dotviles, vim-config and move into place
* Log out and back in for xmodmap (or just run it manually)
* xbindkeys uses github.com/cespare/carlisle, so install that.
  - Put the binary in $HOME/bin, so that the XDG autostart thing that runs
    xbindkeys will be able to see it.
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
* In window manager tweaks, change the key for moving windows from alt to super.
* In the window manager shortcuts, set "switch windows for the same application" to alt+`.
* In xfce mouse & touchpad settings, set pointer speed to:
  - acceleration: 1.0
  - sensitivity: 4 px
  (For 1600 DPI hardware setting)
* Configure ssh server not to accept passwords but only pub key
* Copy in /etc/fstab from previous installation and make sure everything's peachy
* Copy in /etc/cron.daily/fstrim from previous installation (note future ubuntu versions should obviate this)
* Make grub not use a splash screen:
  - Edit /etc/default/grub and change "quiet splash" to "text"
  - Run `update-grub2` to update it
* Panel properties:
  - Alpha: 100
* Set up dual clocks:
  - Right click > Panel > Add new items... > select Clock
  - Custom format: `%d %b %H:%M %Z`
  - Second clock has Timezone field set to UTC
* Add CPU graph:
  - Right click > Panel > Add new items... > select CPU Graph
  - Change properties (Appearance):
    - Color 1: #3087E1
    - Background: #242424
    - Bars color: #3087E1
  - Change properties (Advanced):
    - Update interval: 500ms
    - Width: 120
    - Deselect "Show border"

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

## Packages

* weechat-curses

## System setup

* Work around the cursor size bug using the solution here:
  https://bugs.launchpad.net/ubuntu/+source/unity-greeter/+bug/1024482
* Work around Dropbox icon indicator not working:
  https://askubuntu.com/questions/795857/script-for-fixing-missing-dropbox-icon/795864#795864
* Configure xfce4-terminal to open links with the correct browser: edit
  ~/.config/mimeapps.list to have the following underneath `[Default Applications]`:

        x-scheme-handler/http=exo-web-browser.desktop
        x-scheme-handler/https=exo-web-browser.desktop

## yubikey + gmail

* Install udev rule here: http://forum.yubico.com/viewtopic.php?t=1545&p=5991\

# Windows 10

1. Unpin everything from the task bar and start bar (right click -> unpin works on most things)
2. Install Chrome; set as default browser
3. Install SharpKeys; swap caps lock and escape: https://github.com/randyrants/sharpkeys
4. Fix key repeat rate: open control panel > keyboard > repeat delay all the way to "short", repeat rate all the way to "fast"
5. Download and install dropbox
6. Download and install KeepassXC
