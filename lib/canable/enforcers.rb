module Canable
  # Module that holds all the enforce_[action]_permission methods for use in controllers.
  module Enforcers
    def self.included(controller)
      controller.class_eval do
        Canable.actions.each do |can, able|
          delegate      "can_#{can}?", :to => :current_user
          helper_method "can_#{can}?" if controller.respond_to?(:helper_method)
          hide_action   "can_#{can}?" if controller.respond_to?(:hide_action)
        end
      end
    end
  end
end