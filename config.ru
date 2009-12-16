require "rubygems"
require "sinatra"
require "chowder"
require "app"


config = YAML::load_file('config/config.yml')

mongo_host = config['mongo-host']
mongo_db = config['mongo-db'] 
MongoMapper.connection = Mongo::Connection.new(mongo_host, 27017)
MongoMapper.database = mongo_db
#Search.ensure_index([["raw", 1]])
#MongoMapper.ensure_indexes!


run Sinatra::Application