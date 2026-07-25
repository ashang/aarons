#
# ~/.bashrc: executed by bash(1) for non-login interactive bash shells.

# [ -x ~/.local/bin/kiro-cli ] && eval "$(~/.local/bin/kiro-cli init bash pre --rcfile bashrc)"

# ~/.bash_profile is sourced by BASH for login shells
# ~/.profile is executed by Bourne compatible login shells, sh, bash, ash, dash
# ~/.profile is *NOT* read by BASH IF ~/.bash_profile or ~/.bash_login exists

# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# See /usr/share/doc/bash-doc/examples in the Debian bash-doc package.

# Modifying /etc/skel/.bashrc directly will prevent setup from updating it.

# Ignoring failing commands
# errexit only exits the subshell, it does not exit the script.
#set -o errexit              #set -e

# Referencing undefined variables (which default to "")
#set -o nounset              #set -u

# -e : NOTE: MAY LOCK you out of logins if put into login scripts
#set -eu
#set -u

# For dealing with 'set -u':
# -e  Exit immediately if a command exits with a non-zero status.
# -u  Treat unset variables as an error when substituting.

# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in profile.

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.

#[ -z "${PS1}" ] && exit
#[ -z "$PS1" ] && return

#if [ "${BASH-no}" != "no" ]; then
#[ -f /etc/bashrc ] && . /etc/bashrc
#fi

## Shell is non-interactive.
#if [ -z "${-##*i*}" ]; then
#[[ $- != *i* ]] && return
# [ -z "${PS1-}" ] && return

[ "$BASH" ] && case $- in
*i*)
  bind 'set enable-bracketed-paste 0'
  ;;
*) return ;;
esac

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

#Shell Options
#See man bash for more options...

#Don't wait for job termination notification
set -o notify

set notildeop

# Note that A && B || C is not if-then-else. C may run when A is true.

#tmp=${PWD%/*/*}
#
#if [ -n "$tmp" ] && [ "$tmp" != "$PWD" ]; then
#    echo "${PWD:${#tmp}+1}"
#else
#    echo "$PWD"
#fi
#
#
#case "$PWD" in
#    */*/*)
#        echo "$(basename "$(dirname "$PWD")")/${PWD##*/}"
#        ;;
#    *)
#        echo "$PWD"
#        ;;
#esac
#
#dir1=$(basename "$(dirname "$PWD")")
#dir2=$(basename "$PWD")
#
#if [ "$PWD" != "/$dir1/$dir2" ] && [[ "$PWD" == */*/* ]]; then
#    echo "$dir1/$dir2"
#else
#    echo "$PWD"
#fi

short_pwd() {
  case "$PWD" in
  */*/*)
    printf "%s/%s\n" "$(basename "$(dirname "$PWD")")" "$(basename "$PWD")"
    ;;
  *)
    printf "%s\n" "$PWD"
    ;;
  esac
}

# echo "$(basename "$(dirname "$PWD")")/${PWD##*/}"

#path="$PWD"
#IFS='/' read -ra parts <<<"$path"
#
#if [ ${#parts[@]} -gt 2 ]; then
#  echo "${parts[-2]}/${parts[-1]}"
#else
#  echo "$PWD"
#fi
#

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.

# The default umask is now handled by pam_umask.
# Even for non-interactive, non-login shells.
# See pam_umask(8) and /etc/login.defs.

#/etc/profile sets 022, removing write perms to group + others.
#Set a more restrictive umask: i.e. no exec perms for others
#umask 027
##Paranoid: neither group nor others have any perms:
#umask 077

# if [ "`id -gn`" = "`id -un`" -a `id -u` -gt 99 ]; then
# id: cannot find name for group ID 1000
if [ $UID -gt 99 ] && [ "$(id -gn)" = "$(id -un)" ]; then
  umask 002
else
  umask 022
fi

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

#Use case-insensitive filename globbing
shopt -s nocaseglob

# Bash won't get SIGWINCH if another process is in the foreground.
# Check terminal size when it regains control.
# update the values of LINES and COLUMNS.
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases
shopt -s checkhash histreedit mailwarn
shopt -s hostcomplete

# export QT_SELECT=4

## ${VAR:-} is bash default value expansion, return NULL string for undefined variables.
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(</etc/debian_chroot)
fi

#${var:-value}
#如果变量 未设置或为空 → 用value
#如果变量有值 → 用变量本身

#${var:+value}
#var 未设置或为空	展开为空
#var 已设置且非空	展开为 value

# | 写法            | 含义         |
# | ------------- | ---------- |
# | `${var:-x}`   | 没值 → 用 x   |
# | `${var:=x}`   | 没值 → 赋值为 x |
# | `${var:+x}`   | 有值 → 用 x   |
# | `${var:?err}` | 没值 → 报错    |

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
# Change the window title of X terminals
case ${TERM} in
alacritty | vte* | [aEkx]term*)
  PS1='\# - \[\033]0;\u@\h:\w\007\]'
  TITLEBAR='\[\e]0;\u:${NEW_PWD}\007\]'
  #PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
  PROMPT_COMMAND='printf "%b" "\033]0;${PWD/$HOME/~}\007"'

  #PS1='\[\e[38;5;167m\]\h\[\e[33m\] $(PWD)\[\e[38;5;210m\]$(__git_prompt)\[\e[38;5;203m\] $\[\e[0m\]'
  ;;
screen*)
  PS1='\[\033k\u@\h:\w\033\\\]'
  #PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"' ;;
  PROMPT_COMMAND='printf "%b" "\033_${PWD/$HOME/~}\033\\"'
  ;;
*)
  unset PS1
  TITLEBAR=""
  ;;
esac

# Source profile.d even though "it's meant to be for login shells
# only". This is commented out by default, for not cluttering the
# shell with things a user might not expect.  Please see above
# for the explict hooks for bash-completion and command-not-found.

#if [ -d /etc/profile.d ]; then
#  for _i in /etc/profile.d/*.sh; do
#    if [ -r $_i ]; then
#      . $_i
#    fi
#  done
#  unset _i
#fi

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

#History Options {{{

#The '&' is a special pattern which suppresses duplicate entries.
#HISTIGNORE="[ \t]*:&:[fb]g:pwd:date:exit:* --help"
HISTIGNORE="&:[fb]g:pwd:date:exit:* --help"

# Save each command to the history file as it's executed.
# This does mean sessions get interleaved when reading later on, but this
# way the history is always up to date.  History is not synced across live
# sessions though; that is what `history -n` does.
# Disabled by default due to concerns related to system recovery when $HOME
# is under duress, or lives somewhere flaky (like NFS).  Constantly syncing
# the history will halt the shell prompt until it's finished.
#PROMPT_COMMAND='history -a'

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# Larger bash history (default is 500)
# Maximum number of history lines in memory
HISTSIZE=50000
# Maximum number of history lines on disk
HISTFILESIZE=60000

# When the shell exits, append to the history file
# don't overwrite it
shopt -s histappend

#HISTCONTROL
# A colon-separated list of values controlling how commands are saved on the history list.
# erasedups causes all previous lines matching the current line to be removed from the history list before that line is saved.
#ignoreboth == ignoredups:ignorespace
# See bash(1) for more options

# kitty: ignoreboth or ignorespace present in bash HISTCONTROL setting, showing running command in window title will not be robust
# So, only ignoredups

