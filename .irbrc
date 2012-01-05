begin
  require "rubygems"
  require "irb/completion"
  require 'pp'
  require "ap"
rescue LoadError => e
  puts "Error: one or more gems in your ~/.irbrc are not installed."
  puts e.message
  exit 1
end

# NOTE: If using RVM, your ruby may compile with libedit instead of readline. To get real readline, refer to
# this: http://rvm.beginrescueend.com/packages/readline/
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]

class Object
  def cool_methods
    (self.methods - Object.new.methods).sort
  end
end

def bench(repetitions = 100, &block)
  require "benchmark"
  Benchmark.bmbm { |b| b.report { repetitions.times &block } }
  nil
end

# awesome_print as a default printer
IRB::Irb.class_eval do
  def output_value
    ap @context.last_value
  end
end

def h
  {:a => 1, :b => 2, :c => 3}
end

def a
  ["a", "b", "c"]
end

PROMPT_RUBY_VERSION = "[#{RUBY_VERSION}]"
IRB.conf[:PROMPT][:CUSTOM] = {
  :PROMPT_N => "#{PROMPT_RUBY_VERSION} #{'|'} ",
  :PROMPT_I => "#{PROMPT_RUBY_VERSION} #{'>'} ",
  :PROMPT_S => nil,
  :PROMPT_C => "#{PROMPT_RUBY_VERSION} #{'*'} ",
  :RETURN => "%s"
}
IRB.conf[:PROMPT_MODE] = :CUSTOM

IRB.conf[:SAVE_HISTORY] = 100
