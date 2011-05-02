def get_detached_screen_sessions
  text = `screen -ls`.split("\n")
  results = []
  text.each do |line|
    matching = line.match(/\s*\d+\.(\S+)\s+\(Detached\)/)
    results << matching[1] unless matching.nil? || matching.size < 2
  end
  results
end

completion = Completion.new
completion.create do |words, index|
  next completion.nothing if index > 0
  completion.prefix_match(get_detached_screen_sessions)
end
