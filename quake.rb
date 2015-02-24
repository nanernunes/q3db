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
require 'quake_main'

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
Q3DB::Main.run! File.open ARGV[0]