# dont put duplicate lines in the history.
HISTCONTROL=ignoredups

## Keep also space-starting lines, just in case
export HISTCONTROL=${HISTCONTROL:+$HISTCONTROL,}ignoredups
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

HISTIMEFORMAT="%F %T"

shopt -s histverify
shopt -s cmdhist

#Ignore some controlling instructions
#HISTIGNORE is a colon-delimited list of patterns which should be excluded.
#The '&' is a special pattern which suppresses duplicate entries.
# "[ \t]*:&:[fb]g:pwd:date:exit:* --help"
export HISTIGNORE='&:exit:history:clear:[fb]g:pwd'

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
[ "$BASH" ] && bind '"\e[A":history-search-backward'
[ "$BASH" ] && bind '"\e[B":history-search-forward'

#export LSCOLORS='exfxcxdxbxegedabagacad'
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

export LS_OPTIONS='--color=auto'

# Refer also to /etc/skel/
# Refer also to /etc/default

# NOTE that other shells might also read ~/.profile
# settings in .profile won't be turned on in subshells.

# TODO
# dpkg -s base-files | grep Description: -A50
# Description: Debian base system miscellaneous files
# This package contains the basic filesystem hierarchy of a Debian system, and
# several important miscellaneous files, such as /etc/debian_version,
# /etc/host.conf, /etc/issue, /etc/motd, /etc/profile, and others,
# and the text of several common licenses in use on Debian systems.
# dpkg -L base-files | grep profile$
# /usr/share/base-files/dot.profile
# /usr/share/base-files/profile

##### COPY from /usr/share/base-files/profile, starts
# ${1+"/usr/bin/$@"}

# if no "-" , .profile won't be loaded??
# such as in "su -", or "mintty -"

export ENV=$HOME/.bashrc

# test -f "$HOME/.bashrc" && . "$HOME/.bashrc"

# if [ "${BASH-no}" != "no" ]; then
#   test -r /etc/bashrc && . /etc/bashrc
#   test -r /etc/bash.bashrc && . /etc/bash.bashrc
# fi

# Nix
if [ -e /home/aaron/.nix-profile/etc/profile.d/nix.sh ]; then . /home/aaron/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

# some ... shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Tell app not to attempt to use ATK
# export NO_AT_BRIDGE=1
export NO_AT_BRIDGE=1

# Calculate time lapse
# ttt=$(date +%s%N)

#QUOTE BEGIN
## System-wide .profile for sh(1)
if [ -x /usr/libexec/path_helper ]; then
  eval $(/usr/libexec/path_helper -s)
fi
#QUOTE END

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found ] || [ -x /usr/share/command-not-found/command-not-found ]; then
  function command_not_found_handle {
    # check because c-n-f could've been removed in the meantime
    if [ -x /usr/lib/command-not-found ]; then
      /usr/lib/command-not-found -- "$1"
      return $?
    elif [ -x /usr/share/command-not-found/command-not-found ]; then
      /usr/share/command-not-found/command-not-found -- "$1"
      return $?
    else
      printf "%s: command not found\n" "$1" >&2
      return 127
    fi
  }
fi

# if the command-not-found package is installed, use it
if [ -x /usr/share/command-not-found/command-not-found ]; then
  function command_not_found_handle {
    # check because c-n-f could've been removed in the meantime
    if [ -x /usr/share/command-not-found/command-not-found ]; then
      /usr/share/command-not-found/command-not-found -- "$1"
      return $?
    else
      printf "%s: command not found\n" "$1" >&2
      return 127
    fi
  }
fi

#### PATH
# NEVER export PATH without quoting $PATH
# Deal with PATH only in .bashrc, and source it in ~/.bash_profile
# Original PATH is set in /etc/profile
PATH=/usr/sbin:/usr/bin:/sbin:/bin

#For Java
# export JAVA_HOME=/usr/lib/jvm/java-6-sun-1.6.0.14/jre/
# [ ! -z $JAVA_HOME ] && export PATH=$JAVA_HOME/bin:$PATH
# export CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/td.jar:$JAVA_HOME/lib/rt.jar:.
#export PATH=$JAVA_HOME/bin:/$HOME/.local/my-cross/bin:$PATH

# Append our default paths
appendpath() {
  case ":$PATH:" in
  *:"$1":*) ;;
  *)
    test -d $1 && PATH="$PATH:$1" || true
    ;;
  esac
}

# prepend our default paths
prependpath() {
  case ":$PATH:" in
  *:"$1":*) ;;
  *)
    export PATH="$1:$PATH"
    ;;
    #*)   test -d $1 && PATH="$1:$PATH" || true
  esac
}

# less and more, man
# {

# -c: clear screen, to reduce screen blinking
# -e: exit at the output end
# -F: no less if output can be in one page
# -i: ignore case for search
# -M: More info in status bar
# -R: Render Raw control characters, ANSI color sequences, etc.
# -S: no line wrap
# -X: Keep screen output, no clear
export LESS="-eFiRMX"

# case insensitive search, squeeze blank lines, chop long lines, long prompt, display raw characters, shift right/left by 1/10th of screen size
export LESS="-i -s -S -M -R -# .1"

#alias less='less -R'                          # raw control characters
##alias less='less -r'                          # raw control characters

# Dont clear the screen after quitting a manual page
export MANPAGER="less -X"

## less not as chinese pager
export LESSCHARSET=UTF-8

## lesspipe for pre-processor, for file type detect, extract compressed files, formatting, etc.
## make less more friendly for non-text input files, see lesspipe(1)
#LESSOPEN="|lesspipe.sh %s"; export LESSOPEN

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
[ -x /usr/bin/lesspipe ] && export LESSCLOSE="/usr/bin/lesspipe %s %s"

# lessfile, had been used for setting env for less
#eval "$(lessfile)"

# no keeping less history
##export LESSHISTFILE=/dev/null

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"

# complete -p | less

#man() {
#    LESS_TERMCAP_md=$'\e[01;31m' \
#    LESS_TERMCAP_me=$'\e[0m' \
#    LESS_TERMCAP_so=$'\e[45;93m' \
#    LESS_TERMCAP_se=$'\e[0m' \
#    LESS_TERMCAP_us=$'\e[01;32m' \
#    LESS_TERMCAP_ue=$'\e[0m' \
#
#    command man "$@"
#}

#   mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#           displays paginated result with colored search terms and two lines surrounding each hit.
#           Example: mans mplayer codec

function mans { man "$1" | grep -iC2 --color=always "$2" | less; }

# Term color
# se=    standout end
# so=    standout on
# mb=    bold, blinking
# me=    all modes, end
# md=    mode bold
# ue=    underline end
# us=    underline start

# empty values to cancel mode, using default no mode

#export LESS_TERMCAP_mb=
#export LESS_TERMCAP_me=
#export LESS_TERMCAP_so=
#export LESS_TERMCAP_se=
#export LESS_TERMCAP_us=
#export LESS_TERMCAP_ue=
#export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
#export LESS_TERMCAP_md=$'\e[1;32m'
#export LESS_TERMCAP_so=$'\E[34;7;246m'    # begin standout-mode - info box
# reverse video == standout-mode
#export LESS_TERMCAP_us=$'\e[1;4;31m'
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

export LESS_TERMCAP_mb=$'\E[1;31m'  # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'     # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'     # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'  # begin underline
export LESS_TERMCAP_ue=$'\E[0m'     # reset underline

