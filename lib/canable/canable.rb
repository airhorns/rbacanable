module Canable
  
  # Module that holds all the can_action? methods.
  module Cans; end

  # Module that holds all the [method]able_by? methods.
  module Ables; end
  
  # Holds all the different roles that an actor may assume
  module Roles
    # Make one default role that is false for everything
    module Role
      include Canable::Role
      default_response false
    end
  end

  # Exception that gets raised when permissions are broken for whatever reason.
  class Transgression < StandardError; end

  # Default actions to an empty hash.
  @actions = {}
  
  # Returns hash of actions that have been added.
  #   {:view => :viewable, ...}
  def self.actions
    @actions
  end
  
  # Adds an action to actions and the correct methods to can and able modules.
  #
  #   @param [Symbol] can_method The name of the can_[action]? method.
  #   @param [Symbol] resource_method The name of the [resource_method]_by? method.
  def self.add(can, able)
    @actions[can] = able
    add_can_method(can)
    add_able_method(can, able)
    add_enforcer_method(can)
  end
  
  def self.run_callbacks(callback, options)
    @callbacks.run_callbacks(callback, options) { |result, object| result == false }
  end
  
  private
    def self.add_can_method(can)
      Cans.module_eval <<-EOM
        def can_#{can}?(resource)
          self.__initialize_canable_role if self.class.include?(Canable::Actor)
          self.run_callback(:before_query, {:can => self, :able => resource, :permission => :#{can}})
          method = ("can_#{can}_"+resource.class.name.gsub(/::/,"_").downcase+"?").intern
          if self.respond_to?(method, true)
            result = self.send method, resource
          elsif self.respond_to?(:_canable_default)
            result = self._canable_default
          else
            result = false
          end
          self.run_callback(:after_query, {:can => self, :able => resource, :permission => :#{can}, :result => result})
          result
        end
      EOM
    end

    def self.add_able_method(can, able)
      Ables.module_eval <<-EOM
        def #{able}_by?(actor)
          return false if actor.blank?
          actor.can_#{can}?(self)
        end
      EOM
    end

    def self.add_enforcer_method(can)
      Enforcers.module_eval <<-EOM
        def enforce_#{can}_permission(resource)
          raise Canable::Transgression unless can_#{can}?(resource)
        end
        private :enforce_#{can}_permission
      EOM
    end
end