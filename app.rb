require 'rubygems'
require 'sinatra'
require 'hpricot'
require 'json'
require "mongo_mapper"
require "haml"
require 'cgi'
require 'sinatra/chowder'
require "chowder"
require "rack-flash"
require "calais"
require "jkl"

require "lib/models"

include Mongo
include Jkl

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
  require_user
  @user = current_user
  @projects = @user.projects
  output = JSON.parse Jkl::get_from "http://search.twitter.com/trends.json"
  @trends = output['trends']
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
    feeds = YAML::load_file('config/feeds.yml')
    source = feeds["topix"]
    headlines = Jkl::headlines(source, CGI::escape(s.query))
    Jkl::get_items_from(headlines).each do |item|
      link = Jkl::attribute_from(item, :link)
      desc = Jkl::attribute_from(item, :description).gsub("<![CDATA[","").gsub("]]>","")
      s.links << Link.new(:url => link, :description => desc)
    end
    p.searches << s
    p.save!
  else
    flash[:notice] = "You already have a search with that name in this project"
  end
  redirect "/projects/#{CGI::escape(p.name)}"
end

get "/link/update/:id" do
  link = Link.find(params[:id])
  search = Search.find(link.search_id)
  project = Project.find(search.project_id)
  begin
    key = ENV['CALAIS_KEY'] || YAML::load_file("config/keys.yml")["calais"]
    tags = Jkl::tags(key, link.description)
    link.entities = tags.entities.map do |e|
      h = Hash.new
      h[e.type] = e.attributes["name"]
      h
    end
    link.save
  rescue Calais::Error => e
    puts("WARN: Calais Error: #{e}")
  end
  redirect "/projects/#{CGI::escape(project.name)}/searches/#{CGI::escape(search.query)}"
end

get "/projects/:project_id/searches/:search_id/delete" do
  s = Search.find(params[:search_id])
  p = Project.find(s.project_id)
  s.destroy
  redirect "/projects/#{CGI::escape(p.name)}"
end

get "/projects/:project_name/searches/:search_query/links/:link_id" do
  @project = Project.find_by_name(params[:project_name])
  @search = Search.find_by_query(params[:search_query])
  @user = current_user
  @link = Link.find(params[:link_id])
  @story = Jkl::sanitize Jkl::from_doc Jkl::get_from @link.url #TODO store
  haml :link
end

get "/test" do
  #c.entities[45].instances[0].prefix
  tags = []
  links = Jkl::links Jkl::headlines "tiger woods"
  links.each do |link|
    story = Jkl::sanitize Jkl::from_doc Jkl::get_from link
    puts story
    puts ""
    puts "end story #{link}"
    begin
      tags << Jkl::tags(story)
    rescue Calais::Error => e
      puts("WARN: Calais Error: #{e}")
    end
  end
  
  puts tags.length
  @entities = tags.entities
  haml :results
end

helpers do
  def current_user
    User.find(session[:current_user])
  end
end

