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
  key :search_id, ObjectId
  key :entities, Array
  key :relations, Array
  key :geographies, Array
  
  #tags.geographies, relations, entities
  #tags.geographies[0].attributes["latitude"], longitude
  #tags.geographies[0].name


  #relation.type, .instances
  # person value = 9600f67f-0fc2-3a6a-b896-7d7e543644df
  
  
  #entity has
    #type
    #attributes hash name, organizationtype nationality - may be others
    #instances[0].exact
  
  #@instances=[#<Calais::Response::Instance:0x1025ec858 
  # @prefix="Gatwick and Manchester Transport Minister ", 
  #   @offset=6316, @suffix=" said he would be \"asking questions\"", 
  #   @exact="Sadiq Khan", @length= 10>
  
  timestamps!

  belongs_to :search
end

