# ~/.bashrc: executed by bash(1) for each shell instance
# Users can create optional ~/.bash_custom file for specific customizations
umask 022

### Other env scripts ###

if [ -f "$HOME/.emsdk/emsdk_env.sh" ]; then
    EMSDK_QUIET=1 . $HOME/.emsdk/emsdk_env.sh
fi

### Paths ###

add_to_path ()
{
    # Check if directory exists
    if [[ ! -d "$1" ]]
    then
        return 0
    fi
    # Check if already in PATH
    if [[ "$PATH" =~ (^|:)"$1"(:|$) ]]
    then
        return 0
    fi
    export PATH=$1:$PATH
}
add_to_path "$HOME/bin"
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.cargo/bin"
add_to_path "$HOME/.deno/bin"

### Runtime environment variables ###

if [ -n "$(which cargo)" ]; then
    export CARGO_HOME="$HOME/.cargo"
fi
if [ -n "$(which rustc)" ]; then
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi
if [ -n $(which deno) ]; then
    export DENO_INSTALL="$HOME/.deno"
fi

### WSL2 settings ###

# Enable display of Linux applications inside WSL2
if [ -n "$WSL_DISTRO_NAME" ]; then
    export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0.0
    export LIBGL_ALWAYS_INDIRECT=1
    export BROWSER=wslview
fi

### User-specific custom bash settings ###
# Note: This file is allowed to return early if not running interactively
if [ -f "$HOME/.bash_custom" ]; then
   . "$HOME/.bash_custom"
fi

### STOP if running as non-interactive ###
case $- in
    *i*) ;;
      *) return;;
esac
################ Non-interactive settings ################

### Programmable completion ###

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

### aliases - personal ###

alias editrc='vim ~/.bash_custom ; . ~/.bash_custom ;'

alias gits='git status'
alias gitlog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"

### aliases - from Ubuntu ###

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

### Terminal settings ###

## History ##

# don't put duplicate lines or lines starting with space in the history.
#  See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

## Prompt format and color ##

# Check the window size after each command and, if necessary,
#  updates the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Configure the Git PS1 prompt
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true

# set a colored prompt
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
    #xterm-color|*-256color) color_prompt=no;;
esac
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h:\[\033[01;34m\]\w\[\033[0;35m\]$(__git_ps1 " [%s]")\[\033[00m\] \$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1 " [%s]") \$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w \a\]$PS1"
    ;;
esac
case "$TERM" in
    st-*)
        PROMPT_COMMAND='echo -ne "\033]0;st - $PWD\007"'
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
