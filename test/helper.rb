require 'test/unit'

gem 'mocha', '0.9.8'
gem 'shoulda', '2.10.3'
gem 'activesupport', '2.3.5'

require 'mocha'
require 'shoulda'
require 'active_support'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'canable'

class Test::Unit::TestCase
end

def Doc(name=nil, &block)
  klass = Class.new do
    
    if name
      class_eval "def self.name; '#{name}' end"
      class_eval "def self.to_s; '#{name}' end"
    end
  end

  klass.class_eval(&block) if block_given?
  klass
end

test_dir = File.expand_path(File.dirname(__FILE__) + '/../tmp')
FileUtils.mkdir_p(test_dir) unless File.exist?(test_dir)