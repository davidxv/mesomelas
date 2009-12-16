# See http://wiki.github.com/aslakhellesoy/cucumber/sinatra
# for more details about Sinatra with Cucumber

gem "rack-test"
gem "webrat"
gem "sinatra"

# Sinatra
app_file = File.join(File.dirname(__FILE__), *%w[.. .. app.rb])
require app_file
# Force the application name because polyglot breaks the auto-detection logic.
Sinatra::Application.app_file = app_file
Sinatra::Application.show_exceptions = true
require "spec/expectations"
require "rack/test"
require "webrat"

Webrat.configure do |config|
  config.mode = :rack
end

class MyWorld
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
  require "rack/flash/test"
  Webrat::Methods.delegate_to_session :response_code, :response_body
  set :environment, :test
  puts "in env with #{Sinatra::Application.environment} mode"
  config = YAML::load_file('config/config.yml')
  mongo_host = config['mongo-test-host']
  mongo_db = config['mongo-test-db']
  MongoMapper.connection = Mongo::Connection.new(mongo_host, 27017)
  MongoMapper.database = mongo_db
  puts "have set #{MongoMapper.database.inspect}"
  def app
    Sinatra::Application
  end
end

World{MyWorld.new}
