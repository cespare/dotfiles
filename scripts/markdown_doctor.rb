#!/usr/bin/env ruby

require "rubygems"
require "rdiscount"

if ARGV.size < 1
  puts "Usage: markdown_doctor.rb <file>"
  exit 1
end

HEADER = <<EOF
<link href="https://assets0.github.com/stylesheets/bundle_common.css" type="text/csss" rel="stylesheet" />
<link href="https://assets0.github.com/stylesheets/bundle_github.css" type="text/csss" rel="stylesheet" />
<style type="text/css">
#readme.announce {
width: 920px;
margin: 0 auto;
}
</style>
<div id="readme" class="announce">
<div class="wikistyle">
EOF

FOOTER = <<EOF
</div>
</div>
EOF

filename = ARGV[0]
text = IO.read(filename)
markdown = RDiscount.new(text)
output = HEADER + markdown.to_html + FOOTER
puts output