# }

if [[ $- =~ i ]]; then
  # less, man, most etc colors
  export LESS_TERMCAP_mb=$(
    tput bold
    tput setaf 2
  )
  export LESS_TERMCAP_md=$(
    tput bold
    tput setaf 6
  )
  export LESS_TERMCAP_me=$(tput sgr0)
  export LESS_TERMCAP_so=$(
    tput bold
    tput setaf 3
    tput setab 4
  )
  export LESS_TERMCAP_se=$(
    tput rmso
    tput sgr0
  )
  export LESS_TERMCAP_us=$(
    tput smul
    tput bold
    tput setaf 7
  )
  export LESS_TERMCAP_ue=$(
    tput rmul
    tput sgr0
  )
  export LESS_TERMCAP_mr=$(tput rev)
  export LESS_TERMCAP_mh=$(tput dim)
  export LESS_TERMCAP_ZN=$(tput ssubm)
  export LESS_TERMCAP_ZV=$(tput rsubm)
  export LESS_TERMCAP_ZO=$(tput ssupm)
  export LESS_TERMCAP_ZW=$(tput rsupm)
fi

# only in Util-Linux; not work for BSD
#setterm -blength 0

##bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
#if [ $bmajor -eq 2 ] && [ $bminor '>' 04 ]
#unset bash bmajor bminor

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# curl https://mirrors.tuna.tsinghua.edu.cn/git/git-repo -o repo
export REPO_URL='https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/'

# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.

