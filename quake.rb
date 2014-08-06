#!/usr/bin/env ruby

require 'rake'
require 'yaml'
require 'active_record'
require_relative 'lib/quakeentry'
require_relative 'lib/quakecount'

# Establish the database connection
ActiveRecord::Base.establish_connection(
  YAML::load( File.open('config/database.yml') )['default']
)

# Invoke the rake db:migrate
Rake.application.init
Rake.application.load_rakefile
Rake::Task['db:migrate'].invoke

# Creates a global counter
$counter = QuakeCount.new

# Creates the Database references
Dir.glob File.join(File.dirname(__FILE__),'app','models','*'),
  &method(:require)

# Sets the log file to be monitored
file = File.open ARGV[0]

# Main
while true

  # Return the last commited value (size / time)
  fsize = ((c = Commit.last).nil? ? 0 : c.fsize)
  mtime = ((c = Commit.last).nil? ? 0 : c.mtime)

  sleep 1

  # Commits only new contents to database
  unless (file.mtime.to_i.eql?(mtime))

    file.seek fsize
    lines = file.each_line.take_while { |l| l.match(/\n/) }
    lines.map { |e| QuakeEntry.new(e) }

    Commit.create ({
      :fsize => lines.join.size + fsize,
      :mtime => file.mtime.to_i
    })

  end

end
