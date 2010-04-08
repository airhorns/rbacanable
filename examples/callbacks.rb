$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'activesupport'
require 'canable'
require 'terminal-table/import'

module Canable::Roles
  module BasicRole
    include Canable::Role
    default_response false

  end
  
  module EmployeeRole
    include Canable::Role
    default_response false
    
    def can_destroy_article?(article)
      article.creator == @name
    end
  
    def can_update_article?(article)
      article.creator == @name
    end
  end
end

class User
  include Canable::Actor
  attr_accessor :name
  attr_accessor :role
  
  default_role Canable::Roles::BasicRole
  after_permissions_query :after_query
  
  def after_query(options = {})
    puts "After Query from Basic Role"
  end
  
  def initialize(attributes = {})
    @name = attributes[:name]
    @role = attributes[:role]
  end
  
  def to_s
    "#{@role.to_s}: #{@name}"
  end
end

class Article
  include Canable::Ables
  attr_accessor :creator
  
  def initialize(attributes = {})
    @creator = attributes[:creator]
  end
  
  def to_s
    "#{@creator}'s article"
  end
end

users = [
  User.new(:name => "John", :role => :employee),
  User.new(:name => "Jim")
]

posts = [
  Article.new(:creator => "John"),
  Article.new(:creator => "Jim"),
  Article.new(:creator => "Harry")
]


user_table = table do |t|
  t.headings = "User", "Resource", "Can View?", "Can Create?", "Can Update?", "Can Destroy?", "@role", "Included Role"
  users.each do |user|
    posts.each do |post|
      t << [user.to_s, post.to_s, user.can_view?(post), user.can_create?(post), user.can_update?(post), user.can_destroy?(post), user.role, user.canable_included_role]
    end
  end
end
puts user_table
