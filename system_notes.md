# Notes

A random assortment of configuration/compile settings that I'd like to not forget.

Things marked (LT) are laptop-specific directions (Dell XPS 13).

## New XFCE setup

* Install xubuntu
* In xfce appearance settings, set (this is with 4k monitors):
  - Enable anti-aliasing (no hinting)
  - Custom DPI of 128 (LT: 192)
* Make grub not use a splash screen:
  - Edit /etc/default/grub and change "quiet splash" to "text"
  - Run `update-grub2` to update it
* LT: Window Manager > Style > Theme > Select "Default-xhdpi"
* LT: Increase the TTY text size by following the directions in the laptop setup
  section below.
* Right click > Desktop settings > Icons > Uncheck all
* LT: Configure suspend/hibernation following the directions below.
* LT: Power manager settings:
  - General:
    * Enable "Handle display brightness keys"
    * Brightness step count -> 20 (leave "exponential" unchecked)
  - System (On battery and plugged in both):
    * Suspend when inactive for (never). (Prefer to only suspend when lid closed.)
    * When laptop lid is closed > Lock screen
    * Check "Lock screen when system is going to sleep"
  - Display (On battery and Plugged In both)
    * Display power management checked
    * Blank after > never (Note that blank/sleep/off are essentally the same for a modern display.)
    * Put to sleep after > never
    * Switch off after > 3 minutes (10 minutes for Plugged in)
    * On inactivity reduce to > 5%
    * Reduce after > 60 seconds
