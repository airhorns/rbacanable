$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'activesupport'
require 'canable'

class User
  include Canable::Cans  
  attr_accessor :name
  
  def initialize(attributes = {})
    @name = attributes[:name]
  end
  
  def can_update_article?(article)
    article.creator == @name
  end
end

class Article
  include Canable::Ables
  attr_accessor :creator
  
  def initialize(attributes = {})
    @creator = attributes[:creator]
  end
end

post1 = Article.new(:creator => "John")
user1 = User.new(:name => "John")
user2 = User.new(:name => "Steve")

puts "Can User1 view Post1? #{user1.can_view?(post1)}"
puts "Can User2 view Post1? #{user2.can_view?(post1)}"
puts "Is Post1 viewable by User1? #{post1.viewable_by?(user1)}"
puts "Is Post1 viewable by User2? #{post1.viewable_by?(user2)}"
puts 
puts "Can User1 update Post1? #{user1.can_update?(post1)}"
puts "Can User2 update Post1? #{user2.can_update?(post1)}"
puts "Is Post1 updatable by User1? #{post1.updatable_by?(user1)}"
puts "Is Post1 updatable by User2? #{post1.updatable_by?(user2)}"
