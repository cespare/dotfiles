NECESSARY_GEMS=%w{
  bundler
  markdown_doctor
  bcat
  awesome_print
  barkeep-client
}

exec "gem install #{NECESSARY_GEMS.join(" ")}"
