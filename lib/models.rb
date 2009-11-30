class User
  include MongoMapper::Document

  key :login, String
  key :password, String
  key :created_at, Time
  key :last_logged_in_at, Time
  
  many :projects
  
  def self.from_name(name)
    User.all(:login => name)[0]
  end
  
  def self.get_project(user_id, proj_name)
    user = User.find(user_id)
    user.projects.select { |p| p.name == proj_name }[0]
  end
  
  def self.get_list(user_id, proj_id, list_name)
    user = User.find(user_id)
    project = user.projects.select{|p| p.id == proj_id}[0]
    project.lists.select{|l| l.name == list_name}[0]
  end
  
  def self.get_search(user_id, proj_id, list_id, query)
    user = User.find(user_id)
    project = user.projects.select{|p| p.id == proj_id}[0]
    list = project.lists.select{|l| l.id == list_id}[0]
    list.searches.select{|s| s.query == query}[0]
  end
  
  def self.get_link(user_id, proj_id, list_id, search_id, url)
    user = User.find(user_id)
    project = user.projects.select{|p| p.id == proj_id}[0]
    list = project.lists.select{|l| l.id == list_id}[0]
    search = list.searches.select{|s| s.id == search_id}[0]
    search.links.select{|l| l.url == url}[0]
  end
  
  def self.get_result(user_id, proj_id, list_id, search_id, phrase)
    user = User.find(user_id)
    project = user.projects.select{|p| p.id == proj_id}[0]
    list = project.lists.select{|l| l.id == list_id}[0]
    search = list.searches.select{|s| s.id == search_id}[0]
    search.results.select{|r| r.phrase == phrase}[0]
  end
end

class Project
  include MongoMapper::EmbeddedDocument

  key :name, String

  many :lists
end

class List
  include MongoMapper::EmbeddedDocument
  
  key :name, String

  many :searches
end

class Search
  include MongoMapper::EmbeddedDocument

  key :query, String
  key :executed_at, Time
  key :sophia_id, Integer
  key :status, Integer
  key :raw, Binary
  many :links
  many :results
  
  def add_links
    gs = GoogleScraper.new
    numpages = YAML::load_file('config/config.yml')['numpages']
    urls = gs.search(self.query, numpages)
    urls.each{ |link| self.links << Link.new({:url => link}) }
    self.save!
  end
  
  def add_results
    puts "getting results from sophia for #{self.query}"
    doc = Nokogiri::XML(SophiaClient.new.get_results(self.sophia_id))
    puts "received results from sophia"
    last_results = YAML::load_file('config/config.yml')['last_results']
    File.open(last_results, 'w') { |f| f.write(doc.to_s) }
    save_sophia_results_to_search_results(doc)
  end

  def save_sophia_results_to_search_results(doc)
    self.raw = doc.to_s
    doc.search('//result/record').each do |record|
      self.results << Result.new({
        :phrase => record.attributes["phrase"].to_s, 
        :df => record.attributes["df"].to_s, 
        :score => record.attributes["score"].to_s
      })
    end
    puts "saved #{self.results.length} results from sophia"
    puts "with #{self.raw}"
    self.save!
  end
end

class Link
  include MongoMapper::EmbeddedDocument
  
  key :url, String
end

class Result
  include MongoMapper::EmbeddedDocument
  
  key :phrase, String
  key :df, Integer
  key :score, Float
end
