require 'helper'

class RolesTest < Test::Unit::TestCase
  context "Class with a Canable::Role included" do
    setup do
      @resource = mock('resource')
    end
    
    
    context "and with the canable default set to true" do
      setup do
        roleklass = Module.new do
          include Canable::Roles
          default true
        end
        
        userklass = Class.new do
          include roleklass          
        end
            
        @user = userklass.new
      end
    
      should "default viewable_by? to true" do
        assert @user.can_view?(@resource)
      end

      # should "default creatable_by? to true" do
      #         assert @user.can_create?(@resource)
      #       end
      # 
      #       should "default updatable_by? to true" do
      #         assert @user.can_update?(@resource)
      #       end
      # 
      #       should "default destroyable_by? to true" do
      #         assert @user.can_destroy?(@resource)
      #       end
    end
  end
  
  # context "Class that overrides a can method" do
  #     setup do
  #       klass = Doc do
  #         include Canable::Cans
  #         
  #         def can_view?(resource)
  #           resource.owner == 'John'
  #         end
  #       end
  #       
  #       @user = klass.new
  #       @johns     = mock('resource', :owner => 'John')
  #       @steves    = mock('resource', :owner => 'Steve')
  #     end
  #     
  #     should "use the overriden method and default to false" do
  #       assert @user.can_view?(@johns)
  #       assert ! @user.can_view?(@steves)
  #     end
  # end
end