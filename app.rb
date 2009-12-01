require 'rubygems'
require 'sinatra'
require 'hpricot'
require 'json'
require "mongo_mapper"
require "haml"
require 'cgi'
require 'sinatra/chowder'
require "chowder"

require "lib/models"

include Mongo


mongo_host = YAML::load_file('config/config.yml')['mongo-host']
mongo_db = YAML::load_file('config/config.yml')['mongo-db'] 
MongoMapper.connection = Mongo::Connection.new(mongo_host, 27017)
MongoMapper.database = mongo_db

use Chowder::Basic,{
  :login => lambda do |login, password|
    user = User.first(:login => login , :password => password) and user.id
  end,
  :signup => lambda do |params|
    u = User.new({:login => params["login"], 
        :password => params["password"], :executed_at => Time.now})
    if !User.exists?(:login => params["login"], :password => params["password"])
      u.save
    else 
      return [false, "user already exists"] 
    end
    if User.find(u.id) != nil
      [true, u.id]
    else
      [false, *("unable to sign up")]
    end
  end
  }

  
get '/' do
  require_user
  @user = current_user
  haml :index
end

helpers do
  def current_user
    User.find(session[:current_user])
  end
end
