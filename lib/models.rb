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
  key :summary, String
  key :project_id, ObjectId
  timestamps!
  
  belongs_to :project
  many :links
  many :tags
  
  def add_links(links)
    links = Jkl::links Jkl::headlines query
    links.each{|l|
      self.links << Link.new(:url => l)
    }
  end
  
  def add_tags
    
  end

end

class Link
  include MongoMapper::Document
  
  key :url, String
  key :document, Binary, :index => true 
  key :search_id, ObjectId
  timestamps!

  belongs_to :search
end

class Tag
  include MongoMapper::Document
  
  key :type, String
  key :value, String
  
  key :search_id, ObjectId
  timestamps!
  
  belongs_to :search

end