safe_term=${TERM//[^[:alnum:]]/?} # sanitize TERM
match_lhs=""
unset color_prompt force_color_prompt
use_color=false

[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"

[[ -z ${match_lhs} ]] &&
  type -P dircolors >/dev/null &&
  match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

# better yaourt colors
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

# set a fancy prompt (non-color, unless we know we "want" color)

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

# enable color support of ls, less and man, and also add handy aliases
if type -P dircolors >/dev/null; then
  LS_COLORS=

  # If it isn't set, then `ls` will only colorize by default
  # based on file attributes and ignore extensions (even the compiled
  # in defaults of dircolors).

  if [[ -n ${LS_COLORS:+set} ]]; then
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions
    use_color=true
  else
    # Delete it if it's empty as it's useless in that case.
    unset LS_COLORS
  fi

  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

  # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
  if [[ -f ~/.dir_colors ]]; then
    match_lhs="${match_lhs}$(<$HOME/.dir_colors)"
    eval "$(dircolors -b ~/.dir_colors)"
  elif [[ -f /etc/DIR_COLORS ]]; then
    eval "$(dircolors -b /etc/DIR_COLORS)"
  else
    eval "$(dircolors -b)"
  fi

  if [[ ${EUID} == 0 ]]; then
    PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
    PS1='\[\033[01;31m\]\h\[\033[01;34m \w\n\$\[\033[00m\] '
  else
    PS1='\D{W%V.%u %a %b %d, }\t @\s-\v \[\033[01;32m\]\u@\h\[\033[01;37m\]:\w/\[\033[01;32m\]\n\$\[\033[00m\] '
    PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
  fi

  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias diff='diff --color=auto'
  alias ip='ip --color=auto'

else
  if [[ ${EUID} == 0 ]]; then
    # show root@ when we don't have colors
    PS1='\u@\h \W \$ '
  else
    PS1='\u@\h \w \$ '
  fi

fi

#http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
[ "${BASH_VERSINFO}" -ge "4" ] && shopt -s autocd cdspell dirspell
# cdspell
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache

# sometimes, stty eof '^D' / stty eof undef
#Don't use ^D to exit
#IGNOREEOF=10    # Shell only exists after the 10th consecutive Ctrl-d
#set -o ignoreeof  # Same as setting IGNOREEOF=10
#set ignoreeof  # prevent accidental shell termination
export IGNOREEOF=2

##FIXME
#$ tty
#/dev/ttys003
#$ uname -a

#if [ "`locale charmap 2>/dev/null`" = "UTF-8" ]
#then
#stty iutf8
#fi

stty -ctlecho #don't show ^C when pressing Ctrl+C
#TODO
# stty: invalid argument iutf8
# Try 'stty --help' for more information.

#TODO
# if no "-" , .profile won't be loaded??
# such as in "su -", or "mintty -"

#TODO
#ctrl-RIGHT got 5C

# bash: keychain: command not found
#eval `keychain --eval --agents ssh id_rsa`
#eval `keychain --eval ~/.ssh/id_dsa`
#eval `keychain --eval ~/.ssh/id_rsa`

# locale
## Timezone
TZ='Asia/Shanghai'
export TZ

# LC_ALL would overide all others
unset LC_ALL
# system messages shouldn't be translated

export LC_MESSAGES=C
# prefer YYYY-MM-DD HH:mm (ISO 8601)
# TODO: find a better solution

# This is the fallback locale configuration provided by systemd.
# LANG="C.UTF-8"
# it's a safe failback nowadays
LANG=$(locale -a | grep -e '^C.[uU][tT][fF]-\?8$')

export LANG=${LANG:-C}

#export LANG=en_US.UTF-8
#export LANGUAGE=en_US.UTF-8
export LC_ALL=en_GB.UTF-8
export LC_CTYPE=en_GB.UTF-8

#export LANG=$(locale -uU)
#export LANG="en_HK:en"
#export LC_CTYPE=pt_BR.UTF-8
#export LC_TIME=en_DK.UTF-8

# exports
#export PKG_CONFIG_PATH=/usr/lib/pkgconfig
#export LD_LIBRARY_PATH=/lib:/usr/lib:/opt/lib

#QUILT
#export QUILT_PATCHES="debian/patches"
#export QUILT_PUSH_ARGS="--color=auto"
#export QUILT_DIFF_ARGS="--no-timestamps --no-index -p ab --color=auto"
#export QUILT_REFRESH_ARGS="--no-timestamps --no-index -p ab"
#export QUILT_DIFF_OPTS='-p'

# if ! -z $CROSS_
# export CROSS_COMPILE=ppc_85xx-
# export TARGET_OS=linux

# These should be in ~/.xprofile for DM session
## Take care of dbus-launch

# See http://fcitx-im.org/wiki/Input_method_related_environment_variables#XMODIFIERS
# for sway and alike

export XMODIFIERS="@im=fcitx"
export SDL_IM_MODULE=fcitx

##export GTK_IM_MODULE=xim
export GTK_IM_MODULE=fcitx
###export QT_IM_MODULE=xim
export QT_IM_MODULE=fcitx
#
# export RESIN_HOME
export SHLVL=1
export G_BROKEN_FILENAMES=1

#Color scheme
# 033 = e

# BLACK       0;30     DARK_GRAY     1;30
# BLUE        0;34     LIGHT_BLUE    1;34
# GREEN       0;32     LIGHT_GREEN   1;32
# CYAN        0;36     LIGHT_CYAN    1;36
# RED         0;31     LIGHT_RED     1;31
# PURPLE      0;35     LIGHT_PURPLE  1;35
# BROWN       0;33     YELLOW        1;33
# LIGHT_GRAY  0;37     WHITE         1;37

#the list above is for colours at the console.
#In xterm, 1;31 isn't "Light Red," but "Bold Red." This is true of all the colours.
#Combinations can be used, like Light Red on Blue background: \[\033[44;1;31m\],
#setting colours separately seems better (ie. \[\033[44m\]\[\033[1;31m\])
#Other codes available include 4: Underscore, 5: Blink, 7: Inverse, and 8: Concealed.

## Regular Colors
BLACK='\e[0;30m'
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
MAGENTA='\e[0;35m'
CYAN='\e[0;36m'
WHITE='\e[0;37m'
LIGHT_GRAY="\[\033[0;37m\]"

export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

# Reset
# unsets color to term's fg color
NORMAL='\e[0m'

# Bold
BBLACK='\e[1;30m'
BRED='\e[1;31m'
BGREEN='\e[1;32m'
BYELLOW='\e[1;33m'
BBLUE='\e[1;34m'
BPURPLE='\e[1;35m'
BCYAN='\e[1;36m'
BWHITE='\e[1;37m'

# Underline
UBLACK='\e[4;30m'
URED='\e[4;31m'
UGREEN='\e[4;32m'
UYELLOW='\e[4;33m'
UBLUE='\e[4;34m'
UPURPLE='\e[4;35m'
UCYAN='\e[4;36m'
UWHITE='\e[4;37m'

# Background
ON_BLACK='\e[40m'
ON_RED='\e[41m'
ON_GREEN='\e[42m'
ON_YELLOW='\e[43m'
ON_BLUE='\e[44m'
ON_MAGENTA='\e[45m'
ON_CYAN='\e[46m'
ON_WHITE='\e[47m'

# High Intensity
IBLACK='\e[0;90m'
IRED='\e[0;91m'
IGREEN='\e[0;92m'
IYELLOW='\e[0;93m'
IBLUE='\e[0;94m'
IPURPLE='\e[0;95m'
ICYAN='\e[0;96m'
IWHITE='\e[0;97m'

# Bold High Intensity
BIBLACK='\e[1;90m'
BIRED='\e[1;91m'
BIGREEN='\e[1;92m'
BIYELLOW='\e[1;93m'
BIBLUE='\e[1;94m'
BIPURPLE='\e[1;95m'
BICYAN='\e[1;96m'
BIWHITE='\e[1;97m'

# HIGH Intensity backgrounds
ON_IBLACK='\e[0;100m'
ON_IRED='\e[0;101m'
ON_IGREEN='\e[0;102m'
ON_IYELLOW='\e[0;103m'
ON_IBLUE='\e[0;104m'
ON_IPURPLE='\e[0;105m'
ON_ICYAN='\e[0;106m'
ON_IWHITE='\e[0;107m'

function prompt_git() {
  local s=''
  local branchName=''

  # Check if the current directory is in a Git repository.
  if [ $(
    git rev-parse --is-inside-work-tree &>/dev/null
    echo "${?}"
  ) == '0' ]; then

    # check if the current directory is in .git before running git checks
    if [ "$(git rev-parse --is-inside-git-dir 2>/dev/null)" == 'false' ]; then

      # Ensure the index is up to date.
      git update-index --really-refresh -q &>/dev/null

      # Check for uncommitted changes in the index.
      if ! $(git diff --quiet --ignore-submodules --cached); then
        s+='+'
      fi

      # Check for unstaged changes.
      if ! $(git diff-files --quiet --ignore-submodules --); then
        s+='!'
      fi

      # Check for untracked files.
      if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        s+='?'
      fi

      # Check for stashed files.
      if $(git rev-parse --verify refs/stash &>/dev/null); then
        s+='$'
      fi

    fi

    # Get the short symbolic ref.
    # If HEAD isnt a symbolic ref, get the short SHA for the latest commit
    # Otherwise, just give up.
    branchName="$(git symbolic-ref --quiet --short HEAD 2>/dev/null ||
      git rev-parse --short HEAD 2>/dev/null ||
      echo '(unknown)')"

    [ -n "${s}" ] && s="${s}"

    echo -e " ${1}(${branchName}${BLUE}${s}${GREEN})"
  else
    return
  fi
}

# brew
#export HOMEBREW_PREFIX=/opt/homebrew
export HOMEBREW_PREFIX=$HOME/.brew
prependpath ${HOMEBREW_PREFIX}/bin

export HOMEBREW_CELLAR=${HOMEBREW_PREFIX}/Cellar

export HOMEBREW_BUILD_FROM_SOURCE=1

# No auto-update
export HOMEBREW_NO_AUTO_UPDATE=1

# export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"
# prependpath "/opt/homebrew/opt/ruby/bin"

# https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
#export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
#export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"

export MANPATH="${HOMEBREW_PREFIX}/share/man:$MANPATH"
export INFOPATH="${HOMEBREW_PREFIX}/share/info:$INFOPATH"

# git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew

#export HOMEBREW_INSTALL_FROM_API=1
# export HOMEBREW_API_DOMAIN
# export HOMEBREW_BOTTLE_DOMAIN
# export HOMEBREW_PIP_INDEX_URL

#QUILT
#export QUILT_PATCHES="debian/patches"
#export QUILT_PUSH_ARGS="--color=auto"
#export QUILT_DIFF_ARGS="--no-timestamps --no-index -p ab --color=auto"
#export QUILT_REFRESH_ARGS="--no-timestamps --no-index -p ab"
#export QUILT_DIFF_OPTS='-p'

#{3
if [ -f "$(command -v "ccache")" ]; then
  export PATH="${PATH}:/usr/lib/ccache"
  export CCACHE_DIR="${HOME}/.ccache"
  export CCACHE_SIZE="2G"
  #export CCACHE_PREFIX="distcc"
fi
#}3

export PKG_CONFIG_PATH=/usr/X11R6/lib/pkgconfig:/usr/lib/pkgconfig
export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/share/lib:/usr/local/lib:/usr/X11R6/lib:/opt/lib
export LD_LIBRARY_PATH=/opt/j2sdk1.4.2_04/jre:$LD_LIBRARY_PATH

export GOOGLE_APPLICATION_CREDENTIALS="$HOME/gen-lang-client-0832267004-2be0c36b9189.json"

#export GOOGLE_CLOUD_PROJECT="YOUR_PROJECT_ID"
export GOOGLE_CLOUD_PROJECT="gen-lang-client-0832267004"

#export GOOGLE_CLOUD_LOCATION="YOUR_REGION"

# tfenv
appendpath "$HOME/.tfenv/bin"

###Heroku Toolbelt
# [ -d "$HOME/.local/heroku/bin" ] && export PATH="$HOME/.local/heroku/bin:$PATH"
appendpath $HOME/.local/heroku/bin

# startup programs {{{
#export calendar=$HOME/.calendar/calendar.all

export PATH=$PATH:$HOME/depot_tools

BASH_PREEXEC_IN_ETC_BASHRC=

# cargo
test -e "$HOME/.cargo/env" && . "$HOME/.cargo/env" || true

appendpath $HOME/.cargo/bin

appendpath $HOME/.rustup/toolchains/1.83.0-aarch64-apple-darwin/bin

# CARGO_HTTP_USE_HYPER=true : force CARGO HTTP USE HTTP/1.1
# export CARGO_HTTP_USE_HYPER=true

export WASMTIME_HOME="$HOME/.wasmtime"
prependpath $WASMTIME_HOME/bin

#perl5
[ -d "$HOME/.local/perl5/bin" ] && export PATH="$HOME/.local/perl5/bin${PATH:+:${PATH}}"
PERL5LIB="$HOME/.local/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL5LIB
PERL_LOCAL_LIB_ROOT="$HOME/.local/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_LOCAL_LIB_ROOT
PERL_MB_OPT="--install_base \"$HOME/.local/perl5\""
export PERL_MB_OPT
PERL_MM_OPT="INSTALL_BASE=$HOME/.local/perl5"
export PERL_MM_OPT

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/google-cloud-sdk/path.bash.inc' ]; then
  source '$HOME/google-cloud-sdk/path.bash.inc'
fi

export PATH

#bind
# Bash is using readline to handle the prompt.
# $HOME/.inputrc is the configuration file for readline.

# If bond, Some systems lacking of "" would mess HOME/END??
bind -r "\e[A"
bind -r "\e[B"
bind -r "\eOA"
bind -r "\eOB"
bind '"\e[A":history-search-backward'
bind '"\eOA":history-search-backward'
bind '"\e[B":history-search-forward'
bind '"\eOB":history-search-forward'

# $HOME/.bashrc
#bind '"\e[A": history-search-backward'
#bind '"\e[B": history-search-forward'
#Normally, Up and Down are bound to the Readline functions previous-history and
# next-history respectively. I prefer to bind PgUp/PgDn to these functions,
# instead of displacing the normal operation of Up/Down.

# $HOME/.inputrc
#"\e[5~": history-search-backward
#"\e[6~": history-search-forward
#After modify $HOME/.inputrc, use Ctrl+X, Ctrl+R to tell it to re-read $HOME/.inputrc.

# To get the escape codes for the arrow keys you can do the following:
#Start cat in a terminal (just cat, no further arguments).
#Type keys on keyboard, you will get ^[[A for up arrow and ^[[B for down arrow.
#Replace ^[ with \e.

bind "set match-hidden-files off"    #don't match hidden files
bind "set bind-tty-special-chars on" #punctuations are not word delimiters

#}}} #History Options

#gpg
#export GPGKEY=""
#export GPG_TTY="$(tty)"

#fix java ugliness
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

bash_prompt_command() {
  # How many characters of the $PWD should be kept
  pwdmaxlen=25
  # Indicate that there has been dir truncation
  trunc_symbol=".."
  dir=${PWD##*/}
  pwdmaxlen=$(((pwdmaxlen < ${#dir}) ? ${#dir} : pwdmaxlen))
  NEW_PWD=${PWD/#$HOME/\~}
  pwdoffset=$((${#NEW_PWD} - pwdmaxlen))
  if [ ${pwdoffset} -gt "0" ]; then
    NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
    NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
  fi

}

# init it by setting PROMPT_COMMAND
PROMPT_COMMAND=bash_prompt_command

# Whenever displaying the prompt, write the previous line to disk
# to keep history even after abnormal bash quit,
# export PROMPT_COMMAND="history -a"
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
#PROMPT_COMMAND='history -a $HOME/.bash_history; echo -ne "\033]0;$PWD\007"; $PROMPT_COMMAND;'

if [ -n "$TMUX" ]; then
  set_tmux_pane_title() {
    local DIR_NAME=$(basename "$PWD")
    # 发送控制序列：\033]2;... 针对 Window Title，\033]I0;... 针对 Pane Title
    # 使用 \033]2;... 为 Window Title
    # 使用 \033]G1;... 为 Pane Title (某些版本可能需要)
    tmux select-pane -T "$DIR_NAME"
    \tmux setenv TMUXPWD_$(\tmux display -p "#I_#P") "$PWD"
    # force an immediate refresh
    \tmux refresh-client -S
  }

  export PROMPT_COMMAND="set_tmux_pane_title; $PROMPT_COMMAND"
fi

# export QT_SELECT=4

#Completion options
bind "set show-all-if-ambiguous on" #enable single tab completion
bind "set completion-ignore-case on"

# Disable completion when the input buffer is empty.  i.e. Hitting tab
# and waiting a long time for bash to expand all of $PATH.
shopt -s no_empty_cmd_completion

# The next line enables bash completion for gcloud.
if [ -f '$HOME/google-cloud-sdk/completion.bash.inc' ]; then
  source '$HOME/google-cloud-sdk/completion.bash.inc'
fi

#FIXME
#certutil: function failed: SEC_ERROR_PKCS11_GENERAL_ERROR: A PKCS #11 module returned CKR_GENERAL_ERROR, indicating that an unrecoverable error has occurred.

##startup programs ----------------------------------------
#export calendar=$HOME/.calendar/calendar.all

#! ps aux | grep -q fetchmail && fetchmail &
#! ( ps aux | grep -q fetchmail ) && fetchmail &

mdcd() {
  mkdir -p "$1" && cd "$1"
}

#function settitle
settitle() {
  echo -ne "\e]2;$@\a\e]1;$@\a"
}

# PATH for `rm` backup:
MYSAV=${MYSAV:-"$HOME/.local/share/Trash"}
[ -z $MYSAV ] && MYSAV="/var/tmp/Trash"
[ -d $MYSAV ] || \mkdir -p ${MYSAV}

function rm {
  #usage:
  # remove: $ rm files
  # use \rm to call original rm, or `which rm`

  (($# == 0)) && {
    echo "No parameters!"
    return 0
  }
  ## ??
  ##  1==0: not found
  # had tried to use (dirname $myfile) to replace (pwd) to save two cd,
  # but dirname is relative to current working dir, not absolute dir.

  for myfile in "$@"; do
    # For symbol links, same to "-L"
    if test -h "$myfile"; then
      /bin/rm "$myfile"
    elif test -e "$myfile"; then
      #savepath=`pwd`
      #mv -f $(basename $myfile) ${MYSAV}/$(find $(pwd) -maxdepth 1 -name $(basename $myfile)  |tr "/" "-")--`date +%Y-%m-%d-%H-%M-%S`
      mv -f "$myfile" ${MYSAV}/$(date +%Y%m%d-%H%M%S-%s)_$(echo $(basename -- "$myfile") | tr "[\-\ \!\)\(\]\[\|\'\;\:\&\,\#\@\{\}\^]" "_")
      #cd "${savepath}"
    else
      echo "$myfile: No such file or directory."
    fi
  done

  # To read:
  # undelete mini-HOWTO
  # safedelete
} # end of function rm

### [ ! "$EUID" -eq 0 ] && alias rm=rm_func

# SSH agent
SSH_ENV=$HOME/.ssh/environment

function start_agent {
  echo "Initialising new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' | tee ${SSH_ENV}
  echo succeeded
  chmod 600 ${SSH_ENV}
  . ${SSH_ENV} >/dev/null
  ssh-add
}

# if we have private ssh key(s), start ssh-agent and add the key(s)
##id1=$HOME/.ssh/identity
##id2=$HOME/.ssh/id_dsa
##id3=$HOME/.ssh/id_rsa
##if [ -x /usr/bin/ssh-agent ] && [ -f $id1 -o -f $id2 -o -f $id3 ];
##then
##eval `ssh-agent -s`
##ssh-add < /dev/null
##fi

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
  . ${SSH_ENV} >/dev/null
  #ps ${SSH_AGENT_PID} doesn''t work under cywgin
  \ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ >/dev/null || {
    start_agent
  }
else
  start_agent
fi

#[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && . $HOME/.autojump/etc/profile.d/autojump.sh

# colorful

colors() {
  local fgc bgc vals seq0

  printf "Color escapes are %s\n" '\e[${value};...;${value}m'
  printf "Values 30..37 are \e[33mforeground colors\e[m\n"
  printf "Values 40..47 are \e[43mbackground colors\e[m\n"
  printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

  # foreground colors
  for fgc in {30..37}; do
    # background colors
    for bgc in {40..47}; do
      fgc=${fgc#37} # white
      bgc=${bgc#40} # black

      vals="${fgc:+$fgc;}${bgc}"
      vals=${vals%%;}

      seq0="${vals:+\e[${vals}m}"
      printf "  %-9s" "${seq0:-(default)}"
      printf " ${seq0}TEXT\e[m"
      printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
    done
    echo
    echo
  done
}

# Set colorful PS1 only on colorful terminals.

## for color and non-color terminals, as well as shells that don't
## understand sequences such as \h, don't put anything special in it.
#PS1="${USER:-$(whoami 2>/dev/null)}@$(uname -n 2>/dev/null) \$ "

# \u: current username
# \h: hostname up to the first ., \H: full hostname
# \w: current working directory, \W: same, but only the basename
# $(__git_ps1 "%s"): your current git branch if you're in a git directory, otherwise nothing
# \$: if the effective UID is 0: #, otherwise $
# \d: the date in "Weekday Month Date" format (e.g., "Tue May 26")
# \t: the current time in 24-hour HH:MM:SS format, \T: same, but 12-hour format, \@: same, but in 12-hour am/pm format
# \n: newline
# \r: carriage return
# \\: backslash
# Colors & Styles
# colors have to be escaped (see General), color codes should be followed by an m
# put \[\e[‹code›m\] and \[\e[0m\] around the part of your prompt you want to style
# where ‹code› is a ;-chain of:
# x: attribute of the text
# 3y: foreground color
# 4y: background color
# x:
# 0: normal
# 1: bold
# 4: underline
# 7: reverse
# y is the color:
# 0 black
# 1 red
# 2 green
# 3 yellow
# 4 blue
# 5 magenta
# 6 cyan
# 7 white
# example: \[\e[0;33m\]prompt:\[\e[0m\]

# extra backslash in front of \$ to make bash colorize the prompt
#PS1='\u@$(hostname):$( printf "%s" "${PWD/${HOME}/~}")\n\$ '
#PS1='\u@$( printf "%s" "${PWD/${HOME}/~}") \$\n\n'
# man bash, PROMPTING

PS1="\n${debian_chroot:+($debian_chroot)}${BLUE}# \D{W%V.%u} \t \l \s-\v \[\033[41;33m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]/\n\$ "

extr() {
  local c e i

  (($#)) || return

  for i; do
    c=''
    e=1

    if [[ ! -r $i ]]; then
      echo "$0: file is unreadable: \`$i'" >&2
      continue
    fi

    case $i in
    *.t\(gz | lz | xz | b\(2 | z?\(2\)\) | a\(z | r?\(.\(Z | bz?\(2\) | gz | lzma | xz\)\)\)\)) c='bsdtar xvf' ;;
    *.7z) c='7z x' ;;
    *.Z) c='uncompress' ;;
    *.bz2) c='bunzip2' ;;
    *.exe) c='cabextract' ;;
    *.gz) c='gunzip' ;;
    *.rar) c='unrar x' ;;
    *.xz) c='unxz' ;;
    *.zip) c='unzip' ;;
    *)
      echo "$0: unrecognized file extension: \`$i'" >&2
      continue
      ;;
    esac

    command $c "$i"
    e=$?З
  done

  return $e
}

# One line functions inside { ... } must end with a semicolon.

xrpm() { rpm2cpio "$1" | cpio -idmv; }

mcd() {
  mkdir "$1"
  cd "$1"
}

# ex - archive extractor
# usage: ex <file>
ex() {
  if [ -f $1 ]; then
    case $1 in
    *.tar.bz2) tar xjf $1 ;;
    *.tar.gz) tar xzf $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar x $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xf $1 ;;
    *.tbz2) tar xjf $1 ;;
    *.tgz) tar xzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *) echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

STARSHIP_SHELL=

# which zellij &>/dev/null && eval "$(zellij setup --generate-auto-start bash)"

#which zellij &>/dev/null &&
#(
#ZJ_SESSIONS=$(zellij list-sessions)
#NO_SESSIONS=$(echo "${ZJ_SESSIONS}" | wc -l)
#
#if [ "${NO_SESSIONS}" -ge 2 ]; then
#    zellij attach \
#    "$(echo "${ZJ_SESSIONS}" | sk)"
#else
#   zellij attach -c
#fi
#)

# exports

# export RESIN_HOME

export SHLVL=1
export G_BROKEN_FILENAMES=1

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  command -v nvim &>/dev/null && export EDITOR='nvim'
fi

#export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
test -r ~/.vim/branch_prompt.sh && source ~/.vim/branch_prompt.sh

# make default editor Neovim

export VISUAL=$EDITOR
export CSCOPE_EDITOR="$EDITOR"

#export MAIL=$HOME/.mail/
#export MAIL=$HOME/.mail/INBOX
export MAIL=$HOME/Maildir/
#MAILCHECK=0

export USER LOGNAME MAIL HOSTNAME

export WCDHOME="${HOME}/.wcd"

#export FIREFOX_BIN="$HOME/ff"

# Variables honored by Debian
export PAGER=less
#export BROWSER="chromium"
export BROWSER=firefox:elinks:w3m:x-www-browser
export BROWSER="x-www-browser"

test -f .bashrc-d/maven-bash-completion.bash && . .bashrc-d/maven-bash-completion.bash

# Docker
[ -f ~/.bashrc_docker ] && . ~/.bashrc_docker

#For properly registering the ConsoleKit session, you probably want to add --with-ck-launch with startxfce4
#By default xfce4-session tries to start the gpg- or ssh-agent. To disable this run the following commands:
#xfconf-query -c xfce4-session -p /startup/ssh-agent/enabled -n -t bool -s false
#xfconf-query -c xfce4-session -p /startup/gpg-agent/enabled -n -t bool -s false

#To force the ssh-agent instead of the gpg-agent use the following command:
#xfconf-query -c xfce4-session -p /startup/ssh-agent/type -n -t string -s ssh-agent

#### alacritty
[ "$BASH" ] && test -r "$HOME/.config/alacritty/alacritty.bash" && source "$HOME/.config/alacritty/alacritty.bash"

#### kitty
#[ "$BASH" ] && command -v kitty &>/dev/null && source <(kitty + complete setup bash)
#[ "$BASH" ] && command -v kitty &>/dev/null && source <(kitty + complete setup bash)
#[ "$BASH" ] && command -v kitty &>/dev/null && source <(kitty + complete setup bash)
###Older versions do not support process substitution with the source command
[ "$BASH" ] && command -v kitty &>/dev/null && source /dev/stdin <<<"$(kitty + complete setup bash)"

# Transfer xterm-kitty terminfo to remote hosts
## ~/.terminfo or /usr/share/terminfo
# infocmp xterm-kitty > kitty.terminfo.txt
# tic -x kitty.terminfo.txt

##try an alternative:
# source /dev/stdin <<<"$(kitty + complete setup bash)"

# BEGIN_KITTY_SHELL_INTEGRATION
#[ "$BASH" ] && test -e "${KITTY_INSTALLATION_DIR-}/shell-integration/bash/kitty.bash" && source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
#[ "$BASH" ] && test -e "${KITTY_INSTALLATION_DIR-}/shell-integration/bash/kitty.bash" && source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
#[ "$BASH" ] && test -e "${KITTY_INSTALLATION_DIR-}/shell-integration/bash/kitty.bash" && source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
# END_KITTY_SHELL_INTEGRATION

bgrun() {
  local basedir="$HOME/.local/share/bgrun"
  local logdir="$basedir/logs"
  local pidfile="$basedir/bgrun.list"

  mkdir -p "$logdir"
  touch "$pidfile"

  clean_old_logs() {
    find "$logdir" -type f -mtime +30 -delete 2>/dev/null
  }

  case "$1" in
  --list)
    if [ ! -s "$pidfile" ]; then
      echo "📭 no running bgrun tasks"
      return 0
    fi
    echo "📋 running bgrun tasks:"
    while IFS="|" read -r pid cmd logfile; do
      if [ -n "$pid" ] && ps -p "$pid" >/dev/null 2>&1; then
        echo "PID=$pid | $cmd"
        echo "  ↳ Log: $logfile"
      else
        echo "⚰️  PID=$pid ($cmd) finished"
      fi
    done <"$pidfile"
    ;;
  --kill)
    if [ -z "$2" ]; then
      echo "Usage: bglaunch --kill <pid>"
      return 1
    fi
    if kill "$2" 2>/dev/null; then
      echo "🛑 process finished: $2"
      sed -i "/^$2|/d" "$pidfile"
    else
      echo "❌ unable to kill $2 (running?)"
    fi
    ;;
  --clean)
    echo "🧹 clean old logs..."
    clean_old_logs
    tmp=$(mktemp)
    while IFS="|" read -r pid cmd logfile; do
      if [ -n "$pid" ] && ps -p "$pid" >/dev/null 2>&1; then
        echo "$pid|$cmd|$logfile" >>"$tmp"
      fi
    done <"$pidfile"
    mv "$tmp" "$pidfile"
    echo "✅ cleaning finished"
    ;;
  *)
    if [ $# -eq 0 ]; then
      echo "Usage: bglaunch <cmd> [args...]"
      echo "       bglaunch --list"
      echo "       bglaunch --kill <pid>"
      echo "       bglaunch --clean"
      return 1
    fi
    clean_old_logs

    local timestamp=$(date +%Y%m%d-%H%M%S)
    local logfile="$logdir/${1##*/}-$timestamp.log"

    #nohup setsid "$@" >"$logfile" 2>&1 &
    nohup "$@" >"$logfile" 2>&1 &
    local pid=$!

    echo "$pid|$*|$logfile" >>"$pidfile"

    echo "✅ Running bgrun tasks: $*"
    echo "   PID: $pid"
    echo "   Log file: $logfile"
    ;;
  esac
}

