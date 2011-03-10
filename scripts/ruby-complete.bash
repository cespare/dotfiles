_ruby_complete()
{
    local current index
    current="${COMP_WORDS[*]}"
    index="${COMP_CWORD}"
    COMPREPLY=( $(completion.rb ${index} ${current} ) )
    return 0
}

if [ -z "$RUBY_COMPLETE_DIR" ]; then
  export RUBY_COMPLETE_DIR="$HOME/ruby-completion-scripts"
fi
source $RUBY_COMPLETE_DIR/registration.bash
