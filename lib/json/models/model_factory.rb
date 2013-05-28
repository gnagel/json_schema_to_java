require 'active_support/inflections'
require 'active_support/inflector/methods'
require 'uri'

module Json
  module Models

    class ModelFactory
      attr_accessor :name
      attr_accessor :required
      attr_accessor :properties
      
      def initialize(opts)
        opts.requires_keys_are_not_nil(:name, :requried, :properties)
        
        @name       = opts[:name]
        @required   = opts[:required]
        @properties = opts[:properties]
      end
      
      def to_java
        raise "Not implemented error"
      end
      
      def class_declaration
        raise "Not implemented error"
      end
      
      def class_body
        raise "Not implemented error"
      end
    end
    
  end
end
