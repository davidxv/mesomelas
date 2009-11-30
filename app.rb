require 'rubygems'
require 'sinatra'
require 'hpricot'
require 'json'
require "mongo_mapper"
require "haml"
require 'cgi'
require 'sinatra/chowder'

require "lib/models"
require "lib/jkl.rb"

include Mongo
include Jkl

mongo_host = YAML::load_file('config/config.yml')['mongo'] 
MongoMapper.connection = Mongo::Connection.new(mongo_host, 27017)
MongoMapper.database = "jkl-history"

get '/' do
  require_user
  twitter_json_url = YAML::load_file('config/config.yml')['twitter'] 
  output = JSON.parse get_from  twitter_json_url
  @trends = output['trends']
  haml :index
end

get '/tags/:keyphrase' do |keyphrase|
  @tags = tags pages headlines keyphrase
  
  @json_obj = JSON.parse( @tags )
  
  haml :feed
end

post '/tags' do
  keyphrase = params[:keyphrase]
  @tags = tags pages headlines keyphrase

  @json_obj = JSON.parse( @tags )

  haml :feed
end

get '/mock_home' do 
  output = JSON.parse File.open('features/mocks/twitter.json','r') {|f| f.readlines.to_s}
  @trends = output['trends']
  haml :index
end

get '/mock' do
  cal_response = File.open('features/mocks/calais.json','r') {|f| f.readlines.to_s}
  @tags = []
  @tags = get_tag_from_json(cal_response)
  @tags.each{|tag| 
    puts ""
    puts tag.inspect
  }
  haml :feed
end

get '/mock_pp' do
  cal_response = File.open('features/mocks/calais.json','r') {|f| f.readlines.to_s}
  @tags = []
  @tags = get_pp_tag_from_json(cal_response)
#  @tags.each{|tag| 
#    puts ""
#    puts tag.inspect
#  }
  haml :feed
end

not_found do
  "Sorry, that page could not be found: #{__FILE__}!"
end

helpers do
  def current_user
    User.find(session[:current_user])
  end
  
  def current_project
    projects = current_user.projects.select {|project| project.id == session["current_project"]}
    projects[0]
  end
end
