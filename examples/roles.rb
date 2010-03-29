$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'active_support'
require 'canable'
require 'terminal-table/import'


module Canable::Roles
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

  module ManagerRole
    include Canable::Role
    include EmployeeRole
        
    def can_destroy_article?(article)
      true
    end
  end

  module AdminRole
    include Canable::Role
    default_response true
    
    def can_create_article?(article)
      false
    end
  end
end

class User
  include Canable::Actor
  attr_accessor :name
    
  def initialize(attributes = {})
    @name = attributes[:name]
    @role = attributes[:role]
    role
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
  User.new(:name => "Steve", :role => :manager),
  User.new(:name => "Harry", :role => :admin)
]

posts = [
  Article.new(:creator => "John"),
  Article.new(:creator => "Steve"),
  Article.new(:creator => "Harry")
]

def check_method(obj, regex=nil)
  regex ||= /canable|lol|test|extended/
  puts obj
  puts obj.methods.sort.grep(regex)
  puts obj._canable_default if obj.respond_to?(:_canable_default)
  puts 
end

check_method(users.first)
check_method(users.first.class)
check_method(users.first.class.class)

puts

check_method(Canable::Roles::EmployeeRole)
check_method(Canable::Roles::ManagerRole)
check_method(Canable::Roles::AdminRole)


user_table = table do |t|
  t.headings = "User", "Resource", "Can View?", "Can Create?", "Can Update?", "Can Destroy?"
  users.each do |user|
    posts.each do |post|
      t << [user.to_s, post.to_s, user.can_view?(post), user.can_create?(post), user.can_update?(post), user.can_destroy?(post)]
    end
  end
end
puts user_table
