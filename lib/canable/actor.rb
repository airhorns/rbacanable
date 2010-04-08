module Canable
  module Actor
    attr_accessor :canable_included_role
    
    def self.included(base)
      base.instance_eval do
        include Canable::Cans
      end
      class << base
        include ClassMethods
      end
    end

    # Override attr_accessor to make sure the role has been included so that we can return an accurate value
    # "lazy" role including
    def canable_included_role
      self.__initialize_canable_role
      @canable_included_role
    end
    
    # Called every time a role is needed to make sure the lazy load has been completed
    def __initialize_canable_role
      return if @_canable_initialized == true 
      @_canable_intialize == true
      role_constant = self.__get_role_constant
      if role_constant == nil
        default_role = self.class.canable_default_role
        self.act(default_role) unless default_role == nil
      else
        self.act(role_constant)
      end
    end
    
    def __get_role_constant
      if self.class.canable_role_proc.respond_to?(:call)
        attribute = self.class.canable_role_proc.call(self)
      elsif self.instance_variable_get(:@role)
        attribute = @role
      end
      attribute || nil
    end
    
    # Sets the role of this actor by including a role module
    def act(role)
      unless(role.respond_to?(:included))
        role = Canable::Roles.const_get((role.to_s.capitalize+"Role").intern)
      end
      self.extend role
      self.canable_included_role = role
    end
    
      # ---------------
      # RBAC Actor building DSL
      # ---------------
    
    module ClassMethods
      attr_accessor :canable_default_role
      attr_accessor :canable_role_proc
            
      def default_role(role)
        self.canable_default_role = role
      end
      
      def role_attribute(attribute)
        self.canable_role_proc = Proc.new {|actor|
          role = actor.instance_variable_get(attribute)
        }
      end
      
      def role_proc(proc)
        self.canable_role_proc = proc
      end
      
    end
  end
end