# proxy
#export http_proxy=http://127.0.0.1:10080
#export https_proxy=http://127.0.0.1:10080

#export HTTP_PROXY=socks5://127.0.0.1:10080
#export HTTPS_PROXY=socks5://127.0.0.1:10080
#export ALL_PROXY=socks5://127.0.0.1:10080
# PROXY_LINK='http://127.0.0.1:7890'

#export all_proxy=socks5h://127.0.0.1:50080

#export http_proxy=socks5h://127.0.0.1:50080
#export https_proxy=socks5h://127.0.0.1:50080
#export no_proxy="localhost,127.0.0.1,*.example.com,*.cn,10.*,.local"

#export HTTP_PROXY=$http_proxy
#export HTTPS_PROXY=$https_proxy
#export NO_PROXY=$no_proxy

####Go
#export GOPROXY=https://goproxy.cn,direct
#export GOPROXY=socks5://127.0.0.1:10080
export GOPROXY=https://goproxy.io,direct

## Set environment variable allow bypassing the proxy for specified repos (optional)
#export GOPRIVATE=git.mycompany.com,github.com/my/private

export GOPATH=$HOME/go
appendpath $GOPATH/bin

export GO111MODUL=on

# asdf

# $ go install github.com/asdf-vm/asdf/cmd/asdf@v0.20.0
# go: downloading github.com/asdf-vm/asdf v0.20.0
# go: downloading github.com/urfave/cli/v3 v3.3.3
# go: downloading gopkg.in/ini.v1 v1.67.0
# go: downloading golang.org/x/sys v0.45.0

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export ASDF_DATA_DIR="$HOME/.asdf"

