# A convenience function I'll be using a lot
function source_if_exists() {
  [[ -f "$1" ]] && source "$1"
}

function pushpath() {
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
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
  alias ls='ls -h -F --color=auto --tabsize=0 --group-directories-first'
  export _zsh_platform=linux

elif [[ "$uname" = "Darwin" ]]; then
  # Homebrew
  pushpath /usr/local/sbin
  pushpath /usr/local/bin

  # Mac aliases
  alias e='mvim'
  alias o='open'
  alias ls='gls -h -F --color=auto --tabsize=0 --group-directories-first'
  alias gvimdiff='mvim -U NONE -d'
  alias sed='gsed'
  export _zsh_platform=mac
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
# Don't override tmux's color
if [[ -z "$TMUX" ]]; then
  export TERM="xterm-256color"
fi

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

export GREP_COLOR='1;32'
alias grep='grep --color=auto'

### Completion -----------------------------------------------------------------------------------------------

# Taskwarrior completion
if [[ $_zsh_platform == "linux" ]]; then
  fpath=($fpath /usr/share/doc/task/scripts/zsh)
else
  fpath=($fpath /usr/local/share/doc/task/scripts/zsh)
fi

autoload -Uz compinit
compinit -i

unsetopt MENU_COMPLETE
unsetopt FLOW_CONTROL
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*' group-name ''
# Case-insensitive matching, partial word and then substring completion last
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# TODO: Colors for completions
#zstyle ':completion:*' list-colors ${(s.:.)LSCOLORS}
# Color for 'kill'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
# Use a menu for selection
zstyle ':completion:*:*:*:*:*' menu select
# Caching for completion
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh_cache/
# Avoid having to manually use `rehash`
function _force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1
}
# A convenience function I'll be using a lot
# Fuzzy matching for completions (allow 1 error in matching)
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
# Ignore completion functions for non-existent commands
zstyle ':completion:*:functions' ignored-patterns '_*'
# Prevent cd from selecting the parent directory
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Make git completion suck less
__git_files () {
  _wanted files expl 'local files' _files
}

# Make mosh use ssh completion. Not perfect, but good enough for now.
compdef mosh=ssh

### Set paths ------------------------------------------------------------------------------------------------

# Add the usual dirs for my locally installed programs and scripts.
pushpath ~/bin
pushpath ~/scripts

 # Manpages for locally installed programs.
export MANPATH=~/man/:$MANPATH

# CDPATH for convenience
cdpath=(~/src ~/p "$cdpath[@]")

# TODO: zsh completion for my git scripts

### Aliases --------------------------------------------------------------------------------------------------

alias src='source ~/.zshrc'
alias l='ls -l'
alias la='ls -a'
alias v=vim
alias ...=../..
alias be='bundle exec'
alias pb='pbcopy'
alias gs='g s' # Stupid ghostscript

### Convenience functions ------------------------------------------------------------------------------------

# Make a directory and cd to it
function mcd() {
  mkdir -p "$1" && cd "$1"
}

# Make screen sessions named for the program and resume to them easily with 's' and 'sr'
function s() {
  screen -S "$1" "$1"
}
# TODO: completion
alias sr='screen -r'

### Build my prompt ------------------------------------------------------------------------------------------

# Some vcs_info hooks for additional functionality I want.
function +vi-git-untracked() {
  if [[ -n $(git status --porcelain 2>/dev/null | grep '??') ]]; then
    hook_com[unstaged]+='%F{blue}T%F{gray}'
  fi
  true
}
function +vi-git-stashed() {
  local num_stashes=$(echo $(git stash list 2> /dev/null | wc -l))
  (( $num_stashes )) && hook_com[unstaged]+="%F{magenta}${num_stashes}%F{gray}"
  true
}
# Quick hack to get a space between the staging/unstaged/etc markers and the branch info
function +vi-git-dirty-spacing() {
   local dirty="${hook_com[staged]}${hook_com[unstaged]}"
   [[ -n $dirty ]] && hook_com[unstaged]="${hook_com[unstaged]} "
   true
}
# This one is thanks to https://github.com/whiteinge/dotfiles/blob/master/.zsh_shouse_prompt
function +vi-git-unpushed() {
  local remote behind ahead remote_status_string
  local -a remote_status
  # Check if we're on a remote tracking branch
  remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name --abbrev-ref \
    2>/dev/null)}
  if [[ -n "${remote}" ]]; then
    ahead=$(echo $(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l ))
    (( $ahead )) && remote_status+=( "%F{green}+${ahead}%F{gray}" )
    behind=$(echo $(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l ))
    (( $behind )) && remote_status+=( "%F{red}+${behind}%F{gray}" )
    (( $ahead + $behind )) && remote_status_string=" ${(j:/:)remote_status}"
    hook_com[branch]="${hook_com[branch]}%F{red} → %F{gray}${remote}${remote_status_string}%F{red}%F{gray}"
  fi
  true
}

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{yellow}S%F{gray}'
zstyle ':vcs_info:*' unstagedstr '%F{green}U%F{gray}'
zstyle ':vcs_info:*' formats ' %F{red}✦%F{gray} %r%F{red}@%F{gray}%6.6i %c%u%b'
zstyle ':vcs_info:*' actionformats '%r%F{red}@%F{gray}%6.6i %c%u%b %F{red}(%F{gray}%a%F{red})%F{gray}'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-stashed git-dirty-spacing git-unpushed
setopt prompt_subst

