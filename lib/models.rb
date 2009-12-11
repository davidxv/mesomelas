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

  def self.exists_for_user(user_id, project_name)
    projects = User.find(user_id).projects
    projects.select { |p| p.name == project_name }[0]
  end
  
end

class Search
  include MongoMapper::Document

  key :query, String
  key :project_id, ObjectId
  timestamps!
  
  belongs_to :project
  many :tags
  
  def self.exists_for_project(project_id, query)
    searches = Project.find(project_id).searches
    searches.select { |s| s.query == query }[0]
  end
  
end

class Tag
  include MongoMapper::Document
  
  key :url, String
  key :search_id, ObjectId
  timestamps!
  
  belongs_to :search

end

class Link
  include MongoMapper::Document
  
  key :url, String
  key :search_id, ObjectId
  key :raw, Binary, :index => true 
  timestamps!

  belongs_to :search
end