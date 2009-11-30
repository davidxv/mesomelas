class User
  include MongoMapper::Document

  key :login, String
  key :password, String
  key :created_at, Time
  key :last_logged_in_at, Time
  
end
