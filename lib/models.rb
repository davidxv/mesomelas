class User
  include MongoMapper::Document

  key :login, String
  key :password, String
  
  timestamps!
  
  validates_uniqueness_of :login
  validates_presence_of :password

  many :projects  
end

class Project
  include MongoMapper::Document

  key :name, String
  key :user_id, ObjectId
  timestamps!
  
  belongs_to :user
  
  many :searches

end

class Search
  include MongoMapper::Document

  key :query, String
  key :project_id, ObjectId
  timestamps!
  
  belongs_to :project
  many :links

end

class Link
  include MongoMapper::Document
  
  key :url, String
  key :description, String 
  key :title, String
  key :search_id, ObjectId
  key :entities, Hash
  # key :relations, Array
  # key :geographies, Array

  timestamps!

  belongs_to :search
end

