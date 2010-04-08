module Canable
  module Cans    
    def self.included(base)
      class << base
        include ClassMethods
      end
    end
    
    def run_callback(name, options)
      cs = self.class.canable_callbacks
      self.send(cs[name], options) if cs[name]
    end
    
      # ---------------
      # RBAC Can/Actor building DSL
      # ---------------
    
    module ClassMethods
      attr_accessor :canable_callbacks
      
      def canable_callbacks
        @canable_callbacks ||= {}
      end
      
      def after_permissions_query(symbol)
        c = self.canable_callbacks
        c[:after_query] = symbol
        self.canable_callbacks = c
      end
      
      def before_permissions_query(symbol)
        c = self.canable_callbacks
        c[:before_query] = symbol
        self.canable_callbacks = c
      end
    end
  end
end