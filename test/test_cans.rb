require 'helper'

class CansTest < Test::Unit::TestCase
  context "Class with Canable::Cans included" do
    setup do
      klass = Class.new do
        include Canable::Cans          
      end
      
      @user = klass.new
      @resource = mock('resource')
    end
    
    should "default viewable_by? to false" do
      assert ! @user.can_view?(@resource)
    end

    should "default creatable_by? to false" do
      assert ! @user.can_create?(@resource)
    end

    should "default updatable_by? to false" do
      assert ! @user.can_update?(@resource)
    end

    should "default destroyable_by? to false" do
      assert ! @user.can_destroy?(@resource)
    end
  end
  
  context "Class that overrides a can method" do
    setup do
      klass = Doc do
        include Canable::Cans
        
        def can_view?(resource)
          resource.owner == 'John'
        end
      end
      
      @user = klass.new
      @johns     = mock('resource', :owner => 'John')
      @steves    = mock('resource', :owner => 'Steve')
    end
    
    should "use the overriden method and default to false" do
      assert @user.can_view?(@johns)
      assert ! @user.can_view?(@steves)
    end
  end
end