PROMPT='%F{red}┏ ⟦ %F{gray}%n%F{red}@%F{gray}%m%F{red}:%F{gray}%~${vcs_info_msg_0_}%F{red} ⟧
%F{red}┗ $vi_mode_indicator%f '
PROMPT2='%F{red}┗ $vi_mode_indicator%f '
# The character that is printed out if the previous thing didn't end with a newline and zsh has to print a CR
# itself.
PROMPT_EOL_MARK="%F{red}↲%f"

function precmd() {
  # `man zshmisc` and go to the bottom of the page to make sense of the following line
  RPS1="%(?..%F{red}!%f)"
  vi_mode_indicator=❯
  vcs_info
}

# Show the vim editing mode in the prompt
function zle-keymap-select() {
  vi_mode_indicator="${${KEYMAP/vicmd/❖}/(main|viins)/❯}"
  zle reset-prompt
}

zle -N zle-keymap-select

### Initialize various tools and scripts ---------------------------------------------------------------------

autoload -U spectrum

# rbenv: https://github.com/rbenv/rbenv
pushpath ~/.rbenv/bin
eval "$(rbenv init -)"
#[[ $_zsh_platform == "mac" ]] && export CONFIGURE_OPTS="--with-readline-dir=$(brew --prefix readline)"
# The above line is very slow. Hardcode instead.
[[ $_zsh_platform == "mac" ]] && export CONFIGURE_OPTS="--with-readline-dir=/usr/local/opt/readline"

# pyenv: https://github.com/pyenv/pyenv
export PYENV_ROOT=$HOME/.pyenv
pushpath ${PYENV_ROOT}/bin
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# nvm: https://github.com/nvm-sh/nvm
# Commented out by default since this is slow and I usually don't need specific
# node versions.
# export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# vidir: https://github.com/trapd00r/vidir
pushpath ~/scripts/external/vidir/bin
export VIDIR_EDITOR='vim'
export VIDIR_EDITOR_ARGS='-c :set nolist | :set ft=vidir-ls'

# Git configuration
alias g='git'

# Go
export GOPATH=$HOME/p/go
export GOBIN=$HOME/bin
cdpath+=($HOME/p/go/src/github.com/cespare)
pushpath ~/apps/go/bin
pushpath ~/p/go/bin
export GOROOT_BOOTSTRAP=~/apps/gobootstrap
gdoc() {
  ~/apps/godev/bin/go doc "$@"
}
export BROWSER="google-chrome"

# Rust
pushpath ~/.cargo/bin

# Octave
alias oct='octave -q'

#if [[ $_zsh_platform == "linux" ]]; then
  ## Start up keychain
  #keychain id_rsa
  #source ~/.keychain/$HOST-sh
#fi

# qs: https://github.com/cespare/qs
pushpath ~/scripts/external/qs

# Ansible
alias a='ansible'
alias ap='ansible-playbook'

# ripgrep
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep.conf

# fzf
if [[ -e $GOPATH/src/github.com/junegunn/fzf/shell/completion.zsh ]]; then
  source $GOPATH/src/github.com/junegunn/fzf/shell/completion.zsh
  source $GOPATH/src/github.com/junegunn/fzf/shell/key-bindings.zsh
fi
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export ESCDELAY=10

# 2fa
export TWOFA='/keybase/private/cespare/2fa.txt'

### Load further configs -------------------------------------------------------------------------------------

source_if_exists ~/.zshrc.work # Work-specific stuff
source_if_exists ~/.zshrc.private # Sensitive stuff (keys and whatnot) that aren't in git.
