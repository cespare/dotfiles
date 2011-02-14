require "rubygems"
require "wirble"
require 'irb/completion'
require 'pp'
Wirble.init
Wirble.colorize

# NOTE: If using RVM, your ruby may compile with libedit instead of readline. To get real readline, refer to
# this: http://rvm.beginrescueend.com/packages/readline/
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]
IRB.conf[:AUTO_INDENT] = true

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

@hash = {:a => 1, :b => 2, :c => 3}
@array = ["a", "b", "c"]
