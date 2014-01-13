#!/bin/bash
#
# Author : Axel Viala
# Forked from : mandark's bashrc
# src : mdk.fr
# Licence : http://www.wtfpl.net/txt/copying/
#

# If not running interactively, don't do anything more
[ -z "$PS1" ] && return

USER=`/usr/bin/whoami`
export USER
GROUP=`/usr/bin/id -gn $user`
export GROUP
MAIL="$USER@student.42.fr"
export MAIL

shopt -s histappend
shopt -s cmdhist
shopt -s checkwinsize
shopt -s cdspell
shopt -s dirspell 2>/dev/null # Only in bash 4
shopt -s autocd   2>/dev/null # Only in bash 4
shopt -s globstar 2>/dev/null # Only in bash 4
shopt -s nocaseglob

# http://nion.modprobe.de/blog/archives/572-less-colors-for-man-pages.html
export LESS_TERMCAP_mb=$'\E[01;31m'    # debut de blink
export LESS_TERMCAP_md=$'\E[01;31m'    # debut de gras
export LESS_TERMCAP_me=$'\E[0m'        # fin
export LESS_TERMCAP_so=$'\E[01;44;33m' # début de la ligne d'état
export LESS_TERMCAP_se=$'\E[0m'        # fin
export LESS_TERMCAP_us=$'\E[01;32m'    # début de souligné
export LESS_TERMCAP_ue=$'\E[0m'        # fin
export DEBEMAIL DEBFULLNAME
export EDITOR=vim
export PYTHONIOENCODING=utf_8
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export HISTCONTROL=ignoreboth
export HISTIGNORE='cd:pwd:pushd:popd:ls:bg:fg:history'
export HISTFILESIZE=50000
export HISTSIZE=50000

umask 022

# I don't like the default blue (That is too dark for me)
tput initc 12 400 400 1000

str_sum()
{
    BC=$(which bc)
    if [ -z "$1" ]
    then
        echo "Usage str_sum STRING"
        return
    fi
    if [ -x "$BC" ] ; then
        printf "%s" "$1" | hexdump -b | head -n 1 | tr ' ' '+' \
            | sed 's/\+*$//g' | bc
    else
        echo 0
    fi
}

HOSTNAME_SUM=$(str_sum "$(hostname)")
HOSTNAME_BOLD=$(( ($HOSTNAME_SUM + 1) % 2))
HOSTNAME_HUE=$(( ($HOSTNAME_SUM + 3) % 6 + 31))

USERNAME_SUM=$(str_sum "$(whoami)")
USERNAME_BOLD=$(( ($USERNAME_SUM + 1) % 2))
USERNAME_HUE=$(( ($USERNAME_SUM + 2) % 6 + 31))

HOSTNAME_COLOR=$'\E'"[$HOSTNAME_BOLD;${HOSTNAME_HUE}m"
USERNAME_COLOR=$'\E'"[$USERNAME_BOLD;${USERNAME_HUE}m"

WHITE=$'\E[00m'
BLACK=$'\x1b[30;01m'
RED=$'\x1b[31;01m'
GREEN=$'\x1b[32;01m'
YELLOW=$'\x1b[33;01m'
BLUE=$'\x1b[34;01m'
CYAN=$'\x1b[36;01m'
GRAY=$'\x1b[37;01m'
NONE=$'\x1b[0m'

if [ $(id -u) -eq 0 ]
then
    alias rm='rm -i'
    alias cp='cp -i'
    alias mv='mv -i'
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

parse_git_branch()
{
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/:\1/'
}

PS1_trail=""
[ z"$USER" != z"root" ] && [ -f "$(which git)" ] && PS1_trail="$PS1_trail\$(parse_git_branch)"

[ "$TERM" != 'linux' ] && TITLE="\[\033]0;\u@\H:\w\a\]" || TITLE=''

