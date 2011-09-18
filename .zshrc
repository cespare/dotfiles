# A convenience function I'll be using a lot
source_if_exists() {
  [[ -f "$1" ]] && source "$1"
}

export ZSH=~/.zsh
fpath=($ZSH/functions $ZSH/completions $fpath)

### Platform-specific configuration.

uname=`uname`
if [[ "$uname" = "Linux" ]]; then
  source_if_exists ~/.zshrc.linux
  # I think this is an Ubuntu thing.
  alias o='xdg-open'
  alias open='xdg-open'
  alias e='gvim'
  alias ack='ack-grep' # Ubuntu calls 'ack' ack-grep
  alias ls='ls -h -F --color=auto --tabsize=0 --group-directories-first'

  export GOOS=linux # Google Go

elif [[ "$uname" = "Darwin" ]]; then
  # Homebrew
  PATH=/usr/local/bin:/usr/local/sbin/:/usr/local/share/python:$PATH

  # Mac aliases
  alias e='mvim'
  alias o='open'
  alias ls='gls -h -F --color=auto --tabsize=0 --group-directories-first'
  alias gvimdiff='mvim -U NONE -d'

  export GOOS=darwin # Google go

  [[ -f ~/.zshrc.work ]] && source ~/.zshrc.work # Work-specific stuff
fi


### General configuration ------------------------------------------------------------------------------------

bindkey -v # vi mode
bindkey "^?" backward-delete-char                # Allow for deleting characters in vi mode
bindkey '^R' history-incremental-search-backward # search backwards with ^R
# We want to use 'v' in normal mode to edit and execute like in bash vi mode
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# zmv kicks ass
autoload -U zmv

# History settings
HISTFILE=~/.histfile      # Where to save history
HISTSIZE=SAVEHIST=10000   # Save 10k entries from the current shell and also in total
setopt INC_APPEND_HISTORY # Append history to the shared history file incrementally as commands are entered.
setopt HIST_IGNORE_DUPS   # Only save the first of several repeated entries to history
setopt HIST_IGNORE_SPACE  # Don't save commands starting with a space to history

# Filename generation options
setopt EXTENDED_GLOB # Extended glob patterns
setopt NO_MATCH      # Raise an error if a filename pattern has no matches
unsetopt CASE_GLOB   # Make globbing case-insensitive

# Color is good
export CLICOLOR=1
export TERM="xterm-256color"

# Directory switching
setopt AUTO_PUSHD        # Push each directory onto the stack
setopt PUSHD_IGNORE_DUPS # Don't push duplicate entries onto the stack
setopt AUTO_CD           # If a command is invalid but is the name of a directory, cd to it


# Misc
setopt NOTIFY # Immediately report status of background jobs
unsetopt BEEP # Don't beep on zle errors

export REPORTTIME=30 # Report CPU stats on operations taking more than 30 seconds.

### System configuration -------------------------------------------------------------------------------------

export EDITOR=vim
export VISUAL=vim
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'


### Set paths ------------------------------------------------------------------------------------------------

export PATH=~/bin:~/scripts:$PATH # Add the usual dirs for my locally installed programs and scripts
export MANPATH=~/man/:$MANPATH # Manpages for locally installed programs
export PATH=~/scripts/external/git-scripts/:$PATH # http://github.com/cespare/git-scripts




### Aliases --------------------------------------------------------------------------------------------------

alias src='source ~/.zshrc'
alias l='ls -l'
alias la='ls -a'
alias v=vim
alias hdfs='hadoop fs'
alias ...=../..

### Convenience functions ------------------------------------------------------------------------------------

# Make a directory and cd to it
mcd() {
  mkdir -p "$1" && cd "$1"
}

# Make screen sessions named for the program and resume to them easily with 's' and 'sr'
s() {
  screen -S "$1" "$1"
}
# TODO: completion
alias sr='screen -r'

### Completion -----------------------------------------------------------------------------------------------

zstyle :compinstall filename '/Users/caleb/.zshrc'
autoload -U compinit
compinit -i

### Build my prompt ------------------------------------------------------------------------------------------

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{yellow}S'
zstyle ':vcs_info:*' unstagedstr '%F{green}U'
zstyle ':vcs_info:*' formats '%F{gray}%r@%8.8i %c%u%F{gray} %b%m'
zstyle ':vcs_info:*' formats '%F{gray}%r@%8.8i %c%u%F{gray} %b%m (%a)'
setopt prompt_subst

vi_mode_indicator=❯
PROMPT='%F{blue}[%n@%m] %F{green}[%~] %F{blue}[] ${vcs_info_msg_0_}
%F{blue}$vi_mode_indicator%f '
PROMPT2="%F{blue}|%f "

# Show the vim editing mode in the prompt
function zle-keymap-select {
  vi_mode_indicator="${${KEYMAP/vicmd/❖}/(main|viins)/❯}"
  zle reset-prompt
}


zle -N zle-keymap-select

### Initialize various tools and scripts ---------------------------------------------------------------------

autoload -U spectrum

# z: https://github.com/rupa/z
source ~/scripts/external/z/z.sh
precmd () {
  vcs_info
  _z --add "$(pwd -P)"
}

# Git configuration
alias g='git'
alias h=HEAD # A nice shortcut b/c $h is shorter than typing HEAD
# TODO: make sure i've got all the git completion

# flip-the-tables configuration
# https://github.com/cespare/flip-the-tables
# TODO

# Google Go
export PATH=$PATH:$HOME/Apps/go/bin
export GOROOT=$HOME/Apps/go
export GOARCH=amd64
export GOMAXPROCS=4

# Scala
alias iscala='rlwrap scala -Xnojline'

# tlist: https://github.com/cespare/tlist
export TLIST_FILE=~/Dropbox/tasks/tlist.txt
alias t='tlist'
# TODO: completion

# ZSH syntax highlighting: https://github.com/zsh-users/zsh-syntax-highlighting
source_if_exists $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
