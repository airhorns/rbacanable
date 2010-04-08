module Canable
  # Module that is included by a role implementation
  module Role
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    # These are applied to the actual Role module 'instance' that includes this (Canable::Role) module 
    module ClassMethods
      # Each role has a default query response, found in this variable
      attr_accessor :_default_response
      
      
      # Called when another Role imeplementation module tries to inherit an existing Role implementation
      # Notice this method isn't self.included, this method becomes self.included on the module including this (Canable::Role) module
      # This is nesscary to emulate inhertance of the default response and any other variables in the future
      def included(base)
        base._default_response = self._default_response
      end
      
      # Called when an Actor decides its role and extends itself (an instance) with a Role implementation
      # Creates the default instance methods for an Actor and persists the can_action? response default down
      def extended(base)
        base.extend(RoleEnabledCanInstanceMethods)
        this_role = self # can't use self inside the instance eval
        base.instance_eval { @_canable_role = this_role }
      end
      
      # Methods given to an instance of an Actor
      module RoleEnabledCanInstanceMethods
        def _canable_default # the role default response
          @_canable_role._default_response
        end
      end
      
      # ----------------------
      # Role building DSL
      # ----------------------
      def default_response(val)
        self._default_response = val
      end
    end
  end
end