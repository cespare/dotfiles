# This is an example completion file. It works for autocompleting the script `completion.rb` itself. This
# script uses a very simple syntax; it takes one of the following two forms
#     $ completion.rb init
#     $ completion.rb register <command>
#     $ completion.rb unregister <command>
# To auto-complete <command> for `register`, we'll suggest commands that are already in the user's path. To
# auto-complete <command> for `unregister`, we'll parse the registration file and suggest commands that are
# already there.

completion = Completion.new

completion.create do |words, index|
  if index == 0
    completion.prefix_match(["register", "unregister", "init"])
  elsif index == 1 && words[0] == "register"
    completion.prefix_match_builtins(:command)
  elsif index == 1 && words[0] == "unregister"
    header, commands = CompletionTool.read_registration_file
    completion.prefix_match(commands)
  else
    completion.nothing
  end
end
