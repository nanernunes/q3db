#!/usr/bin/env ruby
$LOAD_PATH.unshift( File.join 'lib' )

require 'i18n'
require 'rake'
require 'yaml'
require 'active_record'
# Opened an issue to rename it to a short version.
require 'rails/observers/activerecord/active_record'
require 'quakeentry'
require 'quakecount'

# Load all available locales and makes the English the default
I18n.load_path = Dir[ File.join('config','locales','*.yml') ]
I18n.backend.load_translations
I18n.locale = :en

# Establish the database connection
ActiveRecord::Base.establish_connection(
  YAML::load( File.open('config/database.yml') )['production']
)

# Invoke the rake db:migrate
Rake.application.init
Rake.application.load_rakefile
Rake::Task['db:migrate'].invoke

# Creates the Database references
Dir.glob( File.join File.dirname(__FILE__),'app','models','**/*.rb' )
  .sort_by { |file| file.count "/" }.each { |file| require file }

ActiveRecord::Base.add_observer PersistenceObserver.instance


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
