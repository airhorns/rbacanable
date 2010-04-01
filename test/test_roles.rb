require 'helper'

class RolesTest < Test::Unit::TestCase
  context "Users with a Canable::Role included" do
    setup do
      @resource = mock('resource')
    end
    
    
    context "and with the role default set to true" do
      setup do
        roleklass = Module.new do
          include Canable::Role
          default_response true
        end
        
        userklass = Class.new do
          include Canable::Actor          
        end
            
        @user = userklass.new
        @user.act roleklass
      end
    
      should "default viewable_by? to true" do
        assert @user.can_view?(@resource)
      end

      should "default creatable_by? to true" do
        assert @user.can_create?(@resource)
      end

      should "default updatable_by? to true" do
        assert @user.can_update?(@resource)
      end

      should "default destroyable_by? to true" do
        assert @user.can_destroy?(@resource)
      end
    end
    
    context "and with the role default set to false" do
      setup do
        roleklass = Module.new do
          include Canable::Role
          default_response false
        end
        
        userklass = Class.new do
          include Canable::Actor          
        end
            
        @user = userklass.new
        @user.act roleklass
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
    
    context "which inherits from another role should persist the default response" do
      setup do
        baseroleklass = Module.new do
          include Canable::Role
          default_response true
        end
        
        roleklass = Module.new do
          include Canable::Role
          include baseroleklass
        end
        
        userklass = Class.new do
          include Canable::Actor          
        end
            
        @user = userklass.new
        @user.act roleklass
      end
    
      should "default viewable_by? to true" do
        assert @user.can_view?(@resource)
      end

      should "default creatable_by? to true" do
        assert @user.can_create?(@resource)
      end

      should "default updatable_by? to true" do
        assert @user.can_update?(@resource)
      end

      should "default destroyable_by? to true" do
        assert @user.can_destroy?(@resource)
      end
    end
    
  end
  
  context "With several roles" do
    setup do
      @role1klass = Module.new do
        include Canable::Role
        default_response true
      end
      
      @role2klass = Module.new do
        include Canable::Role
        default_response false
      end
      
      @resource = mock('resource');
    end
    
    context "and actors with a default role" do
      setup do
        role1klass = @role1klass
        userklass = Class.new do
          include Canable::Actor
          default_role role1klass
          
          def initialize(role=nil)
            @role = role
            self.__initialize_canable_role # nessecary since initialize is overridden
          end
        end
        
        @default_user = userklass.new
        @nondefault_user = userklass.new(@role2klass)
      end
      
      should "have included the correct roles" do
        assert_equal @role1klass, @default_user.canable_included_role
        assert_equal @role2klass, @nondefault_user.canable_included_role 
      end
      
      should "be governed by the rules in their roles" do
        assert @default_user.can_view?(@resource)
        assert ! @nondefault_user.can_view?(@resource)
      end
      
    end
    
    context "and actors with a default role and non standard role attribute" do
      setup do
        role1klass = @role1klass
        userklass = Class.new do
          include Canable::Actor
          default_role role1klass
          role_attribute :@nonstandard
          
          def initialize(role=nil)
            @nonstandard = role
            self.__initialize_canable_role # nessecary since initialize is overridden
          end
        end
        
        @default_user = userklass.new
        @nondefault_user = userklass.new(@role2klass)
      end
      
      should "have included the correct roles" do
        assert_equal @role1klass, @default_user.canable_included_role
        assert_equal @role2klass, @nondefault_user.canable_included_role 
      end
      
      should "be governed by the rules in their roles" do
        assert @default_user.can_view?(@resource)
        assert ! @nondefault_user.can_view?(@resource)
      end
    end
    
    context "and actors with a default role and a role proc" do
      setup do
        role1klass = @role1klass
        userklass = Class.new do
          include Canable::Actor
          attr_accessor :attributes
          
          default_role role1klass
          role_proc Proc.new {|actor| actor.attributes[:role]}
          
          def initialize(role=nil)
            @attributes = {}
            @attributes[:role] = role
            self.__initialize_canable_role # nessecary since initialize is overridden
          end
        end
        
        @default_user = userklass.new
        @nondefault_user = userklass.new(@role2klass)
      end
      
      should "have included the correct roles" do
        assert_equal @role1klass, @default_user.canable_included_role
        assert_equal @role2klass, @nondefault_user.canable_included_role 
      end
      
      should "be governed by the rules in their roles" do
        assert @default_user.can_view?(@resource)
        assert ! @nondefault_user.can_view?(@resource)
      end
    end
  end
  
  context "With several users with specific Canable::Roles inherited and included" do
      setup do
        
        # Default role where nothing is possible
        baseroleklass = Module.new do
          include Canable::Role
          default_response false
        end
        
        # Medium level role where update, create, destroy are possible if you are the owner, and view is always possible
        roleklass = Module.new do
          include Canable::Role
          include baseroleklass
          
          def can_update_mocha_mock?(mock)
            mock.owner == @name
          end
          
          def can_create_mocha_mock?(mock)
            self.can_update_mocha_mock?(mock)
          end
          
          def can_destroy_mocha_mock?(mock)
            self.can_update_mocha_mock?(mock)
          end
          
          def can_view_mocha_mock?(mock)
            true
          end
        end
        
        # Elevated role who can update anything but only destroy their own
        elevatedroleklass = Module.new do
          include Canable::Role
          include roleklass
          
          def can_update_mocha_mock?(mock)
            true
          end
          
          def can_destroy_mocha_mock?(mock)
            if mock.owner == @name
              true
            else
              false
            end
          end
        end
        
        # Super admin class who can do anything
        superroleklass = Module.new do
          include Canable::Role
          default_response true
        end
        
        # Include Actor for a user        
        userklass = Class.new do
          include Canable::Actor 
          def initialize(_name, _role)
            @name = _name
            @role = _role
            self.__initialize_canable_role # nessecary since initialize is overridden
          end         
        end
            
        @john = userklass.new("John", baseroleklass)
        @steve = userklass.new("Steve", roleklass)
        @carli = userklass.new("Carli", elevatedroleklass)
        @harry = userklass.new("Harry", superroleklass)    
      end
      
      context "and plain resources" do
        setup do
          @johns  = mock('resource') do expects(:owner).returns("John").times(0) end
          @steves = mock('resource') do expects(:owner).returns("Steve").times(0) end
          @harrys = mock('resource') do expects(:owner).returns("Harry").times(0) end
        end
        
        context "the user without permissions" do
          should "not be able to do anything" do
            [@johns, @steves, @harrys].each do |r|
              assert ! @john.can_view?(r)
              assert ! @john.can_update?(r)
              assert ! @john.can_destroy?(r)
              assert ! @john.can_create?(r)
            end
          end
        end
      end
      
      context "and resources that belong to them" do
        context "the owner of a resource" do
          setup do
            @steves = mock('resource1') do expects(:owner).returns("Steve").times(3) end
            @harrys = mock('resource2') do expects(:owner).returns("Harry").times(0) end
            @carlis = mock('resource3') do expects(:owner).returns("Carli").times(1) end
          end
          
          should "be able to CRUD their resource" do
            assert @steve.can_update?(@steves)
            assert @steve.can_create?(@steves)
            assert @steve.can_destroy?(@steves)
            assert @steve.can_view?(@steves)
            
            assert @harry.can_update?(@harrys)
            assert @harry.can_create?(@harrys)
            assert @harry.can_destroy?(@harrys)
            assert @harry.can_view?(@harrys)
            
            assert @carli.can_update?(@carlis)
            assert @carli.can_create?(@carlis)
            assert @carli.can_destroy?(@carlis)
            assert @carli.can_view?(@carlis)
          end
        end
        
        context "a user who isn't the owner of a resource" do
          setup do
            @noones = mock('resource')
            @noones.expects(:owner).returns("noone").times(2)
          end
          should "not be able to destroy the resource" do
            [@john, @steve, @carli].each do |u|
              assert ! u.can_destroy?(@noones)
            end
          end
        end
        
        context "the user with elevated permissions" do
          setup do
            @johns  = mock('resource') do expects(:owner).returns("John").times(0..1) end
            @steves = mock('resource') do expects(:owner).returns("Steve").times(0..1) end
            @carlis = mock('resource') do expects(:owner).returns("Carli").times(0..1) end
          end
          
          should "be able to edit anyones resource" do
            assert @carli.can_update?(@steves)
            assert @carli.can_update?(@johns)
            assert @carli.can_update?(@carlis)
          end
          
          should "not be able to destroy anyone else's resource" do
            assert ! @carli.can_destroy?(@steves)
            assert ! @carli.can_destroy?(@johns)
            assert @carli.can_destroy?(@carlis)
          end
        end
        
        context "the super user" do
          setup do
            @johns  = mock('resource') do expects(:owner).returns("John").times(0) end
            @steves = mock('resource') do expects(:owner).returns("Steve").times(0) end
            @harrys = mock('resource') do expects(:owner).returns("Harry").times(0) end
          end
          
          should "be able to do anything to anyone's resource" do
            [@johns, @steves, @harrys].each do |r|
              assert  @harry.can_view?(r)
              assert  @harry.can_update?(r)
              assert  @harry.can_destroy?(r)
              assert  @harry.can_create?(r)              
          end
        end
      end
    end
  end
end