# OLD
# . $HOME/.asdf/asdf.sh
# . $HOME/.asdf/completions/asdf.bash
# OLD
. <(asdf completion bash)

# ruby

# hash: hash [-lr] [-p pathname] [-dt] [name ...]
#     For each NAME, the full pathname of the command is determined and
#     remembered.  If the -p option is supplied, PATHNAME is used as the
#     full pathname of NAME, and no path search is performed.  The -r
#     option causes the shell to forget all remembered locations.  The -d
#     option causes the shell to forget the remembered location of each NAME.
#     If the -t option is supplied the full pathname to which each NAME
#     corresponds is printed.  If multiple NAME arguments are supplied with
#     -t, the NAME is printed before the hashed full pathname.  The -l option
#     causes output to be displayed in a format that may be reused as input.
#     If no arguments are given, information about remembered commands is displayed.

# GEM_HOME is where gems will be installed (by default).
# $ gen env ; gen env home

# A gem directory is a directory that holds gems.  The 'gem' command will lay
# out and utilize the following structure:
#   bin               # installed bin scripts
#   cache             # .gem files  ex: cache/gem_name.gem
#   doc               # rdoc/ri     ex: doc/gem_name/rdoc
#   gems              # gem file    ex: gems/gem_name/lib/gem_name.rb
#   specifications    # gemspecs    ex: specifications/gem_name.gem

