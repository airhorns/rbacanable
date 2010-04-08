require 'helper'

class AblesTest < Test::Unit::TestCase
  context "Class with Canable::Ables included" do
    setup do
      klass = Doc do
        include Canable::Ables
      end

      @resource = klass.new
      @user     = mock('user')
    end
    
    context "viewable_by?" do
       should "be false if user cannot view" do
         user = mock('user', :can_view? => false)
         assert ! @resource.viewable_by?(user)
       end
       
       should "be true if user can view" do
         user = mock('user', :can_view? => true)
         assert @resource.viewable_by?(user)
       end

       should "be false if resource is blank" do
         assert ! @resource.viewable_by?(nil)
         assert ! @resource.viewable_by?('')
       end
    end
   
   context "creatable_by?" do
      should "be false if user cannot create" do
        user = mock('user', :can_create? => false)
        assert ! @resource.creatable_by?(user)
      end

      should "be true if user can create" do
        user = mock('user', :can_create? => true)
        assert @resource.creatable_by?(user)
      end

      should "be false if resource is blank" do
        assert ! @resource.creatable_by?(nil)
        assert ! @resource.creatable_by?('')
      end
    end
    
    context "updatable_by?" do
       should "be false if user cannot update" do
         user = mock('user', :can_update? => false)
         assert ! @resource.updatable_by?(user)
       end

       should "be true if user can update" do
         user = mock('user', :can_update? => true)
         assert @resource.updatable_by?(user)
       end

       should "be false if resource is blank" do
         assert ! @resource.updatable_by?(nil)
         assert ! @resource.updatable_by?('')
       end
     end
     
     context "destroyable_by?" do
        should "be false if user cannot destroy" do
          user = mock('user', :can_destroy? => false)
          assert ! @resource.destroyable_by?(user)
        end

        should "be true if user can destroy" do
          user = mock('user', :can_destroy? => true)
          assert @resource.destroyable_by?(user)
        end

        should "be false if resource is blank" do
          assert ! @resource.destroyable_by?(nil)
          assert ! @resource.destroyable_by?('')
        end
      end
    end
    context "Canable Ables with callbacks defined" do
      setup do
        @resource = mock('resource')

        userklass = Class.new do
          attr_accessor :before_options
          attr_accessor :after_options
          include Canable::Actor          
          before_permissions_query :before
          after_permissions_query :after

          def before(options = {})
            options[:test] = 2+2
            @before_options = options
          end

          def after(options = {})
            options[:test] = 2-3
            @after_options = options
          end
        end

        @user = userklass.new
      end

      context "and a permission query is preformed, " do
        setup do
          @result = @user.can_update?(@resource)
        end
        
        context "before callbacks" do
         subject {@user.before_options}
         should_set_callback_attributes(4)
        end
        
        context "after callbacks" do
          subject{@user.after_options}
          should_set_callback_attributes(-1)
          
          should "have the result in an option" do
            assert_equal @user.after_options[:result], false
          end
        end
      end
    end
end