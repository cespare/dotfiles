if ! status --is-interactive
  return
end

fish_config theme choose cespare

# Turn off greeting.
set fish_greeting

# Set up vi mode and bindings.

fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line

bind -M insert ctrl-k forward-char # make ctrl+k accept auto-completes

# TODO: consider adding a hook that prints the duration of long-running
# commands. See https://github.com/fish-shell/fish-shell/issues/1279
# (and especially https://github.com/fish-shell/fish-shell/issues/1279#issuecomment-1203233446).

set -gx EDITOR nvim
set -gx VISUAL nvim

set -gx GREP_COLORS 'mt=1;32'

# Set SSH_AUTH_SOCK for ssh-agent that's running as a systemd unit.
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.sock"

fish_add_path ~/bin ~/scripts ~/.local/bin

set -gx CDPATH . ~/src ~/p

alias l 'ls -l'
alias ls 'ls -h -F --color=auto --tabsize=0 --group-directories-first'
alias la 'ls -la'
alias v nvim
alias suv 'sudo -E nvim'
alias g git
alias j jj
abbr jst 'jj st'
# I type this by accident a lot and I never mean ghostscript.
alias gs 'g s'

# A nice suggestion from the manual.
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd

# Shorthands for a few common git things.
set -gx h HEAD
set -gx u '@{upstream}'

# Go
set -gx GOBIN $HOME/bin
fish_add_path ~/apps/go/bin
set -gx GOROOT_BOOTSTRAP $HOME/apps/gobootstrap
set -gx BROWSER google-chrome

# Zig
fish_add_path ~/3p/zig

# Rust
fish_add_path ~/.cargo/bin

# Ripgrep.
set -gx RIPGREP_CONFIG_PATH ~/.config/ripgrep.conf

# fzf
set -gx FZF_DEFAULT_COMMAND 'rg --files'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
fzf --fish | source

# 2fa
set -gx TWOFA ~/n/2fa.txt

# Jujutsu
COMPLETE=fish jj | source