##command -v rbenv &> /dev/null && eval "$(rbenv init -)"
######test -x ~/.rbenv/bin/rbenv && eval "$(~/.rbenv/bin/rbenv init - bash)"
#
#if hash rbenv &>/dev/null; then
#  #eval "$(rbenv init -)"
#  eval "$(rbenv init - --no-rehash bash)"
#  appendpath "$HOME/.rbenv/shims"
#fi
#prependpath "$HOME/.rbenv/bin"

# GEM API version only care about MAJOR:MINOR number

# GEM_PATH: a standard PATH to gem dirs where gems are found
# GEM_PATH allows multiple local repositories to be searched for gems
# empty GEM_PATH, means default value. See gem env.
# export GEM_PATH=$GEM_HOME

#RUBY_VERSION=3.4.1
RUBY_VERSION=4.0.1
export RUBY_VERSION

##RUBY="$HOME/.rbenv/versions/3.4.1"
RUBY="$HOME/.asdf/installs/ruby/4.0.1"
#prependpath $RUBY_VERSION/bin
prependpath $RUBY/bin

## Bundler / RubyGems will detect this kind of versioning path
# gem install bundler
# Fetching bundler-2.5.23.gem
# Defaulting to user installation because default installation directory (/usr/lib/ruby/gems/3.3.0) is not writable.
#           gem executables will not run.
# Successfully installed bundler-2.5.23
# 1 gem installed

