if status --is-interactive
  fish_vi_key_bindings
  set fish_cursor_default block
  set fish_cursor_insert line

  set -U fish_greeting
end
