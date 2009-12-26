require "rubygems"
require "sinatra"
require "chowder"
require "app"


config = YAML::load_file('config/config.yml')

mongo_host = ENV['MONGO_HOST'] || config['mongo-host']
mongo_db   = ENV['MONGO_DB']   || config['mongo-db'] 
mongo_user = ENV['MONGO_USER'] || config['mongo-user'] 
mongo_pass = ENV['MONGO_PASS'] || config['mongo-pass'] 

MongoMapper.connection = Mongo::Connection.new(mongo_host, 27017)
MongoMapper.database = mongo_db
MongoMapper.database.authenticate(mongo_user, mongo_pass)

#Search.ensure_index([["raw", 1]])
#MongoMapper.ensure_indexes!


run Sinatra::Application