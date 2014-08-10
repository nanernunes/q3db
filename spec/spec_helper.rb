require 'yaml'
require 'active_record'

# Define the environment
ENV['RAKE_ENV'] = 'test'

# Establish the database connection
ActiveRecord::Base.establish_connection(
  YAML::load( File.open('config/database.yml') )[ENV['RAKE_ENV']]
)

# Add the model directory to the Global Application Path
$LOAD_PATH.unshift( 
    File.join(File.dirname(__FILE__), '..', 'app', 'models')
)

# Suppresses the verbosity of migration
ActiveRecord::Migration.verbose = false

# Setup the test database for all the tests
ActiveRecord::Migrator.migrate 'db/migrate'

# RSpec general settings
RSpec.configure do |config|
  config.order = :random

  config.after(:suite) do
    ActiveRecord::Migrator.down 'db/migrate'
  end
end