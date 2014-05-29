require 'rake'
require 'yaml'
require 'active_record'

require_relative '../app/models/match'

# Establish the database connection
ActiveRecord::Base.establish_connection(
  YAML::load( File.open('config/database.yml') )['test']
)

# Invoke the rake db:migrate
Rake.application.init
Rake.application.load_rakefile
Rake::Task['db:migrate'].invoke

