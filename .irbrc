require "rubygems"
require "wirble"
require 'irb/completion'
require 'pp'
require "ap"
Wirble.init
Wirble.colorize

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

@hash = {:a => 1, :b => 2, :c => 3}
@array = ["a", "b", "c"]
