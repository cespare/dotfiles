# Notes

A random assortment of configuration/compile settings that I'd like to not forget.

Things marked (LT) are laptop-specific directions (Dell XPS 13).

## New XFCE setup

* Install xubuntu
* In xfce appearance settings, set (this is with 4k monitors):
  - Default font: Roboto 9
  - Enable anti-aliasing (no hinting)
  - Custom DPI of 128 (LT: 192)
* LT: Power manager settings:
  - Enable "Handle display brightness keys"
  - When laptop lid is closed -> suspend
  - When sleep button is pressed -> suspend
* In the window manager shortcuts, set "switch windows for the same application" to alt+`.
* Go into xfce keyboard shorcuts and delete most of them. Keep:
  - xfce4-appfinder (bind to super-space)
  - screenshooter shortcuts
  - xflock
  - xkill
* In xfce keyboard settings: change key repeat and delay:
  - delay: 250
  - speed: 40
* In window manager tweaks, change the key for moving windows from alt to super.
* (Not LT:) In xfce mouse & touchpad settings, set pointer speed to:
  - acceleration: 1.0
  - sensitivity: 4 px
  (For 1600 DPI hardware setting)
* LT: Set up touchpad following the section at the bottom.
* Set cursor size settings.
  - In mouse & touchpad settings > Theme
    * Set theme to DMZ-White
    * Set size to 48px (laptop) or 32px (desktop)
  - There's also an issue where lightdm has the wrong cursor size and sometimes
    it can remain set on the root window once logged in. Fix this by editing
    `/etc/gtk-3.0/settings.ini` and adding two lines matching the options set in
    xfce:

        gtk-cursor-theme-name = DMZ-White
        gtk-cursor-theme-size = 32

* Panel properties:
  - Unlock -> move to bottom -> lock
  - Alpha: 100
  - LT: Row size: 36
* LT: panel > items > Status Notifier Plugin > edit
  - Maximum icon size: 36
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
* Install Chrome
* Install DropBox
* Copy in files from backup/previous installation:
  - ~/.ssh
  - ~/.fonts
* Install:
  - git
  - vim
  - vim-gtk
  - zsh
  - xbindkeys
  - xdotool
  - screen
  - ttf-mscorefonts-installer
  - fonts-roboto
  - openssh-server
  - gnome-screenshot
  - tmux
  - keepassxc
  - keychain
  - build-essential
  - silversearcher-ag
  - xclip
* Ensure keychain is set up (.zshrc.private etc will have
  an invocation like `eval $(keychain --quiet --eval --agents ssh id_rsa)`
* Clone dotviles, vim-config and move into place
* Log out and back in for xmodmap (or just run it manually)
* Install Go
* xbindkeys uses github.com/cespare/carlisle, so install that.
  - Put the binary in $HOME/bin, so that the XDG autostart thing that runs
    xbindkeys will be able to see it.
* Passwordless sudo by changing sudoers to have: `%sudo	ALL=(ALL:ALL) NOPASSWD: ALL`
* Configure ssh server not to accept passwords but only pub key
* Copy in /etc/fstab from previous installation and make sure everything's peachy
* Make grub not use a splash screen:
  - Edit /etc/default/grub and change "quiet splash" to "text"
  - Run `update-grub2` to update it
* Fix LightDM DPI by editing /etc/lightdm/lightdm-gtk-greeter.conf
  - Need line: xft-dpi=192 (or whatever DPI setting in xfce is)
* LT: Install Greybird from source here: https://github.com/shimmerproject/Greybird/tree/xfwm4-hidpi
  - That branch has an experimental hidpi build
  - Then switch the theme to greybird-hidpi
* LT: Disable bluetooth on startup: `sudo systemctl disable bluetooth.service`
* LT: Fix sleep bug (https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1808957):
  - As root: `echo deep > /sys/power/mem_sleep`
  - Edit /etc/default/grub: `GRUB_CMDLINE_LINUX_DEFAULT="text mem_sleep_default=deep"`
  - `sudo update-grub2`
* Raise file descriptor limits by editing /etc/security/limits.conf to have

  ```
  *                soft    nofile          50000
  *                hard    nofile          50000
  ```

## Assorted fixes

* If nvidia-settings isn't persisted, open up the xfce display settings, make
  sure it's good, and hit 'apply' there too.
* After setting up nvidia-settings, use it to save an xorg.conf file to the
  usual location. Then edit that file to add

      Section "Files"
          ModulePath "/usr/lib/x86_64-linux-gnu/nvidia/xorg"
          ModulePath "/usr/lib/xorg/modules"
      EndSection

  This fixes lightdm resolution ([source](https://bugs.launchpad.net/ubuntu/+source/light-locker/+bug/1760068)).
* If suspend is broken (kern.log has stuff like `ps: xfsm-shutdown-h[4863] general protection ip:7f359efcf9fd sp:7ffdf8d67670 error:0 in libc-2.27.so[7f359ef38000+1e7000]`)
  it might be fixed by removing light-locker and using xscreensaver instead.
* If running govim causes vim to be slow to exit in directories with lots of Go
  code underneath, raise the `fs.inotify.max_user_watches` setting in sysctl.

## alacritty

    sudo add-apt-repository ppa:mmstick76/alacritty
    sudo apt install alacritty

## vim

Clone https://github.com/vim/vim.git.

    $ sudo apt build-dep vim
    $ ./configure --with-features=huge --enable-gui=gtk2 --enable-pythoninterp --enable-rubyinterp --prefix=$HOME --enable-perlinterp

## tmux

    $ sudo apt build-dep tmux
    $ ./configure --prefix=$HOME
    $ make && make install

## Ripgrep

* Download the latest release from https://github.com/BurntSushi/ripgrep/releases
* Unpack
* Copy `rg` to /usr/local/bin and `doc/rg.1` to /usr/local/man/man1

## fzf

    $ go get -u github.com/junegunn/fzf
    $ cp ~/p/go/src/github.com/junegunn/fzf/bin/* ~/bin

## Mount GCS bucket

Install [gcsfuse](https://github.com/GoogleCloudPlatform/gcsfuse) and
authenticate.

Add fstab entry:

    home.ctrl-c.us  /mnt/gcs gcsfuse rw,noauto,user

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

## ag

    $ g clone https://github.com/ggreer/the_silver_searcher ag
    $ cd ag
    $ sudo apt build-dep silversearcher-ag
    $ ./build.sh --prefix=$HOME
    $ make install

# Windows 10

1. Unpin everything from the task bar and start bar (right click -> unpin works on most things)
2. Install Chrome; set as default browser
3. Install SharpKeys; swap caps lock and escape: https://github.com/randyrants/sharpkeys
4. Fix key repeat rate: open control panel > keyboard > repeat delay all the way to "short", repeat rate all the way to "fast"
5. Download and install dropbox
6. Download and install KeepassXC

# Dell XPS 13

## Touchpad

These were necessary to get libinput working properly with Ubuntu 18.04/XFCE.

    sudo apt install --install-recommends linux-generic-hwe-18.04 xserver-xorg-hwe-18.04

It seemed like having both libinput and synaptic running made the touchpad stop
working sometimes. So, disable synaptic.

Use `xinput list` to show devices. Create
`/etc/X11/xorg.conf.d/51-synaptics-quirks.conf` with the following contents
(these are customizations; you can look at /usr/share/X11/... to see the
systemwide configuration).

```
# Disable generic Synaptics device, as we're using
# "DELL08AF:00 06CB:76AF Touchpad"
# Having multiple touchpad devices running confuses syndaemon.
Section "InputClass"
  Identifier "SynPS/2 Synaptics TouchPad"
  MatchProduct "SynPS/2 Synaptics TouchPad"
  MatchIsTouchpad "on"
  MatchOS "Linux"
  MatchDevicePath "/dev/input/event*"
  Option "Ignore" "on"
