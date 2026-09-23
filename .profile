#!/bin/sh

## Kiro CLI pre block. Keep at the top of this file.
#[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/profile.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/profile.pre.bash"

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# make default editor Neovim
export EDITOR=nvim

# Most pure GTK3 apps use wayland by default, but some,
# like Firefox, need the backend to be explicitely selected.
export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1
export GTK_CSD=0

# qt wayland
export QT_QPA_PLATFORM="wayland"
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

#Java XWayland blank screens fix
export _JAVA_AWT_WM_NONREPARENTING=1

# set default shell and terminal
# export TERMINAL_COMMAND=/usr/share/sway/scripts/foot.sh

# add default location for zeit.db
export ZEIT_DB="$HOME/.config/zeit.db"

# Disable hardware cursors. This might fix issues with
# disappearing cursors
if hash systemd-detect-virt &>/dev/null -a systemd-detect-virt -q; then
    # if the system is running inside a virtual machine, disable hardware cursors
    export WLR_NO_HARDWARE_CURSORS=1
fi

# Disable warnings by OpenCV
export OPENCV_LOG_LEVEL=ERROR

#set -eu
#set -u

set -a
. "$HOME/.config/user-dirs.dirs"
set +a

#if [ -n "$(ls "$HOME"/.config/profile.d 2>/dev/null)" ]; then
#    for f in "$HOME"/.config/profile.d/*; do
#        # shellcheck source=/dev/null
#        . "$f"
#    done
#fi

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
	  . "$HOME/.bashrc"
  fi
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

export ALL_PROXY=socks5://127.0.0.1:50080

export http_proxy=http://127.0.0.1:50080
export https_proxy=http://127.0.0.1:50080



## Kiro CLI post block. Keep at the bottom of this file.
#[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/profile.post.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/profile.post.bash"
