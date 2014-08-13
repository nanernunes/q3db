require 'yaml'
require 'active_record'

Rake::TaskManager.record_task_metadata = true

task :default do
  Rake::application.options.show_tasks = :tasks
  Rake::application.options.show_task_pattern = //
  Rake::application.display_tasks_and_comments
end

namespace :db do

  ActiveRecord::Migration.verbose = false

  desc "Migrate the database schema through db/migrate files."
  task :migrate => :environment do
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end

  desc "Drop all tables from the default project database."
  task :down => :environment do
    ActiveRecord::Migrator.down('db/migrate')
  end

  # Only to be possible run [ rake db:task ] outside the application.
  task :environment do
    ActiveRecord::Base.establish_connection (
      YAML::load( File.open('config/database.yml') )[ ENV["RAKE_ENV"] ||= 'production'] )
  end

end