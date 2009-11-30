require "rubygems"
require "sinatra"
require "chowder"
require "app"

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
  
run Sinatra::Application
