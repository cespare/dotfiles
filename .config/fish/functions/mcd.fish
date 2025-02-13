function mcd -d "Create a directory and cd into it"
  mkdir -p $argv
  if test $status = 0
    set -l last_arg $argv[(count $argv)]
    switch $last_arg
      case '-*'
      case '*'
        cd $last_arg
        return
    end
  end
end
