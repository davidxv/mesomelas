require 'rubygems'
require 'sinatra'
require 'hpricot'
require 'json'
require "mongo_mapper"
require "haml"
require 'cgi'
require 'sinatra/chowder'

require "lib/models"

include Mongo

mongo_host = YAML::load_file('config/config.yml')['mongo-host']
mongo_db = YAML::load_file('config/config.yml')['mongo-db'] 
MongoMapper.connection = Mongo::Connection.new(mongo_host, 27017)
MongoMapper.database = mongo_db

get '/' do
  require_user
  "hello world"
end

helpers do
  def current_user
    User.find(session[:current_user])
  end
end