#BUNDLE_MIRROR__HTTPS://RUBYGEMS__ORG/: "https://mirrors.ustc.edu.cn/rubygems/"
#BUNDLE_MIRROR__HTTPS://RUBYGEMS__ORG/: "https://mirrors.tuna.tsinghua.edu.cn/rubygems"
## ruby -e 'require "rubygems"; puts Gem.user_dir'
## gem env
#GEM_HOME: /path/to/your/gem_directory
# GEM_HOME=$HOME/.local/share/gem/ruby/4.0.0
# asdf will do so:
export GEM_HOME="$HOME/.asdf/installs/ruby/4.0.1/lib/ruby/gems/4.0.0"
export GEM_PATH="$GEM_HOME"

# rbenv WILL manage GEM_HOME
# rbenv Bundler might adjust GEM_HOME / GEM_PATH

appendpath $GEM_PATH/bin

#echo ${TERM}
#echo ${PS1}

#term
# export TERM="xterm-256color"
#/etc/terminfo/*

# Alias definitions.
test -r $HOME/.aliases && source $HOME/.aliases

# bash-completion
#trap '. /etc/bash_completion ; trap USR2' USR2
#{ sleep 0.01 ; builtin kill -USR2 $$ ; } & disown
[ -z "${BASH_COMPLETION_COMPAT_DIR}" ] && [ -f /etc/bash_completion ] && . /etc/bash_completion

#   https://github.com/scop/bash-completion

# Check for interactive bash and that we haven't already been sourced.
if [ -n "${BASH_VERSION-}" -a -n "${PS1-}" -a -z "${BASH_COMPLETION_COMPAT_DIR-}" ]; then

  # Check for recent enough version of bash.
  if [ ${BASH_VERSINFO[0]} -gt 4 ] ||
    [ ${BASH_VERSINFO[0]} -eq 4 -a ${BASH_VERSINFO[1]} -ge 1 ]; then
    [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion" ] &&
      . "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion"
    if shopt -q progcomp && [ -r /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
    fi
  fi

fi

complete -W menuconfig make
complete -cf sudo

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term match_lhs sh

unset UNAME RELEASE default dirnames filenames have nospace bashdefault plusdirs

unset color_prompt force_color_prompt

# pnpm
#export PNPM_HOME="/home/aaron/.pnpm"
export PNPM_HOME="$HOME/.pnpm"
prependpath $PNPM_HOME/bin

# pnpm: use ${XDG_CONFIG_HOME:-$HOME/.config}/pnpm/rc
#pnpm config set global-dir $PNPM_HOME
#pnpm config set global-bin-dir $PNPM_HOME/bin
#pnpm config set store-dir $PNPM_HOME/store
#pnpm config set store-dir ~/.pnpm/store --global
#export NODE_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/
#export NODE_MIRROR=https://npmmirror.com/
export NODE_MIRROR=https://mirrors.ustc.edu.cn/node/

# pnpm config list
# pnpm config get --global

# on macos, ~/.config/pnpm/rc is not read
# but pnpm will always read ~/.npm/rc
# pnpm end

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
[[ -r "$HOME/.grok/completions/bash/grok.bash" ]] && source "$HOME/.grok/completions/bash/grok.bash"
# <<< grok installer <<<

# Kiro CLI
# [ -x ~/.local/bin/kiro-cli ] && eval "$(~/.local/bin/kiro-cli init bash post --rcfile bashrc)"

# [[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"

## follow the XDG Base and User Directory Specifications
#export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
#export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
#export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}

export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-$HOME/.cache}

#export XDG_DOWNLOAD_DIR=${XDG_DOWNLOAD_DIR:-$HOME/.download}
#export XDG_DESKTOP_DIR=${XDG_DESKTOP_DIR:-$HOME}
#
##$ tty
##/dev/ttys003
#test -z ${DISPLAY-} && case "$(tty)" in
##"/dev/tty1")    XKB_DEFAULT_LAYOUT=us exec sway; exit 0;;
#"/dev/tty1")
#  #exec niri-session
#  exec hyprland
#  #exec sway
#  exit 0
#  ;;
#  #"/dev/vc/1")    sway; exit 0;;
#esac
#
#if [ ! $DISPLAY ]; then
#  if [ "$SSH_CLIENT" ]; then
#    export DISPLAY=$(echo $SSH_CLIENT | cut -f1 -d\ ):0.0
#  fi
#fi
#
## Start X if login from the first console.
##[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
##[[ -z ${DISPLAY-} && $XDG_VTNR -eq 1 ]] && exec startx ~/.config/xorg/xinitrc
##if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
## use nodm, comment out
##if [ "$(tty)" = "/dev/tty1" -o "$(tty)" = "/dev/vc/1" ] ; then
##sway
##Hyprland
##niri
##cosmic
##startxfce4
##   exit 0    # exit login after sway quits
##fi
#
## if [[ -z $DISPLAY && $(tty) = /dev/tty5 ]]; then
##   exec startx
## fi

colors() {
  local fgc bgc vals seq0

  printf "Color escapes are %s\n" '\e[${value};...;${value}m'
  printf "Values 30..37 are \e[33mforeground colors\e[m\n"
  printf "Values 40..47 are \e[43mbackground colors\e[m\n"
  printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

  # foreground colors
  for fgc in {30..37}; do
    # background colors
    for bgc in {40..47}; do
      fgc=${fgc#37} # white
      bgc=${bgc#40} # black

      vals="${fgc:+$fgc;}${bgc}"
      vals=${vals%%;}

      seq0="${vals:+\e[${vals}m}"
      printf "  %-9s" "${seq0:-(default)}"
      printf " ${seq0}TEXT\e[m"
      printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
    done
    echo
    echo
  done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
xterm* | rxvt* | Eterm* | aterm | kterm | gnome* | interix | konsole*)
  PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
  ;;
screen*)
  PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
  ;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?} # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs} ]] &&
  type -P dircolors >/dev/null &&
  match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color}; then
  # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
  if type -P dircolors >/dev/null; then
    if [[ -f ~/.dir_colors ]]; then
      eval $(dircolors -b ~/.dir_colors)
    elif [[ -f /etc/DIR_COLORS ]]; then
      eval $(dircolors -b /etc/DIR_COLORS)
    fi
  fi

  if [[ ${EUID} == 0 ]]; then
    PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
  else
    PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
  fi

else
  if [[ ${EUID} == 0 ]]; then
    # show root@ when we don't have colors
    PS1='\u@\h \W \$ '
  else
    PS1='\u@\h \w \$ '
  fi
fi

unset use_color safe_term match_lhs sh

xhost +local:root >/dev/null 2>&1

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(</etc/debian_chroot)
fi

PS1="#${debian_chroot:+($debian_chroot)} \D{W%V.%u} \t \l \s-\v \[\033[41;33m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]/\n\$ "

export PATH="/Users/aaron/.local/bin:$PATH"
export LABS="${HOME}/.local"
export BBDIR="${LABS}/bitbake"

appendpath ${BBDIR}/bin

export PATH="$HOME/.deno/bin:$PATH"

appendpath '/opt/bin'
appendpath '/usr/games'

# set PATH so it includes user's private bin if it exists

#prependpath "$HOME/.local/bin"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
prependpath "$DIR/.local/bin"

# Added by Antigravity
appendpath $HOME/.antigravity/antigravity/bin

# opencode
export PATH=/Users/aaron/.opencode/bin:$PATH