EndSection
```

After rebooting, there should be only a single touchpad driver (plus the touchscreen).

Install up-to-date libinput:

    sudo apt install xserver-xorg-input-libinput-hwe-18.04 libinput-tools

It seems that the XFCE settings manager (xfce4-settings-manager) doesn't handle
libinput configuration. Configure it by creating the file
`/etc/X11/xorg.conf.d/40-libinput.conf`:

```
# Custom settings for Dell touchpad.
# See 'man 4 libinput' for info about the options.
Section "InputClass"
  Identifier "libinput touchpad catchall"
  MatchIsTouchpad "on"
  MatchDevicePath "/dev/input/event*"
  Option "Tapping" "True"
  # Tap-to-drag requires a double-tap (or one-and-a-half).
  Option "TappingDrag" "True"
  Option "ScrollMethod" "twofinger"
  Option "AccelSpeed" "1.0"
  Option "HorizontalScrolling" "True"
  Driver "libinput"
EndSection
```

You can use `xinput list-props 12` (ID is given by `xinput list`) to show the
available properties of the device.

Changing the xorg conf file requires an X restart, so you can more easily play
around with settings by using a command like

    xinput set-prop 12 <option-number> <setting>

## Avahi

Avahi tends to use a bunch of CPU. Disable it with:

    sudo systemctl disable avahi-daemon.socket
    sudo systemctl disable avahi-daemon.service
    sudo systemctl stop avahi-daemon.socket
    sudo systemctl stop avahi-daemon.service

Comment out the "Wants" line in /lib/systemd/system/cups-browsed.service:

    # Wants=avahi-daemon.service

## Auto display backlight dimming

The screen of this machine dims automatically depending on the content of the
screen (brighter when the screen is mostly white, for example). This leads to
incredibly annoying behavior when using white text on dark background (say vim
in full-screen) where the backlight constantly changes its setting.

Disable this in the BIOS:

    Video > Dynamic Backlight Control > Disabled

## "Failed to connect to lvmetad" boot error

I randomly got an error on boot like

    WARNING: Failed to connect to lvmetad. Falling back to device scanning.
    ...
    ALERT! /some/disk does not exist.
    ...

It looks like this was caused by a bad BIOS setting. (Not sure how it got
reset.) The fix is:

    System Configuration > SATA Operation > Change "RAID On" to "AHCI"