* In the window manager shortcuts, set "switch windows for the same application" to alt+\`.
* Go into xfce keyboard shorcuts and delete most of them. Keep:
  - xfce4-popup-whiskermenu
  - xfce4-screenshooter
  - xflock4
  - xkill
* In xfce keyboard settings: change key repeat and delay:
  - delay: 250
  - speed: 40
* In window manager tweaks, change the key for moving windows from alt to super.
* LT: Set up touchpad following the section at the bottom.
* Set cursor size settings.
  - In mouse & touchpad settings > Theme
    * Set theme to DMZ-White
    * Set size to 48px (laptop) or 32px (desktop)
* Panel properties:
  - Unlock -> move to bottom -> lock
  - Row size: 30 (LT: 36)
* LT: panel > items > Status Tray Plugin > edit
  - Icons -> Turn on "Adjust size automatically"
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
* If desired, add CPU temp status:
  - `sudo apt install xfce4-sensors-plugin`
  - Right click > Panel > Add new items... > select Sensors
  - Configure: select CPU temp
    * For laptop it's coretemp-0 > "Package id 0"
    * Set the color to #FFFFFF
  - In View, uncheck "Show title" and "Show labels"
    * Now it should just be a single temp shown
* Install Chrome
  - Sign into Google
  - Sign into 1Password
* Copy in files from backup/previous installation:
  - ~/.ssh
  - ~/.fonts
* Install the git PPA:

      sudo add-apt-repository ppa:git-core/ppa

* Install:
  - build-essential
  - curl
  - fonts-roboto
  - gh
  - git
  - gnome-screenshot
  - htop
  - keychain
  - openssh-server
  - python3-pip
  - ripgrep
  - screen
  - tmux
  - ttf-mscorefonts-installer
  - xbindkeys
  - xclip
  - xdotool
  - zsh
* In xfce appearance settings, set default font to Roboto Regular 9.
* Install neovim (directions below)
* Clone dotiles, nvim-config and move into place
* Ensure keychain is set up (.zshrc.private etc will have
  an invocation like `eval $(keychain --quiet --eval --agents ssh id_rsa)`
* Log out and back in for xmodmap (or just run it manually)
* Install Go
* xbindkeys uses github.com/cespare/carlisle, so install that.
  - Put the binary in $HOME/bin, so that the XDG autostart thing that runs
    xbindkeys will be able to see it.
* Install alacritty (see below). Now launching normal terminal via xbindkeys
  should work.
* Passwordless sudo by changing sudoers to have: `%sudo	ALL=(ALL:ALL) NOPASSWD: ALL`
* Configure ssh server not to accept passwords (`PasswordAuthentication no`)
* Fix LightDM DPI by editing /etc/lightdm/lightdm-gtk-greeter.conf
  - Need line: xft-dpi=192 (or whatever DPI setting in xfce is)
* LT: Disable bluetooth on startup: `sudo systemctl disable bluetooth.service`
* Raise file descriptor limits by editing /etc/security/limits.conf to have

  ```
  *                soft    nofile          50000
  *                hard    nofile          50000
  ```
* Install and configure syncthing (see details in home repo).

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

    git clone https://github.com/alacritty/alacritty.git
    cd alacritty
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    rustup override set stable
    rustup update stable
    sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
    cargo build --release
    cp target/release/alacritty ~/bin/
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database
    sudo mkdir -p /usr/local/share/man/man1
    gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
    gzip -c extra/alacritty-msg.man | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null

## vim

Clone https://github.com/vim/vim.git.

    $ sudo apt build-dep vim
    $ ./configure --with-features=huge --enable-gui=gtk2 --enable-pythoninterp --enable-rubyinterp --prefix=$HOME --enable-perlinterp

## tmux

    $ sudo apt build-dep tmux
    $ ./configure --prefix=$HOME
    $ make && make install

## Neovim

Install from official PPA.

## Ripgrep

* Download the latest release from https://github.com/BurntSushi/ripgrep/releases
* Unpack
* Copy `rg` to /usr/local/bin and `doc/rg.1` to /usr/local/man/man1

## fzf

    $ go install github.com/junegunn/fzf@latest

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

# Windows 10

1. Unpin everything from the task bar and start bar (right click -> unpin works on most things)
2. Install Chrome; set as default browser
3. Install Powertoys: https://learn.microsoft.com/en-us/windows/powertoys/
4. Fix key repeat rate: open control panel > keyboard > repeat delay all the way to "short", repeat rate all the way to "fast"

# Dell XPS 13

## Make the TTY text readable

At full 4k resolution the TTY text is extremely small.

Two fixes are required, one for grub and one for the kernel framebuffer.

* For grub, we will simply run it at a lower resolution, edit `/etc/default/grub` and add

      GRUB_GFXMODE=1920x1080

  and then run `update-grub2`.
* For Linux, we will run at full resolution but select a larger font. Run

      sudo dpkg-reconfigure console-setup

  and navigate the menu. Select all default options initially. When choosing a
  font, select Terminus and then 16x32.

## Configure suspend and hibernate

The default suspend state is s2idle which still has quite a lot of battery
drain. We want to use deep suspend which disables all the hardware except for
memory refreshes. Additionally, we want to use hibernation (suspending to disk)
for longer-term suspension because that is the lowest drain rate possible. In
particular, I use the `suspend-then-hibernate` feature which suspends
immediately and then, after a configurable amount of time, hibernates and shuts
down.

To test all this out, run

    sudo systemctl suspend

or

    sudo systemctl suspend-then-hibernate

After waking up, check syslog to verify which suspend level was used.

First, change the suspend mode from `s2idle` to `deep`:

* `echo deep | tee /sys/power/mem_sleep` to change it temporarily.
* To lock it in, edit `/etc/default/grub` to have

      GRUB_CMDLINE_LINUX_DEFAULT="text mem_sleep_default=deep"

  (This assumes the only existing directive was `text`.)

Next, check that hibernate works. (Maybe need to install `pm-utils`?)

The default suspend-to-hibernate delay is reasonable (2h). However, we can test
that it's working by editing `/etc/systemd/sleep.conf` and adding

    HibernateDelaySec=45s

Then invoke suspend-then-hibernate and make sure that it hibernates after 45s.
Debug issues by examining logind logs:

    sudo journalctl -u systemd-logind.service

Finally, we want systemctl/login to manage suspend rather than
xfce4-power-manager. Open Settings Editor and inside the xfce4-power-manager
section check `logind-handle-lid-switch`. Now logind should handle lid
open/close events rather than xfce. Test that it works and again look at the
logind logs for debugging.

Note that there is an unsolved bug where the lock screen doesn't render
correctly after waking from suspend: https://gitlab.xfce.org/apps/xfce4-screensaver/-/issues/1
When this happend, the desktop is displayed but is not interactive. Blindly type
the password to unlock.

Links:

* https://luisartola.com/solving-the-framework-laptop-battery-drain/
* https://askubuntu.com/questions/12383/how-to-go-automatically-from-suspend-into-hibernate
* https://askubuntu.com/questions/1072504/lid-closed-suspend-then-hibernate
* https://docs.xfce.org/xfce/xfce4-power-manager/faq

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

# Obsolete?

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

## Xubuntu/lightdm cursor size issue

(This no longer seems to be an issue as of Ubuntu 22.04.)

Sometimes lightdm has the wrong cursor size and it can remain set on the root
window once logged in. Fix this by editing `/etc/gtk-3.0/settings.ini` and
adding two lines matching the options set in xfce:

    gtk-cursor-theme-name = DMZ-White
    gtk-cursor-theme-size = 32


## Dell XPS 13 Touchpad stuff

(As of 22.04 none of this seems to be necessary: synaptic isn't installed by
default; scrolling is configurable through the XFCE touchpad settings menu,
etc.)

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

