#!/usr/bin/env ruby

class Completion
  def initialize
    @index = ARGV[0].to_i
    @words = ARGV[1..-1]
    @current = @words[@index].nil? ? "" : @words[@index]
  end

  def create
    puts yield @words[1..-1], @index - 1
  end

  def prefix_match(words)
    words.select { |w| w.start_with?(@current) }.join(" ")
  end

  # A bash builtin completion type (corresponds to the action in compgen -A -- see `man bash`). Use
  # prefix_match_builtins() if you're going to do a prefix match; it will be faster.
  def builtins(type)
    %x[bash -c 'compgen -A #{type}']
  end

  def prefix_match_builtins(type)
    %x[bash -c 'compgen -A #{type} #{@current}']
  end

  # To match nothing
  def nothing
    ""
  end
end

module CompletionTool
  def self.abort(msg)
    Kernel::abort "ruby-complete error: #{msg}"
  end

  def self.registration_file
    File.join(ENV["RUBY_COMPLETE_DIR"], "registration.bash")
  end

  def self.init
    registration_filename = CompletionTool.registration_file
    abort "File already exists: #{registration_filename}." if File.exists? registration_filename
    header =<<-EOM
# WARNING -- AUTOGENERATED FILE
# Modifying this file by hand is not recommended -- use `completion.rb register`
# or `completion.rb unregister` instead.
EOM
    registration_file = File.open(registration_filename, "w")
    registration_file.write(header)
    registration_file.close
    register "completion.rb", false
  end

  def self.read_registration_file
    header = []
    commands = []
    File.open(CompletionTool.registration_file).each_with_index do |line, i|
      if line =~ /^#/
        # Preserve comment lines
        header << line
        next
      elsif line =~ /^\s+$/
        # Don't bother with whitespace lines
        next
      else
        matches = line.match(/^complete -F _ruby_complete (\S+)$/)
        if matches.nil? || matches.size != 2
          abort "line #{i} in #{registration_file} was unexpected."
        end
        commands << matches[1]
      end
    end
    [header, commands]
  end

  def self.write_registration_file(header, commands)
    registration_file = File.open(CompletionTool.registration_file, "w")
    header.each { |comment| registration_file.write(comment) }
    registration_file.write("\n")
    commands.each { |command| registration_file.write("complete -F _ruby_complete #{command}") }
    registration_file.write("\n")
    registration_file.close
  end

  def self.register(command, hint = true)
    completion_script = CompletionTool.create_completion_script_name(command)
    if File.file?(completion_script)
      header, commands = read_registration_file
      return if commands.include? command
      commands << command
      write_registration_file(header, commands)
      if hint
        puts "Registered command #{command}."
        puts "Note that this will only affect new bash windows, unless you execute the following:"
        puts "  $ source #{CompletionTool.registration_file}"
      end
    else
      abort "no such completion script #{completion_script}."
    end
  end

  def self.unregister(command, hint = true)
    header, commands = read_registration_file
    if commands.include? command
      commands.delete command
      write_registration_file(header, commands)
      if hint
        puts "Unregistered command #{command}."
        puts "Note that this will only affect new bash windows, unless you execute the following:"
        puts "  $ complete -r #{command}"
      end
    else
      abort "no such command #{command}."
    end
  end

  def self.create_completion_script_name(command)
    File.join(ENV["RUBY_COMPLETE_DIR"], command + ".rb")
  end
end

if __FILE__ == $0
  def assert_number_arguments(number_of_arguments)
    if ARGV.size < number_of_arguments
      CompletionTool.abort "too few arguments."
    elsif ARGV.size > number_of_arguments
      CompletionTool.abort "too many arguments."
    end
  end

  CompletionTool.abort "too few arguments" if ARGV.size < 1
  begin
    index = Float(ARGV[0]).to_i
  rescue ArgumentError
    case ARGV[0]
    when "init"
      CompletionTool.init
      exit
    when "register"
      assert_number_arguments 2
      CompletionTool.register ARGV[1]
      exit
    when "unregister"
      assert_number_arguments 2
      CompletionTool.unregister ARGV[1]
      exit
    else
      CompletionTool.abort "unrecognized command #{ARGV[0]}."
    end
  end

  CompletionTool.abort "too few arguments." if ARGV.size < 2

  completion_script = CompletionTool.create_completion_script_name(ARGV[1])
  if File.file?(completion_script)
    require completion_script
  else
    CompletionTool.abort "no such ruby-complete script #{completion_script}."
  end
end