#!/usr/bin/env ruby

# A simple backup script that uses rsync and the magic of hard links to make incremental backups.
#
# Setup: install rbenv as root and set rbenv global 1.9.2-p290
# Cron line:
# 0 7 * * * PATH=~/.rbenv/bin:~/.rbenv/shims:$PATH ruby /home/caleb/scripts/incremental_backup.rb 2>1 >> /var/log/system_backup.log
# (Run each day at 7am)
#
# TODO:
# * more safety checks (make sure we're not running out of space, alert the user somehow if the backup fails,
# etc)
# * Functionality for testing backups?
# * Logging + rotation
#
# Sample config (json):
#
# {
#   "system_backup":
#     {
#       "from":   "/",
#       "to":     "/mnt/data/backups",
#       "exclude":
#         [
#           "/home/*/.gvfs" // Stupid gnome crap
#         ]
#     }
# }
#

require "json"
require "fileutils"

CONFIG_FILE = "/etc/backup.conf"
DEFAULT_RSYNC_OPTIONS = %w[--archive --one-file-system]

config = JSON.parse(File.read(CONFIG_FILE))

def log(message)
  puts "[#{Time.now.strftime "%Y-%m-%d %H:%M:%S"}] #{message}"
end

begin
  config.each do |name, backup|
    from = backup["from"]
    to = backup["to"]
    excludes = backup["exclude"]
    [from, to].each { |d| raise "No such directory '#{d}'" unless File.directory? d }
    log "Starting backup #{name}"
    current_dir = File.join(to, "current")
    unless File.symlink? current_dir
      raise "Unexpected: #{current} is not a symlink" if File.exists? current_dir
      log "Warning: no current backup in #{to}."
      current_dir = nil
    end
    rsync_options = DEFAULT_RSYNC_OPTIONS
    excludes.each { |e| rsync_options << "--exclude=#{e}" }
    rsync_options << "--link-dest=#{current_dir}" if current_dir
    target_dir_name = "#{name}_#{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}"
    target = File.join(to, target_dir_name)
    rsync_command = ["rsync", rsync_options, from, target].flatten.join(" ")
    log "Starting rsync with command:"
    log rsync_command
    log `#{rsync_command}`
    raise "Aborting (rsync error)" unless $?.to_i.zero?
    FileUtils.rm_f current_dir if current_dir
    FileUtils.cd to
    FileUtils.ln_s target_dir_name, "current"
    log "Success."
  end
rescue StandardError => e
  log "Error: #{e.message}"
  exit -1
end
