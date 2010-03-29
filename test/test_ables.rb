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
       should "default to false" do
         user = mock('user', :can_view? => false)
         assert ! @resource.viewable_by?(user)
       end

       should "be false if resource is not viewable_by?" do
         user = mock('user', :can_view? => true)
         assert @resource.viewable_by?(user)
       end

       should "be false if resource is blank" do
         assert ! @resource.viewable_by?(nil)
         assert ! @resource.viewable_by?('')
       end
     end
     
     context "creatable_by?" do
        should "default to false" do
          user = mock('user', :can_create? => false)
          assert ! @resource.creatable_by?(user)
        end

        should "be false if resource is not creatable_by?" do
          user = mock('user', :can_create? => true)
          assert @resource.creatable_by?(user)
        end

        should "be false if resource is blank" do
          assert ! @resource.creatable_by?(nil)
          assert ! @resource.creatable_by?('')
        end
      end
      
      context "updatable_by?" do
         should "default to false" do
           user = mock('user', :can_update? => false)
           assert ! @resource.updatable_by?(user)
         end

         should "be false if resource is not updatable_by?" do
           user = mock('user', :can_update? => true)
           assert @resource.updatable_by?(user)
         end

         should "be false if resource is blank" do
           assert ! @resource.updatable_by?(nil)
           assert ! @resource.updatable_by?('')
         end
       end
       
       context "destroyable_by?" do
          should "default to false" do
            user = mock('user', :can_destroy? => false)
            assert ! @resource.destroyable_by?(user)
          end

          should "be false if resource is not destroyable_by?" do
            user = mock('user', :can_destroy? => true)
            assert @resource.destroyable_by?(user)
          end

          should "be false if resource is blank" do
            assert ! @resource.destroyable_by?(nil)
            assert ! @resource.destroyable_by?('')
          end
        end
  end
  
end