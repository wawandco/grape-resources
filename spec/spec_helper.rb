require 'grape/resources'
require 'active_record'
require 'database_cleaner'
require 'factory_girl'
require "rack/test"
require "grape"

ENV["RAILS_ENV"] = "test"

RSpec.configure do |config|
  # Remove this line if you don't want RSpec's should and should_not
  
  ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database => ':memory:'
  )
  
  load File.dirname(__FILE__) + '/support/schema.rb'
  
  
  Dir["#{File.dirname(__FILE__)}/support/models/*.rb"].each {|f| require f}  
  Dir["#{File.dirname(__FILE__)}/factories/*.rb"].each {|f| require f }
  Dir["#{File.dirname(__FILE__)}/support/*.rb"].each{ |f| require f }
  
  # methods or matchers
  require 'rspec/expectations'
  config.include RSpec::Matchers

  config.include Rack::Test::Methods

  # == Mock Framework
  config.mock_with :rspec
  
  include FactoryGirl::Syntax::Methods
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end
  
  config.before :each do
    DatabaseCleaner.start    
  end
  
  config.after :each do
    DatabaseCleaner.clean
  end

  RSpec.configure do |config|
    config.include Rack::Test::Methods
  end
  
end