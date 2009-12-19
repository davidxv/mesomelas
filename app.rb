require 'rubygems'
require 'sinatra'
require 'hpricot'
require 'json'
require "mongo_mapper"
require "haml"
require 'cgi'
require 'sinatra/chowder'
require "chowder"
require 'rack-flash'
require "jkl"

require "lib/models"

include Mongo
include Jkl

config = YAML::load_file('config/config.yml')

enable :sessions
use Rack::Flash


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
  # TODO Sinatra::Application.environment.inspect sniff
  require_user
  @user = current_user
  @projects = @user.projects
  twitter_json_url = config['twitter'] 
#  output = JSON.parse Jkl::get_from twitter_json_url
  @trends = []
#  @trends = output['trends']
  haml :index
end

get "/projects/:name" do
  @project = Project.find_by_user_id_and_name(current_user.id, params[:name])
  @searches = @project.searches
  @user = current_user
  haml :project
end

post "/project" do
  p = Project.new({:name => CGI::unescape(params["name"])})
  
  if(!Project.exists?(:conditions => 
      {:name => p.name, :user_id => current_user.id}))
    current_user.projects << p
    current_user.save!
  else
    flash[:notice] = "You already have a project with that name"
  end
  @user = current_user
  @projects = @user.projects
  @trends = []
  redirect "/"
end

get "/projects/:project_name/searches/:query" do
  @project = Project.find_by_user_id_and_name(current_user.id, params[:project_name])
  @search = Search.find_by_project_id_and_query(@project.id, params[:query])
  @user = current_user
  haml :search
end

get "/projects/:project_id/delete" do
  Project.find(params[:project_id]).destroy
  redirect "/"
end

post "/search" do
  s = Search.new({:query => CGI::unescape(params["query"]) })
  p = Project.find(params["project_id"])
  if(!Search.exists?(:conditions => 
      {:query => s.query, :project_id => p.id}))
    #add links and description to search object
    headlines = Jkl::headlines(s.query)
    Jkl::links(headlines).each{|l|
      s.links << Link.new(:url => l)
    }
    s.summary = Jkl::pages(headlines)
    p.searches << s
    p.save!
  else
    flash[:notice] = "You already have a search with that name in this project"
  end
  redirect "/projects/#{CGI::escape(p.name)}"
end

get "/projects/:project_id/searches/:search_id/delete" do
  s = Search.find(params[:search_id])
  p = Project.find(s.project_id)
  s.destroy
  redirect "/projects/#{CGI::escape(p.name)}"
end

get "/test" do
  #c.entities[45].instances[0].prefix
  @summary = Jkl::pages Jkl::headlines "tiger woods"
  tags = Jkl::tags @summary
  @entities = tags.entities
  haml :results
end

helpers do
  def current_user
    User.find(session[:current_user])
  end
end