export PS1="$TITLE\[$USERNAME_COLOR\]\u\[$WHITE\]@\[$HOSTNAME_COLOR\]\H\[$WHITE\]$PS1_trail"'\$ '

alias grep="grep --color"
alias ll='ls -l'
alias l='ls -lA'
alias ...=".. 2"
alias ....=".. 3"
alias .....=".. 4"
alias scr='screen -D -R -U -h 424242'
alias lintian='lintian --pedantic -v -iI --display-experimental --show-overrides'
alias fingerprint='find /etc/ssh -name "*.pub" -exec ssh-keygen -l -f {} \;'
alias sub="/nfs/zfs-student/users/2013/$USER/Desktop/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
# My old emacs alias (Opening file with file:lineno) is replaced by a function
# in my .emacs.
alias e='emacs'

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.my_bashrc ]; then
    . ~/.my_bashrc
fi

..()
{
    for ((j=${1:-1},i=0;i<j;i++))
    do
        builtin cd ..
    done
}

# Json pretty printer
jsonpp()
{
    input="$([ $# -gt 0 ] && printf "%s\n" "$*" || cat -)"
    if ! [ z"$(which pygmentize)" = z"" ]
    then
		printf "%s" "$input" | python -mjson.tool | pygmentize -l js || printf "%s\n" "$input"
    else
		printf "%s" "$input" | python -minput.tool || printf "%s\n" "$input"
    fi
}

urldecode()
{
    input="$([ $# -gt 0 ] && printf "%s\n" "$*" || cat -)"
    python -c "import urllib2, sys; print urllib2.unquote(sys.argv[1])" "$input"
}

urlencode()
{
    input="$([ $# -gt 0 ] && printf "%s\n" "$*" || cat -)"
    python -c "import urllib2, sys; print urllib2.quote(sys.argv[1])" "$input"
}

# Removes *~ and #*# files in curent folder, for a depth limited to 3 folders.
clean()
{
    find . -name .emacs_backups -prune \
        -o \( -type f -a \
        \( -name '*~' -o -name '#*#' -o -name '\.DS_*' \) \
        \) \
        -delete
}

clean-bin()
{
    find ~/workbench -type f -exec file {} \; | grep Mach-O | cut -d ":" -f1 | xargs rm;
    find ~/workbench -type f \( -name "*.o" -o -name "*.a" \) -delete;
}

# Try to restore environment variable of an ssh-agent
ssh-agent-restore()
{
    select AUTH_SOCK in /tmp/ssh-*/*
    do
        export SSH_AUTH_SOCK="$AUTH_SOCK"
        export SSH_AGENT_PID="${SSH_AUTH_SOCK##/*/*.}"
        return
    done
}

# Download and apply Julien's bashrc
upgrade()
{
    rm -f ~/.bashrc.1
    echo "Downloading mandark's bashrc..."
    wget --timeout=1 --quiet http://mdk.fr/dotfiles/bashrc?42 -O ~/.bashrc.1
    if grep -q grep ~/.bashrc.1
    then
        DIFF="$(diff ~/.bashrc ~/.bashrc.1)"
        if [ -z "$DIFF" ]
        then
            echo "Nothing to upgrade"
        else
            echo "Here is the applied patch :"
            printf "%s\n" "$DIFF"
            mv -f ~/.bashrc.1 ~/.bashrc
            echo "type . ~/.bashrc to load your new bashrc file !"
        fi
    else
        rm -f ~/.bashrc.1
    fi
}

# Like pydoc, opens a manual page of a PHP function.
phpdoc()
{
    lynx "/usr/share/doc/php-doc/html/function.$(printf "%s" "$*" | sed 's/[^a-zA-Z0-9]/-/g').html"
}

# From : http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH="$HOME/.marks"
function jump
{
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}

function mark
{
    mkdir -p "$MARKPATH"
    ln -s "$(pwd)" "$MARKPATH/$1"
}

function unmark
{
    rm -i "$MARKPATH/$1"
}

function marks
{
    ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}